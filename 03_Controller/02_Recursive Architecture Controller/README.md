### README

## Project Overview

This project implements a matrix multiplication system with quantization and dequantization. It includes various Verilog modules designed to handle the quantization of input data, perform matrix multiplication using MAC (Multiply-Accumulate) units, and dequantize the results. The provided files include testbenches, control logic, and memory (BRAM) modules to facilitate these operations.

## File Descriptions

1. **controller.v**: This module implements the controller for managing state transitions and control signals.
2. **MAC.v**: This module performs the Multiply-Accumulate (MAC) operation. It takes input data and weights, multiplies them, and accumulates the results.
3. **pu.v**: This module is the Processing Unit (PU) that integrates multiple MAC units and controls their operations.
4. **tb_top.v**: This is the testbench for the top-level module. It simulates the behavior of the `top.v` module, providing test vectors and checking the output.
5. **temp_bram.v**: This module implements temporary Block RAM (BRAM) for storing intermediate results.
6. **top.v**: This is the top-level module that integrates the quantization, MAC, and dequantization modules. It controls the flow of data through these stages and manages the overall operation.
7. **bram.v**: This module implements Block RAM (BRAM) for storing input data and weights. It provides the necessary read and write interfaces for accessing the stored values.

## Structure
![image](https://github.com/foodinsect/Verilog-modules/assets/36304709/0ac8c0b6-8d5f-4307-944d-399f33c9315f)

![image](https://github.com/foodinsect/Verilog-modules/assets/36304709/c4d417d3-42fc-412c-965d-3d3b68485779)
![image](https://github.com/foodinsect/Verilog-modules/assets/36304709/cee9c28b-b916-4a8b-8f20-5a98f9d08f67)




## Waveform  
![Recursive Ctrl Waveform](https://github.com/foodinsect/Verilog-modules/assets/36304709/dbf2cdec-b23d-47c4-bfbc-3bffd541a4fe)  


  
## RTL Schemetic  
![Recursive Ctrl RTL](https://github.com/foodinsect/Verilog-modules/assets/36304709/6a2428d4-1079-44fc-b8f1-321d308e2963)  
  
  
## Module Descriptions

### controller.v

- **Purpose**: Manage state transitions and control signals for the entire system.
- **Inputs**:
  - `clk_i`: Clock input
  - `rstn_i`: Active low reset input
  - `start_i`: Start signal
- **Outputs**: Various control signals for other modules.

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

### pu.v

- **Purpose**: Integrate multiple MAC units and control their operations.
- **Inputs**:
  - `clk_i`: Clock input
  - `rstn_i`: Active low reset input
  - `pu_enable_i`: Enable signal for the PU
  - `pu_valid_i`: Valid input signal
- **Outputs**:
  - Various signals to control and monitor the MAC units' operations.

### tb_top.v

- **Purpose**: Testbench for the `top.v` module.
- **Functionality**: Provides input stimuli to the `top.v` module and checks the output for correctness.

### temp_bram.v

- **Purpose**: Implement temporary Block RAM (BRAM) for storing intermediate results.
- **Inputs**:
  - `clk_i`: Clock input
  - `we_i`: Write enable signal
  - `addr_i`: Address input
  - `data_i`: Data input
- **Outputs**:
  - `data_o`: Data output

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

### bram.v

- **Purpose**: Implement Block RAM (BRAM) for storing data.
- **Inputs**:
  - `clk_i`: Clock input
  - `we_i`: Write enable signal
  - `addr_i`: Address input
  - `data_i`: Data input
- **Outputs**:
  - `data_o`: Data output

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

