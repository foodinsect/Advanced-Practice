## README

### Overview

This project implements a Matrix Multiplier using Multiply-Accumulate (MAC) units in Verilog. The design consists of several modules, each performing specific operations, and a testbench to verify the functionality of the design.

### Files

1. **MAC.v**: Implements the MAC unit.
2. **matrix_multypiler.v**: Implements the matrix multiplication using multiple MAC units.
3. **top.v**: Top-level module that combines multiple matrix multipliers.
4. **tb_top.v**: Testbench for the top module.

### MAC Module

**File**: MAC.v

#### Description
The MAC module performs the multiply-accumulate operation.

#### Ports

- `rstn_i`: Active-low reset signal.
- `clk_i`: Clock signal.
- `dsp_enable_i`: DSP enable signal.
- `dsp_valid_i`: Valid input signal.
- `dsp_input_i`: 8-bit signed input data.
- `dsp_weight_i`: 8-bit signed weight data.
- `dsp_output_o`: 32-bit signed output data.
- `dsp_valid_o`: Valid output signal.

#### Functionality

The MAC module multiplies `dsp_input_i` and `dsp_weight_i`, adds the result to a partial sum, and outputs the result.

### Matrix Multiplier Module

**File**: matrix_multypiler.v

#### Description
The matrix multiplier module uses multiple MAC units to perform matrix multiplication.

#### Parameters

- `DATA_WIDTH`: Width of input data.
- `WEIGHT_WIDTH`: Width of weight data.
- `OUTPUT_WIDTH`: Width of output data.
- `MAC_NUM`: Number of MAC units.

#### Ports

- `rstn_i`: Active-low reset signal.
- `clk_i`: Clock signal.
- `en_i`: Enable signal.
- `valid_i`: Valid input signal.
- `din_i`: Input data.
- `win_i`: Weight data.
- `done_o`: Done signal.
- `matmul_o`: Output data.

#### Functionality

The matrix multiplier module instantiates multiple MAC units and manages their inputs and outputs to perform matrix multiplication.

### Top Module

**File**: top.v

#### Description
The top module combines multiple matrix multiplier modules to perform complex matrix operations.

#### Ports

- `clk_i`: Clock signal.
- `rstn_i`: Active-low reset signal.
- `en_i`: Enable signal.
- `valid_i`: Valid input signal.
- `din1_i`: First input data.
- `din2_i`: Second input data.
- `din3_i`: Third input data.
- `done_o`: Done signal.
- `matmul_o`: Output data.

#### Functionality

The top module uses multiple instances of the matrix multiplier module and manages their inputs and outputs.

### Testbench

**File**: tb_top.v

#### Description
The testbench verifies the functionality of the top module.

#### Components

- Clock generation
- System initialization and reset
- Input stimuli application
- Simulation control

#### Functionality

The testbench applies a sequence of input vectors to the top module and monitors the outputs to verify correct functionality.

### Usage

1. **Compile the Verilog files**:
   Compile `MAC.v`, `matrix_multypiler.v`, `top.v`, and `tb_top.v` using your preferred Verilog simulator.

2. **Run the simulation**:
   Execute the compiled simulation to observe the output waveforms and validate the functionality.

3. **Analyze the results**:
   Verify the output signals against the expected values.

### Conclusion

This README provides an overview of the matrix multiplier design and its testbench. The design is verified using a testbench that applies input stimuli and monitors the outputs. For any issues or improvements, please feel free to contribute or raise an issue.