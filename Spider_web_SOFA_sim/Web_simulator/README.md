# Web Simulator & Structural Optimization

## Overview
This repository contains the source code used for **web simulation, structural optimization, and classification analysis** as presented in the associated research paper.

The project integrates:
- Geometric modelling of web structures
- Physics-based simulation using SOFA
- Machine learning (LSTM) for classification
- G-code generation for 3D printing
- Optimization using Genetic Algorithms

---

## Repository Structure

### Core Scripts

#### `mesh_import.m`
Main entry point for running simulations.

Features:
- Defines geometric and simulation parameters
- Runs different experimental studies
- Generates and animates G-code (`line2gcode.m`)
- Exports SOFA scenes (`SOFA_export.m`)
- Executes SOFA simulations and extracts data
- Trains and tests LSTM models

Outputs:
- Classification accuracy
- Plots, figures, and animations
- G-code for 3D printing
- Raw and processed simulation data

Default setup:
- 17-point classification task
- Biological web 1
- Perturbed excitation locations
- Two damage levels (50 and 100 damaged lines)

---

#### `sensitivity.m`
Performs sensitivity analysis.

- Perturbs parameters (as described in the paper)
- Executes multiple trials with random damage configurations
- Returns classification accuracy vector
- Results stored in: `Results/results_sensitivity.m`

---

#### `web_optimization_analysis.m`
Runs optimization experiments.

- Uses `random_web.m` and `mesh_import.m`
- Supports multiple study configurations
- Implements Genetic Algorithm optimization (set `opt_type = 'ga'`)

Key features:
- 5-DoF optimization on seed web geometry
- Evaluation on random damage scenarios
- Outputs:
  - Mean classification accuracy
  - Geometry and signal plots

---

#### `random_web.m`
Generates random web geometries.

- Can run standalone
- Produces visualizations of generated structures

---

#### `SOFA_export.m`
Exports simulation scenes.

- Generates `.xml` files for SOFA
- Includes geometry, excitation, and damage configurations
- Not intended for standalone execution

---

#### `line2gcode.m`
Handles 3D printing preparation.

- Cleans and refines web geometry
- Generates G-code
- Animates printing paths
- Not standalone

---

### Supporting Components

#### `igesToolBox_edited/`
Third-party utilities for wireframe geometry processing.

#### `CAD source/`
Contains predefined spider web node and line coordinate data.

#### Utility Functions
- `LSTM_fun.m` – LSTM model implementation
- `pmat.m`, `normV.m`, `pext.m` – mathematical helpers

---

## Generated Files

Running simulations produces temporary and output files such as:

- `matlab_sofa.xml` – SOFA simulation scene
- `*.mat` – simulation and geometry data
- `*.gcode` – 3D printing instructions

These files may be overwritten in subsequent runs.

---

## Usage Guidelines

1. Start with `mesh_import.m` for standard simulation workflows
2. Use `sensitivity.m` for parameter analysis
3. Use `web_optimization_analysis.m` for optimization studies
4. Ensure SOFA is correctly installed and configured

---

## Notes & Troubleshooting

- **Execution Time**: Optimization processes may take several hours depending on configuration
- **Monitoring Progress**: Use optimization plots (mean vs. best fitness)
- **SOFA Issues**:
  - Unexpected termination may corrupt subsequent runs
  - Fix:
    - Close all related processes (check Task Manager)
    - Restart MATLAB

---

## Key Capabilities

- Vibration simulation of web structures
- Damage resiliance via signal classification
- Integration with machine learning (LSTM)
- Automated design optimization
- Direct pipeline to fabrication (G-code generation)

---

## License

Please refer to the repository license for usage terms.

---

## Acknowledgements

This work builds upon SOFA framework and custom computational tools for structural simulation and optimization.
