# README

## Overview

This project contains a Verilog implementation of a matrix multiplier (`matrix_multypiler`) along with a testbench (`tb_matmul`) for simulation. The matrix multiplier takes multiple signed 8-bit inputs, multiplies them with a signed 8-bit weight, and provides an 8-bit output for each multiplication. The testbench is designed to validate the functionality of the matrix multiplier.

## Files

1. **matrix_multypiler.v**: The Verilog implementation of the matrix multiplier.
2. **tb_matmul.v**: The testbench for simulating and verifying the matrix multiplier.

## matrix_multypiler Module

### Parameters

```verilog
parameter DATA_WIDTH = 8,
parameter WEIGHT_WIDTH = 8,
parameter OUTPUT_WIDTH = 8,
parameter maccnt = 8
```

- DATA_WIDTH: Width of the input data.
- WEIGHT_WIDTH: Width of the weight input.
- OUTPUT_WIDTH: Width of the output data.
- MAC_NUM: Number of multiply-accumulate (MAC) units.

## Waveform  
![matmul_waveform](https://github.com/foodinsect/Verilog-modules/assets/36304709/22230c94-72ec-4c85-9651-90dec2c6554b)  
  
