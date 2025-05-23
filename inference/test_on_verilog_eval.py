import argparse
import json
import os
import re
from pathlib import Path
from dotenv import load_dotenv
from tqdm import tqdm
from inference_clients import get_client

load_dotenv()

def load_json(filename):
    """load jsonl file"""
    des_data = []
    with open(filename, "r") as f:
        for line in f:
            data = json.loads(line)
            des_data.append(data)
    return des_data

def extract_and_format_code(generated_text):
    """
    Extract and format the Verilog code from the generated text.
    If there's no Verilog code in the text, return the text as is.
    """
    # 1. check if there is a code block
    code_block_pattern = r"```(?:verilog)?(.*?)```"
    code_blocks = re.findall(code_block_pattern, generated_text, re.DOTALL)

    if code_blocks:
        # use the longest code block
        code = max(code_blocks, key=len).strip()
    else:
        # if there is no code block, try to extract the module definition
        module_pattern = r"module\s+.*?endmodule"
        modules = re.findall(module_pattern, generated_text, re.DOTALL)
        if modules:
            code = max(modules, key=len).strip()
        else:
            # if there is no module, return the original text
            return generated_text.strip()

    # 2. remove the testbench code
    index = code.rfind("tb_module")
    if index == -1:
        index = code.find("testbench")
    if index != -1:
        code_tmp = code[:index]
        if "endmodule" in code_tmp:
            code = code_tmp.rsplit("endmodule", 1)[0] + "endmodule"

    # 3. standardize indentation to spaces
    lines = code.split("\n")
    formatted_lines = []
    for line in lines:
        # convert tabs to 4 spaces
        formatted_line = line.replace("\t", "    ")
        formatted_lines.append(formatted_line)
    code = "\n".join(formatted_lines)

    # 4. ensure the code ends with endmodule if it contains a module
    if "module" in code and not code.strip().endswith("endmodule"):
        code = code.strip() + "\nendmodule"

    return code.strip()

def main():
    parser = argparse.ArgumentParser(
        description="Test on Verilog-eval benchmark using various AI models."
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
        "--temperature", type=float, default=0.2, help="Sampling temperature"
    )
    parser.add_argument(
        "--max_tokens", type=int, default=4096, help="Maximum number of tokens to generate"
    )
    parser.add_argument(
        "--output_file", type=str, required=True, help="Output file name"
    )
    parser.add_argument(
        "--output_dir", type=str, required=True, help="Output directory"
    )
    parser.add_argument(
        "--bench_type",
        type=str,
        default="Machine",
        help="Benchmark type: Machine or Human",
    )
    parser.add_argument(
        "--n", type=int, default=20, help="Number of generations per prompt"
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

    # create output directory
    os.makedirs(args.output_dir, exist_ok=True)
    output_path = Path(args.output_dir) / args.output_file

    # load VerilogEval benchmark
    parent_folder = Path(__file__).parent.parent
    descri_path = Path(parent_folder) / f"external/verilog-eval/descriptions/VerilogDescription_{args.bench_type}.jsonl"
    input_path = Path(parent_folder) / f"external/verilog-eval/data/VerilogEval_{args.bench_type}.jsonl"

    des_data = load_json(descri_path)
    input_data = load_json(input_path)

    # copy the dataset n times to generate multiple candidates
    original_des_data = des_data.copy()
    des_data = []
    for _ in range(args.n):
        des_data.extend(original_des_data)

    progress_bar = tqdm(total=len(des_data), desc="Generating")
    client = get_client(client_type)

    # start generating
    for item in des_data:
        try:
            # prepare prompt
            dic = {}
            dic["task_id"] = item["task_id"]
            dic["description"] = (
                "You are a Verilog expert. Be concise and focused on the key points and avoid repetitive thoughts. Provide the Verilog code design directly.\n\n"
                f"{item['detail_description']}\n"
                "Please complete the Verilog code below and return the complete module code. Your code should start with:\n```verilog\n"
            )

            # find the corresponding input prompt
            for input_item in input_data:
                if input_item["task_id"] == dic["task_id"]:
                    dic["prompt"] = input_item["prompt"]
                    break

            full_prompt = dic["description"] + dic["prompt"] + "```"

            # generate completion using the client
            generated_text = client.generate_completion(
                full_prompt,
                model=args.model,
                max_tokens=args.max_tokens,
                temperature=args.temperature
            )

            # remove thinking trace if the model is deepseek r1
            if "DeepSeek-R1" in args.model:
                think_pattern = r"<think>.*?</think>"
                # if the generated text is truncated (no </think>), set it to truncated
                if "</think>" not in generated_text:
                    generated_text = f"The task item {item['task_id']} is truncated."
                else:
                    generated_text = re.sub(think_pattern, "", generated_text, flags=re.DOTALL)

            # extract and format code
            formatted_code = extract_and_format_code(generated_text)
            dic["completion"] = formatted_code

            # write results
            with open(output_path, "a") as f:
                f.write(json.dumps(dic) + "\n")

        except Exception as e:
            print(f"Error processing task {item['task_id']}: {str(e)}")
            continue

        finally:
            progress_bar.update(1)

    progress_bar.close()
    print(f"Completed running command: `python test_on_verilog_eval.py --client_type {client_type} --model {args.model} --temperature {args.temperature} --max_tokens {args.max_tokens} --bench_type {args.bench_type} --n {args.n}`")
    print(f"Results saved to {output_path}.")

if __name__ == "__main__":
    main()
