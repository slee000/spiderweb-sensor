# Studies and Examples Guide

This document describes the simulation studies, datasets, and example files provided in this repository.

---

## 📊 Studies and Examples Overview

The `Results` folder contains:
- Simulation results
- Post-processing scripts
- SOFA scene files
- Supporting data for all studies presented in the paper

---

## 🔬 Detailed Folder Description

### 🧬 Bio_relevance
- Run the MATLAB script:
  ```matlab
  bio_rel_v4.m
  ```
- Contains raw data manually extracted from experimental and simulation studies
- Script performs post-processing and generates plots (used in the paper after visual refinement)

---

### 🕸️ Biological_web
- Results for **web1** and **web2**
- Each folder includes:
  - Original biological web image
  - Simulation video recordings
  - SOFA scene files (`.xml`) for both intact and damaged configurations

---

### 🔷 Grid_Polar_webs
- Simulation results for **3D-printed Grid and Polar web structures**
- Includes:
  - Simulation videos
  - SOFA scene files (`.xml`) for intact and damaged cases
  - MATLAB `.fig` files showing:
    - Web geometries
    - Excitation point locations

---

### ⚙️ Optimization
- Results for **seed and optimized web configurations**

#### Configurations Covered
- Symmetric web seed (without free-zone features)
- Symmetric web with free-zone features

#### Optimization Cases
- Based on **5 parameters**
- Based on **9 parameters**

#### Included Files
- Simulation video recordings
- SOFA scene files (`.xml`) for intact and damaged webs
- MATLAB `.fig` files for geometries and excitation points

---

### 📈 Sensitivity_analysis
- Run the MATLAB script:
  ```matlab
  results_sensitivity.m
  ```
- Contains raw data extracted from simulation studies
- Script performs post-processing and generates plots used in the paper

---

## ▶️ Running SOFA Simulation Examples

Example SOFA scene files are provided in:
- `SOFA_example`
- `Studies`

### Steps to Run

1. Open **Windows Command Prompt**
2. Launch SOFA:
   ```bash
   runSofa
   ```
3. Open a scene file (`.xml` or `.py`) via the SOFA interface
4. Run the simulation

---

## ✅ Summary

- MATLAB scripts are used for data processing and plot generation
- SOFA scene files are used for simulations
- Videos and figures provide validation and visualization of results

---
