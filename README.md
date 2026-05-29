# IEEE 754 Floating Point Converters - Verilog

Synthesizable Verilog implementation of IEEE 754 single-precision (32-bit) floating point converters, including decimal-to-float and float-to-decimal conversion modules. Synthesized using Cadence Genus.

## Modules

### decimal_to_fp
Converts a signed 32-bit integer to IEEE 754 single-precision floating point format.

- Extracts sign and absolute value via two's complement
- Detects MSB position using a leading-one detector
- Normalizes mantissa and computes biased exponent (bias = 127)
- Handles overflow and underflow
- Clocked with active-low reset

### fp_to_decimal
Converts an IEEE 754 single-precision floating point value back to a signed 32-bit integer (Q16.16 fixed-point).

- Unpacks sign, exponent, and mantissa fields
- Computes actual exponent by removing bias
- Handles zero, denormalized numbers, infinity, and NaN
- Applies two's complement for negative results
- Clocked with active-low reset

## Synthesis Results

Synthesized using **Cadence Genus 21.14** under slow operating conditions.

| Module | Cell Count | Total Area | Total Power |
|---|---|---|---|
| `decimal_to_fp` | 496 | 3558.19 | 89.06 uW |
| `fp_to_decimal` | 518 | 3712.59 | 68.08 uW |

### Power Breakdown

**decimal_to_fp**
| Category | Leakage | Internal | Switching | Total |
|---|---|---|---|---|
| Register | 6.41 uW | 26.89 uW | 2.34 uW | 35.63 uW (40%) |
| Logic | 10.44 uW | 28.55 uW | 14.42 uW | 53.42 uW (60%) |

**fp_to_decimal**
| Category | Leakage | Internal | Switching | Total |
|---|---|---|---|---|
| Register | 8.65 uW | 32.78 uW | 4.51 uW | 45.94 uW (67%) |
| Logic | 5.65 uW | 10.72 uW | 5.77 uW | 22.14 uW (33%) |

## Files

| File | Description |
|---|---|
| `decimal_to_fp.v` | Decimal to IEEE 754 converter module |
| `fp_to_decimal.v` | IEEE 754 to decimal converter module |
| `decimal_to_fp.tcl` | Genus synthesis script for decimal_to_fp |
| `fp_to_decimal.tcl` | Genus synthesis script for fp_to_decimal |
| `decimal_to_fp.g` | Genus netlist output for decimal_to_fp |
| `fp_to_decimal.g` | Genus netlist output for fp_to_decimal |
| `reports/` | Area, power, and timing reports for both modules |

## Tools Used

- **Verilog HDL** - RTL design
- **Cadence Genus 21.14** - Logic synthesis and report generation
