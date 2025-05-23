# VeriCoder: Enhancing LLM-Based RTL Code Generation through Functional Correctness Validation
![Version](https://img.shields.io/badge/version-1.0.0-blue)
[![arXiv](https://img.shields.io/badge/arXiv-2504.15659-b31b1b.svg)](https://arxiv.org/pdf/2504.15659)
[![License](https://img.shields.io/badge/license-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)
[![Python](https://img.shields.io/badge/Python->=3.11-blue.svg)](https://www.python.org/downloads/)
[![HuggingFace](https://img.shields.io/badge/🤗%20Hugging%20Face-VeriCoder_Datasets-orange.svg)](https://huggingface.co/datasets/LLM4Code/expanded_origen_120k)

## Overview

**VeriCoder** is a model for RTL (Register Transfer Level) code generation, fine-tuned on a novel dataset that is functionally validated via feedback-directed refinement.  
Unlike prior datasets that only ensure syntactic correctness, our dataset guarantees that each RTL design passes automatically generated unit tests aligned with its natural language specification.

### Key Highlights

- **Functionally Validated Dataset**: 125,000+ examples with simulation-passing RTL designs
- **Feedback-Driven Construction**: Iteratively refine designs and tests based on test results
- **Superior Performance**: Achieves up to +71.7% relative improvement on VerilogEval benchmarks
- **Comprehensive Resources**: Includes dataset, model weights, inference scripts, and training pipeline

## Table of Contents

- [Overview](#overview)
- Steps
  - [Initial Setup](#initial-setup)
  - [Running Inference](#running-inference)
- Details
  - [Dataset Generation Flow](#dataset-generation-flow)
  - [Evaluation Benchmarks](#evaluation-benchmarks)
  - [Training Pipeline](#training-pipeline)
- [Citation](#citation)
- [License](#license)

## Initial Setup

1. Clone the repository:

   ```bash
   git clone ...
   cd ...
   ```
   Now in this repo, you have a structure like this:
   ```
    .
    ├── LICENSE
    ├── README.md
    ├── vericoder_env.yml            # Conda environment configuration file
    ├── .env.template                # Template for environment variables
    ├── .gitignore                   # Git ignore rules
    ├── .gitmodules                  # Git submodules configuration
    ├── expand_dataset.py            # Script for expanding training dataset using teacher model
    ├── external/                     # External dependencies
    │   ├── verilog-eval/            # VerilogEval benchmark submodule
    │   └── RTLLM/                   # RTLLM benchmark submodule
    ├── inference/
    │   ├── inference_clients.py     # Client implementations for different model APIs
    │   ├── test_on_rtllm.py        # Script for inference on RTLLM
    │   └── test_on_verilog_eval.py # Script for inference on VerilogEval
    |-- results
    |   |-- RTLLM                    # Directory for RTLLM inference results
    |   |   |-- _qwen14b_sft        # Qwen-14B-SFT model results on RTLLM
    |   |   |-- _...                # Other model results on RTLLM
    |   |-- VerilogEval              # Directory for VerilogEval inference results
    |   |-- qwen14b_sft.jsonl       # Qwen-14B-SFT model results on VerilogEval
    └── └── ...                     # Other model results on VerilogEval
   ```

2. Create a virtual environment and install dependencies:

   ```bash
   conda env create -f vericoder_env.yml
   conda activate vericoder
   ```

3. (Optional) Set up environment variables for API access if you want to evaluate commercial models on VerilogEval and RTLLM benchmarks, or if you want to expand your own dataset with a teacher model. You have two options:

   a. Using `.env` file (recommended):
   ```bash
   # Copy the template file
   cp .env.template .env
   # Edit .env with your API keys
   ```

   b. Using export commands:
   ```bash
   # OpenAI API
   export OPENAI_API_KEY=your_openai_api_key_here
   
   # Google Gemini API
   export GOOGLE_API_KEY=your_google_api_key_here

   # Together AI API
   export TOGETHER_API_KEY=your_together_api_key_here
   ```

   Note: You only need to set the API keys for the services you plan to use. The `.env` file is recommended as it persists across terminal sessions.

## Dataset Expansion Flow

Our dataset is built using a **feedback-directed refinement** pipeline:

- **Initial RTL Design**: Generated from LLM based on natural language
- **Test Generation**: Teacher model generates unit tests for the specification
- **Simulation Feedback**: Simulate and iteratively fix failing designs and/or tests
- **Validation**: Only passing triples (description, RTL, tests) are included

You can expand your own dataset with our script `expand_dataset.py`. To do this, make sure you have installed [iVerilog](https://github.com/steveicarus/iverilog):
```bash
$ git clone https://github.com/steveicarus/iverilog.git && cd iverilog \
        && git checkout v12-branch \
        && sh ./autoconf.sh && ./configure && make -j$(nproc)\
        && make install
```

Currently, we only support using OpenAI models to expand the dataset. To use the script:

```bash
python expand_dataset.py \
    --input_file "path/to/input.jsonl" \
    --output_file "path/to/output.jsonl" \
    --model "gpt-4o-mini" \
    --max_attempts 5 \
    --num_workers 100 \
    --temperature 0.2
```

Parameters:
- `--input_file`: Path to the input JSONL file (required)
- `--output_file`: Path to save the expanded dataset (required)
- `--model`: OpenAI model to use (required)
- `--max_attempts`: Maximum number of attempts per task (default: 5)
- `--num_workers`: Number of worker threads for parallel processing (default: 100)
- `--temperature`: Sampling temperature (default: 0.2)

Make sure you have set up your OpenAI API key in the `.env` file or environment variables before running the script.

## Running Inference

We provide inference scripts to run and save inference results on benchmark VerilogEval-1.0.0 and RTLLM-1.1, supporting models on HuggingFace, OpenAI APIs and Gemini APIs. To generate Verilog code from a natural language description:

```bash
# Run inference on VerilogEval
python inference/test_on_verilog_eval.py \
    --model "LLM4Code/VeriCoder_Qwen14B" \
    --temperature 0.2 \
    --max_tokens 8192 \
    --output_file "results.jsonl" \
    --output_dir "results/VerilogEval" \
    --bench_type "Machine" \
    --n 10

# Run inference on RTLLM
output_folder="vericoder"
python inference/test_on_rtllm.py \
    --model "LLM4Code/VeriCoder_Qwen14B" \
    --temperature 0.2 \
    --max_tokens 8192 \
    --output_dir "results/RTLLM/_$output_folder" \
    --n 5
```

Parameters for VerilogEval:
- `--model`: Model to use (required)
- `--temperature`: Sampling temperature (default: 0.2)
- `--max_tokens`: Maximum number of tokens to generate (default: 2048)
- `--output_file`: Output file name (required)
- `--output_dir`: Output directory (required)
- `--bench_type`: Benchmark type: "Machine" or "Human" (default: "Machine")
- `--n`: Number of generations per prompt (default: 1)

Parameters for RTLLM:
- `--model`: Model to use (required)
- `--temperature`: Sampling temperature (default: 0.2)
- `--max_tokens`: Maximum number of tokens to generate (default: 2048)
- `--output_dir`: Output directory (required)
- `--n`: Number of candidates per prompt (default: 1)

For both scripts, you can optionally specify `--client_type` ("together", "openai", "gemini", "huggingface"). If not provided, it will be automatically determined based on the model name. Note that since HuggingFace and Together AI models share similar naming patterns, by default we use HuggingFace. If you want to use Together AI, please explicitly specify `--client_type together`.

The inference results of the models reported in our paper are provided in the `results/` folder.

## Evaluation Benchmarks

We evaluate VeriCoder on two leading benchmarks:

- **VerilogEval**: Pass@1, Pass@5, Pass@10 metrics (both Machine and Human splits)
- **RTLLM**: Pass@5 of both Syntax success rate and Functional pass rate

We have already added these two benchmarks as submodules for your convenience:
- VerilogEval (v1.0.0)
- RTLLM (v1.1)

To download and initialize the correct versions of these benchmarks, run:

```bash
git submodule update --init --recursive
```

If you want to pull the latest updates from their respective branches, use:
```bash
git submodule update --remote
```

Tip: To check which branch a submodule is tracking, inspect the .gitmodules file. You can also manually switch branches inside the submodule directory if needed.

### Running VerilogEval Evaluation

VerilogEval requires iVerilog to be installed. If you haven't installed it yet, please refer to the "Dataset Expansion Flow" section for installation instructions.

1. Install the VerilogEval package:
   ```bash
   cd external/verilog-eval
   pip install -e .
   ```

2. To evaluate your generated results, you need to specify the `--problem_file` argument. [VerilogEval](https://github.com/NVlabs/verilog-eval/tree/release/1.0.0) provides two sets of problem evaluations:
   - `data/VerilogEval_Machine.jsonl`
   - `data/VerilogEval_Human.jsonl`

3. Run the evaluation:
   For a quick sanity check, you can run the example samples which should yield 0.5 pass@1:
   ```bash
   evaluate_functional_correctness data/example/ExampleSolution.jsonl --problem_file=data/example/ExampleEval.jsonl
   ```

  For example, to evaluate on the Machine split, run the following command:
   ```bash
   evaluate_functional_correctness path/to/your/results.jsonl --problem_file=external/verilog-eval/data/VerilogEval_Machine.jsonl
   # For Human split, simply change it to VerilogEval_Human.jsonl
   ```

   The evaluation script will generate a new file ending in `_results.jsonl` containing detailed information for each completion, including:
   - Whether the completion passed
   - Execution result: "passed", "timed out", or "failed"

   Note: The script does not evaluate pass@k when there are fewer samples than k. To evaluate with other k values, use `--k=<comma-separated-values>`. For other options, run:
   ```bash
   evaluate_functional_correctness --help
   ```

### Running RTLLM Evaluation

Note that RTLLM benchmark requires a Synopsys VCS license for compilation and simulation. If you don't have access to VCS, you can still use VerilogEval for evaluation.

1. We use RTLLM v1.1 and have already added it as a submodule for your convenience.

2. Navigate to the RTLLM directory:
   ```bash
   cd external/RTLLM
   ```

3. Run the evaluation script:
   ```bash
   python auto_run.py --path <path_to_generated_results> [--test_prefix <test_directory_prefix>]
   ```
   Parameters:
   - `--path` (required): Main directory path for the generated results (e.g., `--path ./results`)
   - `--test_prefix` (optional): Prefix for test directories (default: `test_`)

   The script will output Pass@1 and Pass@5 evaluation results, along with the success rates for syntax and functional tests.

## Citation

If you find VeriCoder helpful in your research, please consider citing:

```plaintext
@article{wei2025vericoder,
  title={VeriCoder: Enhancing LLM-Based RTL Code Generation through Functional Correctness Validation},
  author={Wei, Anjiang and Tan, Huanmi and Suresh, Tarun and Mendoza, Daniel and Teixeira, Thiago SFX and Wang, Ke and Trippel, Caroline and Aiken, Alex},
  journal={arXiv preprint arXiv:2504.15659},
  year={2025}
}
```

## License

Apache License 2.0. See [LICENSE](LICENSE) for details.
