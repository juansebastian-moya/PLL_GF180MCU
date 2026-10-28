# Mixed-Signal Phase-Locked Loop (PLL) in GF180MCU

## 1. Overview

This repository contains the design and verification files of a **mixed-signal Phase-Locked Loop (PLL)** developed using the **GlobalFoundries GF180MCU CMOS technology**.

The project integrates analog and digital circuit blocks to implement a PLL architecture, including a phase-frequency detector, charge pump, voltage-controlled oscillator, frequency dividers, multiplexers, and supporting circuitry.

The design uses an open-source integrated circuit development environment, primarily based on **Xschem, ngspice, Magic, and Netgen**, covering schematic design, circuit simulation, physical implementation, layout-versus-schematic verification, and parasitic extraction.

The repository is organized to support design reproducibility, verification, and further development.

## 2. PLL Architecture

The PLL consists of the following functional blocks:

| Block | Description |
|---|---|
| Phase-Frequency Detector (PFD) | Detects phase and frequency differences between the reference and feedback signals. |
| Charge Pump (CP) | Converts PFD control signals into current pulses for loop control. |
| Loop Filter (LF) | Filters charge-pump output to generate the oscillator control voltage. |
| Voltage-Controlled Oscillator (VCO) | Generates an oscillating signal controlled by the loop voltage. |
| Frequency Dividers | Implement the feedback frequency division, including 7-bit divider structures. |
| Multiplexers | Provide signal selection and configuration within the PLL. |
| Current Mirrors | Generate and distribute bias currents for analog circuitry. |
| Buffers | Provide signal conditioning and drive capability. |

### Functional Architecture

The primary feedback loop can be represented as:

```text
                    +----------------+
Reference Clock --->|                |
                    |      PFD       |
Feedback Clock ---->|                |
                    +-------+--------+
                            |
                         UP / DN
                            |
                    +-------v--------+
                    |   Charge Pump  |
                    +-------+--------+
                            |
                    +-------v--------+
                    |   Loop Filter  |
                    +-------+--------+
                            |
                          VCTRL
                            |
                    +-------v--------+
                    |      VCO       |
                    +-------+--------+
                            |
                     Oscillator Output
                            |
                    +-------v--------+
                    | Frequency      |
                    | Dividers / MUX |
                    +-------+--------+
                            |
                            +-------> Feedback Clock
```

The implementation includes additional configuration signals, buffering stages, and control circuitry that are represented in the corresponding schematic and layout files.

## 3. Technology and Design Tools

**Target technology:** GlobalFoundries GF180MCU

| Design Stage | Tool |
|---|---|
| Schematic capture | Xschem |
| Circuit simulation | ngspice |
| Physical layout | Magic |
| Layout-versus-schematic verification | Netgen |
| Parasitic extraction | Magic |
| Version control | Git / GitHub |

Circuit simulation requires the appropriate GF180MCU PDK models and supporting libraries.

Tool and PDK configuration may depend on the installed development environment.

## 4. Repository Structure

```text
PLL_GF180MCU/
├── PLL-main/
│   ├── digital/
│   │
│   ├── layout/
│   │   ├── magic/
│   │   └── scripts/
│   │
│   ├── netlist/
│   │   ├── layout/
│   │   ├── schematic/
│   │   └── pex/
│   │
│   ├── schematic/
│   │   └── xschem/
│   │       └── simulation/
│   │
│   └── testbench/
│       └── tran/
│           └── xschem/
│               └── simulation/
│
├── doc/
│   ├── Datasheet.md
│   ├── Specification.md
│   ├── IPRL-Digital-Hard-IP.md
│   └── info.json
│
├── release/
│   └── v.X.X.X/
│
└── README.md
```

The main directories contain:

- **schematic/xschem:** Hierarchical schematic designs and symbols for the PLL and its subcircuits.
- **layout/magic:** Physical layouts implemented in Magic, including the top-level PLL and supporting cells.
- **netlist/schematic:** SPICE netlists generated from Xschem.
- **netlist/layout:** Extracted layout netlists and LVS-related files.
- **netlist/pex:** Post-layout netlists and parasitic extraction data.
- **testbench/tran/xschem:** Transient simulation testbenches for schematic-level and extracted implementations.
- **doc:** Project specifications, documentation, and metadata.
- **release:** Directory reserved for versioned project deliverables.

## 5. Schematic Design and Simulation

The complete PLL schematic is available at:

`PLL-main/schematic/xschem/PLL_FINAL_SCH.sch`

The main transient simulation testbench is located at:

`PLL-main/testbench/tran/xschem/TB_PLL_TOP.sch`

The schematic-level simulations are performed using Xschem and ngspice.

The testbench supports the observation of key PLL signals, including:

- `F_IN`: Reference/input signal.
- `UP_OUT` and `DN_OUT`: Phase-frequency detector outputs.
- `LF_OFFCHIP`: Loop-filter-related signal.
- `VCTRL_IN`: Oscillator control input.
- `OUT` and `OUTB`: Complementary oscillator outputs.
- `DIV_OUT`: Frequency-divider output.

Additional control inputs and digital configuration signals are included in the top-level design.

### Simulation Procedure

1. Configure the GF180MCU PDK environment.
2. Open the PLL schematic or transient testbench using Xschem.
3. Generate the SPICE netlist.
4. Run the simulation using ngspice.
5. Analyze transient waveforms and the behavior of the PLL functional blocks.

The repository includes both standalone block-level circuits and the complete PLL hierarchy.

## 6. Physical Implementation

The PLL layout was implemented using Magic.

The top-level layout is located at:

`PLL-main/layout/magic/PLL_FINAL.mag`

The layout is hierarchical and includes the physical implementation of the analog and digital blocks.

Individual layout cells are available for the PFD, charge pump, oscillator, frequency dividers, multiplexers, transmission gates, flip-flops, buffers, passive devices, and supporting logic.

## 7. Layout-Versus-Schematic Verification

Layout-versus-schematic verification was performed using **Netgen** and the GF180MCU technology setup.

The verified top-level circuits are:

- Layout: `PLL_FINAL`
- Schematic: `PLL_FINAL_SCH`

### LVS Results

| Verification Metric | Layout | Schematic |
|---|---:|---:|
| Devices | 3,030 | 3,030 |
| Nets | 1,585 | 1,585 |
| Circuit correspondence | Match | Match |

**Final Netgen result:**

```text
Circuit 1 contains 3030 devices,
Circuit 2 contains 3030 devices.

Circuit 1 contains 1585 nets,
Circuit 2 contains 1585 nets.

Final result:
Circuits match uniquely.

LVS Done.
```

The final reported LVS comparison completed without outstanding property mismatches.

The verification process included corrections to hierarchical signal connectivity, digital logic implementation, resistor representation, and transistor geometry parameters.

The corresponding schematic and layout netlists are available in the `netlist/` directory.

## 8. Parasitic Extraction and Post-Layout Simulation

Post-layout extraction has been performed using Magic.

The extracted PLL netlist is located at:

`PLL-main/netlist/pex/PLL_FINAL.spice`

The post-layout transient simulation testbench is located at:

`PLL-main/testbench/tran/xschem/TB_PLL_TOP_pex.sch`

The extracted SPICE subcircuit uses the same top-level terminal names and ordering as the schematic implementation.

This allows the extracted PLL to replace its schematic counterpart in the simulation testbench while retaining the external connections.

### Current Verification Status

- Schematic-level transient simulations have been executed.
- Parasitic extraction has been generated.
- The extracted netlist has been integrated into the ngspice testbench.
- Post-layout transient simulations have been initiated.
- Further investigation and validation of the post-layout waveforms are required.

The post-layout results should not yet be interpreted as confirmation of the complete PLL performance specifications.

## 9. Verification Status

| Activity | Status |
|---|---|
| Schematic design | Completed |
| Hierarchical physical layout | Completed |
| Schematic-level simulations | Performed |
| Layout-versus-schematic (LVS) | Passed |
| Parasitic extraction | Generated |
| Post-layout simulation | Under evaluation |
| Final DRC verification | Not yet documented as completed |
| PLL performance characterization | Pending final validation |
| Fabrication release | Not yet confirmed |

The project remains under active verification and refinement.

## 10. Documentation and Releases

The `doc/` directory contains the project documentation and metadata.

Additional documentation may be incorporated as the design is validated, including:

- PLL design specifications and operating conditions.
- Frequency ranges and divider configurations.
- Power consumption and bias conditions.
- Loop acquisition and stability characteristics.
- Final DRC and post-layout verification results.
- Versioned release deliverables.

The `release/` directory is reserved for validated design versions and their associated deliverables.

## 11. Project Scope

This repository is intended to support open-source mixed-signal integrated circuit development, design reproducibility, and verification of a PLL implemented in GF180MCU technology.

The availability of design files does not by itself imply fabrication readiness or guarantee circuit performance.

## 12. Author

**Juan Sebastian Moya**

Integrated Circuit Design and Design Flow  
International Iberian Nanotechnology Laboratory (INL)  
Braga, Portugal

GitHub: [juansebastian-moya](https://github.com/juansebastian-moya)

## 13. License

No license has been specified for this repository at this stage. Reuse and redistribution conditions should be clarified before adopting or integrating the design into other projects.
