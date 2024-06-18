### README

## Project Overview

This project implements a matrix multiplication system with quantization and dequantization. It consists of various Verilog modules designed to handle the quantization of input data, perform matrix multiplication using MAC (Multiply-Accumulate) units, and dequantize the results. The provided files include testbenches, control logic, and memory (BRAM) modules to facilitate these operations.

## File Descriptions

1. **MAC.v**: This module performs the Multiply-Accumulate (MAC) operation. It takes input data and weights, multiplies them, and accumulates the results.

2. **top.v**: This is the top-level module that integrates the quantization, MAC, and dequantization modules. It controls the flow of data through these stages and manages the overall operation.

3. **tb_top.v**: This is the testbench for the top-level module. It simulates the behavior of the `top.v` module, providing test vectors and checking the output.

4. **bram.v**: This module implements Block RAM (BRAM) for storing input data and weights. It provides the necessary read and write interfaces for accessing the stored values.

5. **ctrl_fsm.v**: This module implements the control Finite State Machine (FSM) that manages the state transitions and control signals for the overall system.

## Waveform  
![Simple_controller_waveform](https://github.com/foodinsect/Verilog-modules/assets/36304709/95dcc993-e69f-4f7d-b9a9-d6169dc0b9bf)  

  
  
## RTL Schemetic  
![Simple Ctrl RTL](https://github.com/foodinsect/Verilog-modules/assets/36304709/137ed638-2a9a-4837-8ef3-3c1b1af5d8b5)  


  
## Module Descriptions

### MAC.v

- **Purpose**: Perform multiply-accumulate operations.
- **Inputs**:
  - `clk_i`: Clock input
  - `rstn_i`: Active low reset input
  - `dsp_enable_i`: Enable signal for the DSP block
  - `dsp_valid_i`: Valid input signal
  - `dsp_input_i`: Input data for the DSP block
  - `dsp_weight_i`: Weight data for the DSP block
- **Outputs**:
  - `done_o`: Signal indicating the MAC operation is complete
  - `dsp_output_o`: Output of the MAC operation

### top.v

- **Purpose**: Top-level module integrating quantization, MAC, and dequantization.
- **Inputs**:
  - `clk_i`: Clock input
  - `rstn_i`: Active low reset input
  - `start_i`: Start signal
  - `vector_x_i`: Input vector
  - `quant_w_i`: Quantized weights
- **Outputs**:
  - `done_o`: Signal indicating the overall operation is complete
  - `dout_o`: Final output data after dequantization

### tb_top.v

- **Purpose**: Testbench for the `top.v` module.
- **Functionality**: Provides input stimuli to the `top.v` module and checks the output for correctness.

### bram.v

- **Purpose**: Implement Block RAM (BRAM) for storing data.
- **Inputs**:
  - `clk_i`: Clock input
  - `we_i`: Write enable signal
  - `addr_i`: Address input
  - `data_i`: Data input
- **Outputs**:
  - `data_o`: Data output

### ctrl_fsm.v

- **Purpose**: Control FSM for managing state transitions and control signals.
- **Inputs**:
  - `clk_i`: Clock input
  - `rstn_i`: Active low reset input
  - `start_i`: Start signal
- **Outputs**:
  - Control signals for other modules

## Simulation and Synthesis

1. **Simulation**: The testbench (`tb_top.v`) is used to simulate the `top.v` module. Ensure all inputs are correctly defined, and the expected outputs are verified.
2. **Synthesis**: Use your preferred synthesis tool (such as Xilinx Vivado) to synthesize the design. Ensure all constraints are properly defined, and the design meets timing requirements.

## How to Run the Testbench

1. Open your Verilog simulator.
2. Load the `tb_top.v` file.
3. Compile and run the simulation.
4. Check the waveforms and output logs to verify the correctness of the design.

## Notes

- Ensure all parameter values are correctly set before running the simulation or synthesis.
- Modify the testbench as needed to cover additional test cases or edge scenarios.

---
