from abc import ABC, abstractmethod
import os
from typing import Optional, Dict, Any
from functools import wraps
import time
import logging
from together import Together
import openai
from google import genai
from threading import Lock
from datetime import datetime, timedelta
from dotenv import load_dotenv
import ollama
from transformers import AutoTokenizer, AutoModelForCausalLM
import torch
from peft import PeftModel, PeftConfig

# Load environment variables from .env file
load_dotenv(override=True)

# configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)
# disable httpx logging
logging.getLogger("httpx").setLevel(logging.WARNING)

class RateLimiter:
    def __init__(self, requests_per_minute: int):
        self.requests_per_minute = requests_per_minute
        self.tokens = requests_per_minute
        self.last_update = datetime.now()
        self.lock = Lock()

    def acquire(self):
        with self.lock:
            now = datetime.now()
            time_passed = (now - self.last_update).total_seconds()
            
            # reset tokens if one minute has passed
            if time_passed >= 60:
                self.tokens = self.requests_per_minute
                self.last_update = now

            # if there are tokens left, use them directly
            if self.tokens > 0:
                self.tokens -= 1
                return True
            
            # if there are no tokens left, wait until the next minute
            wait_time = 60 - time_passed
            logger.info(f"Rate limit reached. Waiting {wait_time:.2f} seconds...")
            time.sleep(wait_time)
            
            # after waiting, reset tokens and update last_update
            self.last_update = datetime.now()
            self.tokens = self.requests_per_minute - 1
            return True

def rate_limit(requests_per_minute: int):
    limiter = RateLimiter(requests_per_minute)
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            limiter.acquire()
            return func(*args, **kwargs)
        return wrapper
    return decorator

def retry_on_error(max_retries: int = 3, delay: float = 1.0):
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            for attempt in range(max_retries):
                try:
                    return func(*args, **kwargs)
                except Exception as e:
                    if attempt == max_retries - 1:
                        logger.error(f"Failed after {max_retries} attempts: {str(e)}")
                        raise
                    logger.warning(f"Attempt {attempt + 1} failed: {str(e)}")
                    time.sleep(delay)
            return None
        return wrapper
    return decorator

class AIClient(ABC):
    @abstractmethod
    def generate_completion(self, prompt: str, **kwargs) -> str:
        pass

class TogetherClient(AIClient):
    def __init__(self, api_key: Optional[str] = None):
        self.api_key = api_key or os.getenv("TOGETHER_API_KEY")
        if not self.api_key:
            raise ValueError("Together API key not found")
        self.client = Together(api_key=self.api_key)

    @retry_on_error()
    def generate_completion(self, prompt: str, **kwargs) -> str:
        response = self.client.chat.completions.create(
            model=kwargs.get("model", "mistralai/Mixtral-8x7B-Instruct-v0.1"),
            messages=[{"role": "user", "content": prompt}],
            max_tokens=kwargs.get("max_tokens", 4096),
            temperature=kwargs.get("temperature", 0.2),
        )
        return response.choices[0].message.content

class OpenAIClient(AIClient):
    def __init__(self, api_key: Optional[str] = None):
        self.api_key = api_key or os.getenv("OPENAI_API_KEY")
        if not self.api_key:
            raise ValueError("OpenAI API key not found")
        openai.api_key = self.api_key
        self.client = openai.OpenAI()

    @retry_on_error()
    def generate_completion(self, prompt: str, **kwargs) -> str:
        response = self.client.chat.completions.create(
            model=kwargs.get("model", "gpt-4"),
            messages=[{"role": "user", "content": prompt}],
            max_completion_tokens=kwargs.get("max_tokens", 4096),
            # temperature=kwargs.get("temperature", 0.2),
        )
        return response.choices[0].message.content

class GeminiClient(AIClient):
    def __init__(self, api_key: Optional[str] = None):
        self.api_key = api_key or os.getenv("GEMINI_API_KEY")
        if not self.api_key:
            raise ValueError("Google Gemini API key not found")
        self.client = genai.Client(api_key=self.api_key)

    @retry_on_error()
    @rate_limit(requests_per_minute=15)  # Gemini's rate limit is 15 RPM
    def generate_completion(self, prompt: str, **kwargs) -> str:
        response = self.client.models.generate_content(
            model=kwargs.get("model", "gemini-pro"),
            contents=prompt,
            config=genai.types.GenerateContentConfig(
                max_output_tokens=kwargs.get("max_tokens", 4096),
                temperature=kwargs.get("temperature", 0.2),
            )
        )
        return response.text

def get_client(client_type: str, api_key: Optional[str] = None) -> AIClient:
    client_map = {
        "together": TogetherClient,
        "openai": OpenAIClient,
        "gemini": GeminiClient,
        "ollama": OllamaClient,
        "huggingface": HuggingFaceClient,
    }
 
    if client_type not in client_map:
        raise ValueError(f"Unsupported client type: {client_type}")
    
    return client_map[client_type](api_key) 

class OllamaClient(AIClient):
    def __init__(self, api_key: Optional[str] = None):
        pass

    @retry_on_error()
    def generate_completion(self, prompt: str, **kwargs) -> str:
        response: ollama.ChatResponse = ollama.chat(
            model=kwargs.get("model", "llama3.2"),
            messages=[{"role": "user", "content": prompt}]
        )
        return response.message.content

class HuggingFaceClient(AIClient):
    def __init__(self, api_key: Optional[str] = None):
        self.device = "cuda:0"
        self.model = None
        self.tokenizer = None

    def _load_model(self, model_name: str):
        # return if the model is already loaded
        if hasattr(self, "model_name") and self.model_name == model_name \
        and self.model is not None and self.tokenizer is not None:
            return

        try:
            # try to load the model as a normal transformers checkpoint
            self.tokenizer = AutoTokenizer.from_pretrained(model_name, padding_side="left")
            self.model = AutoModelForCausalLM.from_pretrained(
                model_name,
                torch_dtype=torch.float16,
                device_map=self.device,
            )
        except (OSError, ValueError):
            # if the model is a LoRA adapter, load the base model 
            # get the base model from the adapter config
            peft_cfg = PeftConfig.from_pretrained(model_name)
            base_name = peft_cfg.base_model_name_or_path

            # load base and tokenizer
            self.tokenizer = AutoTokenizer.from_pretrained(base_name, padding_side="left")
            base = AutoModelForCausalLM.from_pretrained(
                base_name,
                torch_dtype=torch.float16,
                device_map=self.device,
            )

            # load LoRA adapter load
            self.model = PeftModel.from_pretrained(base, model_name)

        self.model.eval()
        self.model_name = model_name

    @retry_on_error()
    def generate_completion(self, prompt: str, **kwargs) -> str:
        model_name = kwargs.get("model", "deepseek-ai/deepseek-coder-7b-instruct-v1.5")
        self._load_model(model_name)
        
        inputs = self.tokenizer([prompt], return_tensors="pt", padding='longest').to(self.device)
        outputs = self.model.generate(
            inputs=inputs.input_ids,
            max_length=len(inputs[0]) + kwargs.get("max_length", 1024),
            pad_token_id=self.tokenizer.eos_token_id,
            do_sample=True,
            temperature=kwargs.get("temperature", 0.2),
            top_p=0.95,
            attention_mask=inputs.attention_mask
        )
        s_full = self.tokenizer.decode(outputs[0][len(inputs[0]):].cpu().squeeze(), skip_special_tokens=True)
        return s_full
