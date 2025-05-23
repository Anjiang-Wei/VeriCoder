import json
import os
import openai
import subprocess
import re
import uuid
import threading
from queue import Queue
from concurrent.futures import ThreadPoolExecutor
import time
import logging
from tqdm import tqdm
import dotenv
import signal
import argparse
from pathlib import Path

# Configure logging to include timestamps and log levels
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    datefmt="%H:%M:%S"
)


def parse_args():
    parser = argparse.ArgumentParser(description="Expand OriGen dataset with functional validation")
    parser.add_argument(
        "--input_file",
        type=str,
        required=True,
        help="Input JSONL file path"
    )
    parser.add_argument(
        "--output_file",
        type=str,
        required=True,
        help="Output JSONL file path"
    )
    parser.add_argument(
        "--max_attempts",
        type=int,
        default=5,
        help="Maximum number of attempts per task"
    )
    parser.add_argument(
        "--num_workers",
        type=int,
        default=100,
        help="Number of worker threads"
    )
    parser.add_argument(
        "--model",
        type=str,
        required=True,
        help="OpenAI model to use"
    )
    parser.add_argument(
        "--temperature",
        type=float,
        default=0.2,
        help="Sampling temperature"
    )
    return parser.parse_args()


def load_json(filename):
    """Load a JSON Lines file and return a list of JSON objects."""
    data = []
    try:
        with open(filename, "r") as f:
            for line in f:
                data.append(json.loads(line))
    except Exception as e:
        logging.error(f"Failed to load file {filename}: {e}")
    return data


def count_jsonl_entries(filename):
    """Count how many JSON objects exist in a given JSONL file."""
    if not os.path.exists(filename):
        return 0
    count = 0
    try:
        with open(filename, "r") as f:
            for _ in f:
                count += 1
    except Exception as e:
        logging.error(f"Error counting entries in {filename}: {e}")
    return count


def run_iverilog_test(solution: str, test: str) -> tuple:
    """
    Verify the generated Verilog code using Iverilog.
    Returns (True, None) if test passes, (False, error_msg) otherwise.
    On failure, logs reproducing commands for debugging.
    """
    try:
        # Use persistent temporary directory inside "./temp"
        temp_base_dir = "./temp"
        os.makedirs(temp_base_dir, exist_ok=True)
        task_id = str(uuid.uuid4())
        temp_dir = os.path.join(temp_base_dir, task_id)
        os.makedirs(temp_dir, exist_ok=True)
        
        test_file = os.path.join(temp_dir, "test.sv")
        
        # IMPORTANT: Ensure the module definitions from the solution code appear before the testbench.
        # Combine solution code and test code with the correct ordering.
        with open(test_file, 'w') as f:
            # Changed the order: first the solution (module definitions) then the test (testbench)
            verilog_test = solution + "\n" + test
            
            # Adjust file paths in Verilog system tasks to use temp_dir
            verilog_test = re.sub(r'\$dumpfile\("([^"]*)"\)', 
                                f'$dumpfile("{temp_dir}/\\1")', 
                                verilog_test)
            verilog_test = re.sub(r'\$dumpfile\(([^)]*)\)', 
                                f'$dumpfile("{temp_dir}/\\1")', 
                                verilog_test)
            verilog_test = re.sub(r'\$dumpvars\s*\([^)]*\)\s*,\s*([^;]*)', 
                                f'$dumpvars(0, \\1)', 
                                verilog_test)
            verilog_test = re.sub(r'\$fopen\("([^"]*)"\)',
                                  f'$fopen("{temp_dir}/\\1")',
                                  verilog_test)
            verilog_test = re.sub(r'\$fopen\(([^)]*)\)',
                                  f'$fopen("{temp_dir}/\\1")',
                                  verilog_test)
            verilog_test = re.sub(r'\$readmemh\("([^"]*)"\)',
                                  f'$readmemh("{temp_dir}/\\1")',
                                  verilog_test)
            verilog_test = re.sub(r'\$readmemh\(([^)]*)\)',
                                  f'$readmemh("{temp_dir}/\\1")',
                                  verilog_test)
            verilog_test = re.sub(r'\$readmemb\("([^"]*)"\)',
                                  f'$readmemb("{temp_dir}/\\1")',
                                  verilog_test)
            verilog_test = re.sub(r'\$readmemb\(([^)]*)\)',
                                  f'$readmemb("{temp_dir}/\\1")',
                                  verilog_test)
            f.write(verilog_test)
            
        # Remove any pre-existing simulation file (if any)
        vvp_file = os.path.join(temp_dir, "test.vvp")
        if os.path.exists(vvp_file):
            os.remove(vvp_file)
        
        # Compile the Verilog code with Iverilog
        compile_cmd = f"iverilog -Wall -Winfloop -Wno-timescale -g2012 -o {temp_dir}/test.vvp {test_file}"
        compile_result = subprocess.run(
            compile_cmd, shell=True, capture_output=True, text=True, timeout=30)
            
        if compile_result.returncode != 0:
            error_msg = f"Compilation failed: {compile_result.stdout}\n{compile_result.stderr}\nReproducing command: {compile_cmd}"
            logging.error(error_msg)
            return False, error_msg
    
        # Run the simulation
        sim_cmd = f"vvp -n {temp_dir}/test.vvp"
        sim_result = subprocess.run(
            sim_cmd, shell=True, capture_output=True, text=True, timeout=60)
        
        if sim_result.returncode != 0:
            error_msg = f"Simulation failed: {sim_result.stdout}\n{sim_result.stderr}\nReproducing command: {sim_cmd}"
            logging.error(error_msg)
            return False, error_msg
        
        # Check the simulation output for mismatches or success messages
        match = re.search(r'Mismatches: ([0-9]*) in ([0-9]*) samples', sim_result.stdout)
        success_match = re.search(r'All tests passed!|Test passed|Test successful|No errors|Success', sim_result.stdout, re.IGNORECASE)
        
        if success_match:
            logging.info(f"Test success message found: {success_match.group(0)}")
            return True, None
        elif match:
            mismatches, total = [int(i) for i in match.groups()]
            if mismatches == 0:
                return True, None
            else:
                error_msg = f"Test failed: {mismatches} mismatches in {total} samples\nSimulation output: {sim_result.stdout}"
                logging.error(error_msg)
                return False, error_msg
        else:
            if sim_result.returncode == 0 and not re.search(r'error|fail|mismatch|failed', sim_result.stdout, re.IGNORECASE):
                logging.info("No explicit success or failure message found, but simulation completed successfully without errors.")
                return True, None
                
            error_msg = f"Mismatch information not found in simulation output\nSimulation output: {sim_result.stdout}"
            logging.error(error_msg)
            return False, error_msg

    except subprocess.TimeoutExpired as te:
        error_msg = f"Timeout during Iverilog test: {te}"
        logging.error(error_msg)
        return False, error_msg
    except Exception as e:
        error_msg = f"Unexpected error during Iverilog test: {e}"
        logging.error(error_msg)
        return False, error_msg


def get_few_shot_examples():
    """Return a hardcoded few-shot example."""
    example = {
        "task_name": "fsm2",
        "detail_description": "The top module is a simple state machine that has three states, X, Y, and Z. The state transitions are determined by the input signal 'in'. When the state is X, if 'in' is high, the next state is Y, otherwise the next state is Z. When the state is Y, if 'in' is high, the next state is Z, otherwise the next state is X. When the state is Z, if 'in' is high, the next state is X, otherwise the next state is Y. The state is updated on the rising edge of the clock signal 'clk' and reset to state X on the rising edge of the reset signal 'areset'. The output 'out' is high when the state is Z and low otherwise.",
        "canonical_solution": "module top_module (\n    input clk,\n    input in,\n    input areset,\n    output out\n);\n    parameter X=0, Y=1, Z=2;\n    reg [1:0] state, next;\n\n    always_comb begin\n        case (state)\n            X: next = in ? Y : Z;\n            Y: next = in ? Z : X;\n            Z: next = in ? X : Y;\n        endcase\n    end\n\n    always @(posedge clk or posedge areset) begin\n        if (areset) state <= X;\n        else state <= next;\n    end\n\n    assign out = (state == Z);\n\nendmodule",
        "test": "`timescale 1 ps/1 ps\nmodule reference_module (\n    input clk,\n    input in,\n    input areset,\n    output out\n);\n    parameter X=0, Y=1, Z=2;\n    reg [1:0] state, next;\n\n    always_comb begin\n        case (state)\n            X: next = in ? Y : Z;\n            Y: next = in ? Z : X;\n            Z: next = in ? X : Y;\n        endcase\n    end\n\n    always @(posedge clk or posedge areset) begin\n        if (areset) state <= X;\n        else state <= next;\n    end\n\n    assign out = (state == Z);\n\nendmodule\n\nmodule stimulus_gen (\n    input clk,\n    output logic in,\n    output logic areset,\n    output reg[511:0] wavedrom_title,\n    output reg wavedrom_enable,\n    input tb_match\n);\n    reg reset;\n    assign areset = reset;\n    task reset_test(input async=0);\n        bit arfail, srfail, datafail;\n    \n        @(posedge clk);\n        @(posedge clk) reset <= 0;\n        repeat(3) @(posedge clk);\n    \n        @(negedge clk) begin datafail = !tb_match ; reset <= 1; end\n        @(posedge clk) arfail = !tb_match;\n        @(posedge clk) begin\n            srfail = !tb_match;\n            reset <= 0;\n        end\n        if (srfail)\n            $display(\"Hint: Your reset doesn't seem to be working.\");\n        else if (arfail && (async || !datafail))\n            $display(\"Hint: Your reset should be %0s, but doesn't appear to be.\", async ? \"asynchronous\" : \"synchronous\");\n    endtask\n\n    task wavedrom_start(input[511:0] title = \"\");\n    endtask\n    \n    task wavedrom_stop;\n        #1;\n    endtask\n\n    initial begin\n        reset <= 1;\n        in <= 0;\n        @(posedge clk) reset <= 0; in <= 0;\n        @(posedge clk) in <= 1;\n        wavedrom_start();\n            reset_test(1);\n            @(posedge clk) in <= 0;\n            @(posedge clk) in <= 0;\n            @(posedge clk) in <= 0;\n            @(posedge clk) in <= 1;\n            @(posedge clk) in <= 1;\n        @(negedge clk);\n        wavedrom_stop();\n        repeat(200) @(posedge clk, negedge clk) begin\n            in <= $random;\n            reset <= !($random & 7);\n        end\n\n        #1 $finish;\n    end\n    \nendmodule\n\nmodule tb();\n\n    typedef struct packed {\n        int errors;\n        int errortime;\n        int errors_out;\n        int errortime_out;\n\n        int clocks;\n    } stats;\n    \n    stats stats1;\n    \n    \n    wire[511:0] wavedrom_title;\n    wire wavedrom_enable;\n    int wavedrom_hide_after_time;\n    \n    reg clk=0;\n    initial forever\n        #5 clk = ~clk;\n\n    logic in;\n    logic areset;\n    logic out_ref;\n    logic out_dut;\n\n    initial begin \n        $dumpfile(\"wave.vcd\");\n        $dumpvars(1, stim1.clk, tb_mismatch ,clk,in,areset,out_ref,out_dut );\n    end\n\n\n    wire tb_match;        // Verification\n    wire tb_mismatch = ~tb_match;\n    \n    stimulus_gen stim1 (\n        .clk,\n        .* ,\n        .in,\n        .areset );\n    reference_module good1 (\n        .clk,\n        .in,\n        .areset,\n        .out(out_ref) );\n        \n    top_module top_module1 (\n        .clk,\n        .in,\n        .areset,\n        .out(out_dut) );\n\n    \n    bit strobe = 0;\n    task wait_for_end_of_timestep;\n        repeat(5) begin\n            strobe <= !strobe;  // Try to delay until the very end of the time step.\n            @(strobe);\n        end\n    endtask    \n\n    \n    final begin\n        if (stats1.errors_out) $display(\"Hint: Output '%s' has %0d mismatches. First mismatch occurred at time %0d.\", \"out\", stats1.errors_out, stats1.errortime_out);\n        else $display(\"Hint: Output '%s' has no mismatches.\", \"out\");\n\n        $display(\"Hint: Total mismatched samples is %1d out of %1d samples\\n\", stats1.errors, stats1.clocks);\n        $display(\"Simulation finished at %0d ps\", $time);\n        $display(\"Mismatches: %1d in %1d samples\", stats1.errors, stats1.clocks);\n    end\n    \n    // Verification: XORs on the right makes any X in good_vector match anything, but X in dut_vector will only match X.\n    assign tb_match = ( { out_ref } === ( { out_ref } ^ { out_dut } ^ { out_ref } ) );\n    // Use explicit sensitivity list here. @(*) causes NetProc::nex_input() to be called when trying to compute\n    // the sensitivity list of the @(strobe) process, which isn't implemented.\n    always @(posedge clk, negedge clk) begin\n\n        stats1.clocks++;\n        if (!tb_match) begin\n            if (stats1.errors == 0) stats1.errortime = $time;\n            stats1.errors++;\n        end\n        if (out_ref !== ( out_ref ^ out_dut ^ out_ref ))\n        begin if (stats1.errors_out == 0) stats1.errortime_out = $time;\n            stats1.errors_out = stats1.errors_out+1'b1; end\n\n    end\nendmodule"
    }
    
    few_shot_examples = (
        f"## Example {example['task_name']}:\n"
        f"- Task Description: {example['detail_description']}\n"
        f"- Sample Code: {example['canonical_solution']}\n"
        f"- Test: {example['test']}\n\n"
    )
    return few_shot_examples


def gen_solution_test(task_data, few_shot_examples, args):
    """
    Generate a new solution and test for the given task.
    Returns task_data updated with canonical_solution and test.
    """
    system_prompt = (
        "You are an expert Verilog designer and educator with extensive experience in digital circuit design and verification. "
        "Your role is to create high-quality Verilog solutions and tests that are both educational and practical.\n\n"
        "Guidelines:\n"
        "- Read the descriptions carefully and follow all requirements exactly.\n"
        "- Follow Verilog coding standards and best practices.\n"
        "- Ensure your solution is syntactically correct and functionally complete.\n"
        "- Create simple, focused test cases that verify basic requirements.\n"
        "- Use an explicit reset (e.g., rst) when needed to initialize registers and avoid unknown ('X') states.\n"
        "- When writing SystemVerilog tests, ensure that $fatal calls use the correct syntax: for example, use `$fatal(1, \"Error message\")` with a numeric finish code.\n"
    )
    user_prompt = (
        "# Verilog Code Generation and Self-verification Task\n\n"
        "## Input Task Information:\n"
        f"- Task Description: {task_data['Instruction']}\n\n"
        f"- Sample Code: {task_data['Response']}\n\n"
        "## Your Task:\n"
        "1. Generate a complete, self-contained Verilog solution that is syntactically correct and meets all the functional requirements stated in the task description.\n"
        "2. Create simple Iverilog test cases that verify your solution's basic functionality.\n"
        "   - Ensure that the testbench instantiates modules in the correct order (module definitions before testbench code).\n"
        "   - Use proper delays to let signals stabilize after changing inputs.\n"
        "   - Make sure all SystemVerilog constructs (e.g., $fatal) follow correct syntax (e.g., `$fatal(1, \"Error message\")`).\n"
        "3. Include brief comments in your code explaining key parts of your design and testbench.\n\n"
        "## Required Output Format:\n"
        "Provide a JSON object with the following fields:\n"
        "{\n"
        '    "canonical_solution": "string",  // Complete Verilog code solution\n'
        '    "test": "string"                 // Iverilog test cases\n'
        "}\n\n"
        "## Examples of good canonical solutions and tests:\n"
        "```\n" +
        few_shot_examples +
        "```\n"
    )
    try:
        response = client.chat.completions.create(
            model=args.model,
            messages=[
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": user_prompt}
            ],
            temperature=args.temperature,
            response_format={"type": "json_object"}
        )
        result = json.loads(response.choices[0].message.content)
        task_data["canonical_solution"] = result["canonical_solution"]
        task_data["test"] = result["test"]
    except Exception as e:
        logging.error(f"Error generating solution/test for task '{task_data.get('Instruction', 'unknown')}': {e}")
        raise e
    return task_data


def write_task_output(output_filename, task_data, file_lock):
    """Safely append a task_data JSON object to the output JSONL file and report updated count."""
    with file_lock:
        try:
            with open(output_filename, "a") as f:
                f.write(json.dumps(task_data) + "\n")
            # Get updated count
            count = count_jsonl_entries(output_filename)
            logging.info(f"New entry written. Updated number of entries in file: {count}")
        except Exception as e:
            logging.error(f"Error writing task output: {e}")


def correctify_solution(task_data, previous_solution, previous_test, error_msg, few_shot_examples, args):
    """
    Generate a corrected solution based on the previous failed attempt and error messages.
    
    Args:
        task_data: Original task data
        previous_solution: The solution that failed verification
        previous_test: The test that was used
        error_msg: Error messages from iverilog
        few_shot_examples: Examples to guide the model
        args: Command line arguments
        
    Returns:
        Updated task_data with corrected solution and test
    """
    system_prompt = (
        "You are an expert Verilog designer and educator with extensive experience in digital circuit design and verification. "
        "Your role is to debug and fix existing Verilog solutions that have failed their tests.\n\n"
        "Guidelines:\n"
        "- Analyze the provided error messages thoroughly and identify the root cause of failures.\n"
        "- Make minimal, precise corrections to the code to resolve the issues.\n"
        "- Verify that the corrected solution is syntactically correct and meets all functionality requirements.\n"
        "- If necessary, adjust the testbench as well—ensure it instantiates modules in the correct order and uses appropriate delays.\n"
        "- Follow Verilog coding standards and best practices.\n"
        "- **Important:** Ensure that all SystemVerilog system calls (e.g., $fatal) use the correct syntax. For example, `$fatal(1, \"Error message\")` must use a numeric finish code.\n"
    )
    
    user_prompt = (
        "# Verilog Code Correction Task\n\n"
        "## Input Task Information:\n"
        f"- Task Description: {task_data['Instruction']}\n\n"
        "## Previous Solution that Failed:\n"
        f"```verilog\n{previous_solution}\n```\n\n"
        "## Previous Test:\n"
        f"```verilog\n{previous_test}\n```\n\n"
        "## Error Messages:\n"
        f"```\n{error_msg}\n```\n\n"
        "## Your Task:\n"
        "1. Analyze the error messages and identify the issues in both the solution and test code.\n"
        "2. Fix the solution and/or test code to address all identified issues. This may include:\n"
        "   - Adding or correcting an explicit reset signal if registers are uninitialized.\n"
        "   - Adjusting the order of code so module definitions appear before their instantiations in the testbench.\n"
        "   - Correcting the use of SystemVerilog system tasks, such as ensuring `$fatal` is used with a numeric finish code (e.g., `$fatal(1, \"message\")`).\n"
        "3. Ensure that both the solution and test are syntactically correct and functionally complete.\n\n"
        "## Useful Guidelines:\n"
        "- **Explicit Reset:** Include an explicit reset (e.g., rst) to initialize registers and avoid 'X' states.\n"
        "- **Accurate Timing in Testbench:** Use sufficient delays after changing inputs so that outputs have time to settle.\n"
        "- **Modular Verification:** If possible, break the design into smaller modules for easier debugging.\n"
        "- **Debug Output:** Keep test cases simple, and ensure any use of SystemVerilog system tasks follows the correct syntax; for instance, `$fatal` must include a finish number like `$fatal(1, \"Error message\")`.\n\n"
        "## Required Output Format:\n"
        "Provide a JSON object with the following fields:\n"
        "{\n"
        '    "canonical_solution": "string",  // Corrected Verilog code solution\n'
        '    "test": "string",                 // Corrected Iverilog test cases\n'
        '    "explanation": "string"           // Brief explanation of the fixes\n'
        "}\n\n"
        "## Examples of good canonical solutions and tests:\n"
        "```\n" +
        few_shot_examples +
        "```\n"
    )
    try:
        response = client.chat.completions.create(
            model=args.model,
            messages=[
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": user_prompt}
            ],
            temperature=args.temperature,
            response_format={"type": "json_object"}
        )
        result = json.loads(response.choices[0].message.content)
        task_data["canonical_solution"] = result["canonical_solution"]
        task_data["test"] = result["test"]
        logging.info(f"Solution corrected. Explanation: {result.get('explanation', 'No explanation provided')}")
    except Exception as e:
        logging.error(f"Error correcting solution for task '{task_data.get('Instruction', 'unknown')}': {e}")
        raise e
    
    return task_data


def process_task(task_queue: Queue, few_shot_examples: str, output_filename: str, file_lock, pbar, args):
    """Process tasks from the queue with multiple attempts per task."""
    while True:
        try:
            task_data = task_queue.get_nowait()
        except Exception:
            break

        # Try generating valid solution up to a maximum number of attempts
        max_attempts = args.max_attempts
        previous_solution = None
        previous_test = None
        error_msg = None
        
        for attempt in range(1, max_attempts + 1):
            try:
                logging.info(f"Processing task '{task_data.get('Instruction', 'unknown')[:30]}...' Attempt {attempt}/{max_attempts}")
                
                # Generate initial solution or correct previous one
                if attempt == 1:
                    new_task_data = gen_solution_test(task_data, few_shot_examples, args)
                else:
                    logging.info("Correcting previous solution based on error feedback...")
                    new_task_data = correctify_solution(
                        task_data, 
                        previous_solution, 
                        previous_test, 
                        error_msg, 
                        few_shot_examples,
                        args
                    )
                
                # Store current solution and test for potential correction in next iteration
                previous_solution = new_task_data["canonical_solution"]
                previous_test = new_task_data["test"]
                
                # Test the solution
                success, error_msg = run_iverilog_test(previous_solution, previous_test)
                
                if success:
                    logging.info("Task verified successfully.")
                    write_task_output(output_filename, new_task_data, file_lock)
                    break
                else:
                    logging.warning(f"Task verification failed on attempt {attempt}. " + 
                                    ("Correcting solution..." if attempt < max_attempts else "Max attempts reached."))
            except openai.RateLimitError:
                logging.warning("Rate limit reached. Waiting 60 seconds before retrying...")
                time.sleep(60)
                continue
            except openai.APIError as e:
                logging.warning(f"API error occurred: {e}. Waiting 30 seconds before retrying...")
                time.sleep(30)
                continue
            except Exception as e:
                logging.error(f"Unexpected error on attempt {attempt}: {e}")
                break
        
        pbar.update(1)
        task_queue.task_done()


def main():
    args = parse_args()
    
    # Ensure output directory exists
    output_path = Path(args.output_file)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    
    # Load and validate input data
    origen_data = load_json(args.input_file)
    if not origen_data:
        logging.error(f"No data found in input file: {args.input_file}")
        return
        
    original_len = len(origen_data)
    logging.info(f"Original number of tasks: {original_len}")
    
    # Check existing entries
    existing_entries = count_jsonl_entries(args.output_file)
    logging.info(f"Existing entries in output file: {existing_entries}")

    # Get few-shot examples
    few_shot_examples = get_few_shot_examples()

    # Create task queue
    task_queue = Queue()
    for task in origen_data:
        task_queue.put(task)

    # Setup synchronization primitives
    file_lock = threading.Lock()
    pbar = tqdm(total=len(origen_data), desc="Processing tasks")

    # Process tasks with thread pool
    with ThreadPoolExecutor(max_workers=args.num_workers) as executor:
        futures = []
        for _ in range(args.num_workers):
            futures.append(executor.submit(
                process_task, 
                task_queue, 
                few_shot_examples, 
                args.output_file, 
                file_lock, 
                pbar,
                args
            ))

    # Wait for completion
    task_queue.join()
    pbar.close()

    # Report results
    new_entries = count_jsonl_entries(args.output_file)
    logging.info(f"Expanding completed. Originally {original_len} tasks, updated output file now has {new_entries} entries.")


if __name__ == "__main__":
    # Load environment variables
    dotenv.load_dotenv(override=True)
    api_key = os.getenv("OPENAI_API_KEY")
    if not api_key:
        raise ValueError("OPENAI_API_KEY not found in .env file")
 
    # Initialize OpenAI client
    client = openai.OpenAI(api_key=api_key)
    
    # Run main function
    try:
        main()
    except KeyboardInterrupt:
        logging.info("Process interrupted by user")
    except Exception as e:
        logging.error(f"Unexpected error: {e}")
        raise