### README

## Project Overview

This project implements a complex matrix multiplication system that involves quantization, processing units (PU), and dequantization. It includes various Verilog modules designed to handle different stages of the process, such as quantizing input data, performing matrix multiplication using MAC (Multiply-Accumulate) units, and dequantizing the results. The provided files include testbenches, control logic, and memory (BRAM) modules to facilitate these operations.

## File Descriptions

1. **local_ctrl_1.v**: Local controller for layer 1, managing state transitions and control signals for the first processing layer.
2. **MAC.v**: This module performs the Multiply-Accumulate (MAC) operation, taking input data and weights, multiplying them, and accumulating the results.
3. **PU0.v**: Processing Unit 0, integrates multiple MAC units and handles specific operations.
4. **PU1.v**: Processing Unit 1, similar to PU0, but can be configured for different operations or data paths.
5. **top.v**: The top-level module that integrates the quantization, MAC, and dequantization modules, controlling the data flow through these stages and managing the overall operation.
6. **bram.v**: This module implements Block RAM (BRAM) for storing input data and weights, providing the necessary read and write interfaces.
7. **controller.v**: This module implements the main controller for managing state transitions and control signals across the entire system.
8. **layer1.v**: Layer 1 module that integrates local control and processing units, handling the first stage of matrix multiplication.
9. **layer2.v**: Layer 2 module that integrates local control and processing units, handling the second stage of matrix multiplication.
10. **local_ctrl_0.v**: Local controller for layer 0, managing state transitions and control signals for the initial processing layer.

## Waveform  
![Streamline Controller](https://github.com/foodinsect/Verilog-modules/assets/36304709/744d8e46-8c8e-4600-9225-5ad04e1b8ae8)  
  
  
## RTL Schemetic  
![Streamline RTL](https://github.com/foodinsect/Verilog-modules/assets/36304709/d5690a83-824c-44a7-b5db-a774f1465f50)  
  
  

## Module Descriptions

### local_ctrl_1.v

- **Purpose**: Manage state transitions and control signals for the first processing layer.
- **Inputs**:
  - `clk_i`: Clock input
  - `rstn_i`: Active low reset input
  - `start_i`: Start signal
- **Outputs**: Various control signals for layer 1 modules.

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

### PU0.v

- **Purpose**: Integrate multiple MAC units and control specific operations.
- **Inputs**:
  - `clk_i`: Clock input
  - `rstn_i`: Active low reset input
  - `pu_enable_i`: Enable signal for the PU
  - `pu_valid_i`: Valid input signal
- **Outputs**:
  - Various signals to control and monitor the MAC units' operations.

### PU1.v

- **Purpose**: Similar to PU0, but can be configured for different operations or data paths.
- **Inputs**:
  - `clk_i`: Clock input
  - `rstn_i`: Active low reset input
  - `pu_enable_i`: Enable signal for the PU
  - `pu_valid_i`: Valid input signal
- **Outputs**:
  - Various signals to control and monitor the MAC units' operations.

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

### controller.v

- **Purpose**: Main controller for managing state transitions and control signals across the entire system.
- **Inputs**:
  - `clk_i`: Clock input
  - `rstn_i`: Active low reset input
  - `start_i`: Start signal
- **Outputs**: Various control signals for different modules.

### layer1.v

- **Purpose**: Integrate local control and processing units, handling the first stage of matrix multiplication.
- **Inputs**:
  - `clk_i`: Clock input
  - `rstn_i`: Active low reset input
  - `start_i`: Start signal
  - `local0_en`: Enable signal for local control 0
- **Outputs**:
  - `pu2_en`: Enable signal for the second processing unit
  - `temp_o`: Temporary output data

### layer2.v

- **Purpose**: Integrate local control and processing units, handling the second stage of matrix multiplication.
- **Inputs**:
  - `clk_i`: Clock input
  - `rstn_i`: Active low reset input
  - `start_i`: Start signal
  - `local1_en`: Enable signal for local control 1
  - `pu2_en`: Enable signal for the second processing unit
  - `temp_o`: Temporary output data from layer 1
- **Outputs**:
  - `done_o`: Signal indicating the layer 2 operation is complete
  - `result`: Final result after processing

### local_ctrl_0.v

- **Purpose**: Manage state transitions and control signals for the initial processing layer.
- **Inputs**:
  - `clk_i`: Clock input
  - `rstn_i`: Active low reset input
  - `start_i`: Start signal
- **Outputs**: Various control signals for layer 0 modules.

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
