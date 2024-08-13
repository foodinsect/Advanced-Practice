# fixed-point-operator   

# Verilog Testbench for `top` Module

This repository contains the Verilog testbench for the `top` module, which performs fixed-point addition and multiplication based on the `i_sel` signal. The testbench is designed to verify the functionality of the `top` module by generating random input values and comparing the output against expected results.

## File Structure

- `fp_operator.v`: Verilog module implementing fixed-point addition and multiplication.
- `tb_top.v`: Testbench for the `top` module.
- `README.md`: This file, providing an overview and instructions for running the simulation.
  
![image](https://github.com/foodinsect/Verilog-modules/assets/36304709/3792cae7-24b0-4861-90d5-54f6f9b04459)  
  
## Module Description

### `fp_operator.v`

The `fp_operator` module performs fixed-point arithmetic operations based on the `i_sel` signal:
- When `i_sel` is `0`, the module performs fixed-point addition.
- When `i_sel` is `1`, the module performs fixed-point multiplication with a Q16.16 format.

#### Parameters
- `DATA_WIDTH`: Width of the input data (default is 32 bits).
- `FRACTIONAL_BITS`: Number of fractional bits in the fixed-point representation (default is 16 bits).

#### Ports
- `input wire signed [DATA_WIDTH-1:0] din_1`: First input operand.
- `input wire signed [DATA_WIDTH-1:0] din_2`: Second input operand.
- `input wire i_sel`: Operation selector (0 for addition, 1 for multiplication).
- `output reg signed [DATA_WIDTH-1:0] dout`: Output result.

### `tb_top.v`

The `tb_top` testbench generates random input values for `din_1` and `din_2`, selects the operation using `i_sel`, and verifies the output `dout` against the expected result.

#### Testbench Functionality
- Generates random values within a specified range for `din_1` and `din_2`.
- Alternates the `i_sel` signal between 0 and 1 to test both addition and multiplication.
- Compares the output `dout` with the expected result and prints the result along with any errors.


## Block Diagram

Below is a block diagram illustrating the testbench and the `top` module connections:


## Running the Simulation

![fp_op_waveform](https://github.com/foodinsect/fixed-point-operator/assets/36304709/c1ec68cd-92d9-4b43-9e41-dc0c331d16f4)   

## Running the RTL
![RTL Schemetic](https://github.com/foodinsect/fixed-point-operator/assets/36304709/fe5155ac-9eea-4335-8ef7-4b199310c197)   
   
