import argparse
import json
import os
import re
from pathlib import Path

from dotenv import load_dotenv
from tqdm import tqdm
from inference_clients import get_client

load_dotenv()

design_list = [
    "accu",
    "adder_8bit",
    "adder_16bit",
    "adder_32bit",
    "adder_pipe_64bit",
    "asyn_fifo",
    "calendar",
    "counter_12",
    "edge_detect",
    "freq_div",
    "fsm",
    "JC_counter",
    "multi_16bit",
    "multi_booth_8bit",
    "multi_pipe_4bit",
    "multi_pipe_8bit",
    "parallel2serial",
    "pe_single",
    "pulse_detect",
    "radix2_div",
    "RAM_single",
    "right_shifter",
    "serial2parallel",
    "signal_generator",
    "synchronizer",
    "alu",
    "div_16bit",
    "traffic_light",
    "width_8to16",
]


def load_testjson(filename):
    """load jsonl file"""
    des_data = []
    with open(filename, "r") as f:
        for line in f:
            data = json.loads(line)
            des_data.append(data)
    return des_data


def extract_verilog_code(s_full, design_name=None, model=None):
    """extract and clean the generated verilog code"""
    # if deepseek r1, remove the thinking trace
    if "DeepSeek-R1" in model:
        if "<think>" in s_full and "</think>" not in s_full:
            return ""  # if the thinking process is not complete, return empty string
        s_full = re.sub(r"<think>.*?</think>", "", s_full, flags=re.DOTALL)

    # First try to extract from verilog code blocks
    verilog_blocks = re.findall(r"```verilog\s*(.*?)\s*```", s_full, re.DOTALL)
    
    if verilog_blocks:
        # If found verilog blocks, return the longest one directly
        return max(verilog_blocks, key=len).strip()
    
    # If no verilog blocks, try to find module directly in the text
    code = s_full.strip()
    
    # Remove any separator lines and explanations
    code = re.sub(r'-{3,}.*?-{3,}', '', code, flags=re.MULTILINE)
    code = re.sub(r'Explanation:.*$', '', code, flags=re.DOTALL | re.IGNORECASE)
    
    # Try to find the specific module if design_name is provided
    if design_name:
        # Look for module with exact name
        module_pattern = rf"module\s+{design_name}\s*\([^)]*\)\s*(.*?)\s*endmodule"
        module_match = re.search(module_pattern, code, re.DOTALL)
        if module_match:
            return module_match.group(0).strip()
    
    # If no specific module found or no design_name, try to find any module
    module_match = re.search(r"module\s+(\w+)\s*\([^)]*\)\s*(.*?)\s*endmodule", code, re.DOTALL)
    if module_match:
        return module_match.group(0).strip()
    
    return code.strip()


def main():
    parser = argparse.ArgumentParser(
        description="Test on RTLLM using various AI models."
    )
    parser.add_argument(
        "--client_type", 
        type=str, 
        required=False,
        choices=["together", "openai", "gemini", "ollama", "huggingface"],
        help="AI client type to use. If not provided, will be automatically determined based on model name."
    )
    parser.add_argument(
        "--model", type=str, required=True, help="Model name to use"
    )
    parser.add_argument(
        "--temperature",
        type=float,
        default=0.2,
        help="Temperature for sampling",
    )
    parser.add_argument(
        "--max_tokens",
        type=int,
        default=2048,
        help="Maximum number of tokens to generate"
    )
    parser.add_argument(
        "--output_dir", type=str, required=True, help="Output directory"
    )
    parser.add_argument(
        "--n", type=int, default=1, help="Number of candidates per prompt"
    )
    args = parser.parse_args()

    # Determine client type based on model name if not provided
    if args.client_type:
        client_type = args.client_type
    else:
        model_name = args.model.lower()
        if model_name.startswith(("gpt", "o")):
            client_type = "openai"
        elif "gemini" in model_name:
            client_type = "gemini"
        else:
            client_type = "huggingface"

    # load RTLLM benchmark
    parent_folder = Path(__file__).parent.parent
    bench_path = Path(parent_folder) / "external/RTLLM/rtllm-1.1-new.jsonl"
    if not os.path.exists(bench_path):
        bench_path = "rtllm-1.1-new.jsonl"  # try the current directory

    if not os.path.exists(bench_path):
        print(f"Warning: cannot find the benchmark file {bench_path}")
        print(
            "Try to find the file in the current directory or other locations"
        )
        return

    bench_data = load_testjson(bench_path)

    # create output directory (support multi-level directory path)
    output_dir = Path(args.output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    # initialize progress bar
    progress_bar = tqdm(total=len(bench_data) * args.n, desc="Generating")

    # get the appropriate client
    client = get_client(client_type)

    # generate results for each candidate
    for iter in range(args.n):
        # create subdirectory for each iteration
        test_dir = output_dir / f"test_{iter+1}"
        test_dir.mkdir(exist_ok=True)

        # process each test item
        for idx, dic in enumerate(bench_data):
            try:
                # prepare prompt
                prompt = (dic["Instruction"] + 
                          "\nPlease complete the Verilog code below and return the complete module code directly:\n```verilog\n" +
                          dic["Input"] + "\n```")

                # generate completion using the client
                generated_text = client.generate_completion(
                    prompt,
                    model=args.model,
                    max_tokens=args.max_tokens,
                    temperature=args.temperature
                )

                # Get design name from the Design field
                design_name = dic.get("Design")
                if design_name is None:
                    print(f"Warning: No Design field found for item {idx+1}")
                    continue

                # clean and extract the verilog code
                verilog_code = extract_verilog_code(generated_text, design_name, args.model)
                # print(f"{generated_text=}\n\n{verilog_code=}")

                # save the code to file
                with open(test_dir / f"{design_name}.v", "w") as f:
                    f.write(verilog_code)

            except Exception as e:
                print(f"Error processing item {idx+1}: {str(e)}")
                continue

            finally:
                progress_bar.update(1)

    progress_bar.close()

    print(f"Completed running command: `python test_on_rtllm.py --client_type {client_type} --model {args.model} --temperature {args.temperature} --max_tokens {args.max_tokens} --n {args.n}`")
    print(f"Results saved to folder {output_dir}.")


if __name__ == "__main__":
    main()
