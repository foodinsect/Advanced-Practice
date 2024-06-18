### README

## Project Overview

This project implements a matrix multiplication system with quantization and dequantization. It includes various Verilog modules designed to handle different stages of the process, such as quantizing input data, performing matrix multiplication using MAC (Multiply-Accumulate) units, and dequantizing the results. The provided files include testbenches, control logic, and memory (BRAM) modules to facilitate these operations.

## File Descriptions

1. **Quantize.v**: This module performs the quantization of input data.
2. **Dequantize.v**: This module performs the dequantization of processed data.
3. **top.v**: The top-level module that integrates quantization, MAC, and dequantization modules, controlling the data flow through these stages and managing the overall operation.
4. **tb_top.v**: This is the testbench for the top-level module. It simulates the behavior of the `top.v` module, providing test vectors and checking the output.

## Waveform  
![Vector_QDQ](https://github.com/foodinsect/Verilog-modules/assets/36304709/e9fb4eee-c341-441e-b0c1-9a3b7d773b5d)  
  
  
## RTL Schemetic
![Vector_QDQ_RTL](https://github.com/foodinsect/Verilog-modules/assets/36304709/a2881ae6-e863-456b-a1d7-d1ba99a0effc)  
  

  
## Module Descriptions

### Quantize.v

- **Purpose**: Perform quantization of input data.
- **Inputs**:
  - `clk_i`: Clock input
  - `rstn_i`: Active low reset input
  - `i_q_en`: Quantize enable signal
  - `din_i`: Data input (32-bit signed)
- **Outputs**:
  - `o_qout`: Quantized output (8-bit signed)
  - `o_qvalid`: Output valid signal
  - `done_o`: Done signal

### Dequantize.v

- **Purpose**: Perform dequantization of processed data.
- **Inputs**:
  - `clk_i`: Clock input
  - `rstn_i`: Active low reset input
  - `din_i`: Data input (32-bit signed)
  - `valid_i`: Input valid signal
- **Outputs**:
  - `valid_o`: Output valid signal
  - `done_o`: Done signal
  - `dout_o`: Dequantized output (32-bit signed)

### top.v

- **Purpose**: Top-level module integrating quantization, MAC, and dequantization.
- **Inputs**:
  - `clk_i`: Clock input
  - `rstn_i`: Active low reset input
  - `start_i`: Start signal
  - `vector_x_i`: Input vector (32-bit signed)
  - `quant_w_i`: Quantized weights (32-bit signed)
- **Outputs**:
  - `done_o`: Signal indicating the overall operation is complete
  - `dout_o`: Final output data after dequantization

### tb_top.v

- **Purpose**: Testbench for the `top.v` module.
- **Functionality**: Provides input stimuli to the `top.v` module and checks the output for correctness.

## Module Interfaces

### Quantize.v Interface

- **clk_i**: System clock input.
- **rstn_i**: Active low reset.
- **i_q_en**: Enable signal for the quantization process.
- **din_i**: 32-bit signed input data to be quantized.
- **o_qout**: 8-bit signed quantized output data.
- **o_qvalid**: Indicates that the quantized output data is valid.
- **done_o**: Indicates that the quantization process is complete.

### Dequantize.v Interface

- **clk_i**: System clock input.
- **rstn_i**: Active low reset.
- **din_i**: 32-bit signed input data to be dequantized.
- **valid_i**: Indicates that the input data is valid.
- **valid_o**: Indicates that the dequantized output data is valid.
- **done_o**: Indicates that the dequantization process is complete.
- **dout_o**: 32-bit signed dequantized output data.

### top.v Interface

- **clk_i**: System clock input.
- **rstn_i**: Active low reset.
- **start_i**: Start signal for the overall process.
- **vector_x_i**: 32-bit signed input vector for processing.
- **quant_w_i**: 32-bit signed quantized weights for MAC operations.
- **done_o**: Indicates that the overall process is complete.
- **dout_o**: 32-bit signed final output data after dequantization.

### tb_top.v Interface

- **Purpose**: Testbench for the top module.
- **Functionality**: Stimulates the top module with various test vectors and verifies the output.

## Simulation and Synthesis

1. **Simulation**: Use the testbench (`tb_top.v`) to simulate the `top.v` module. Ensure all inputs are correctly defined, and the expected outputs are verified.
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
