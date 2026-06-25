# Studies and Examples Guide

This document describes the structure and usage of the simulation results, studies, and example files provided in this repository.

---

## 📊 Studies and Examples

The `Results` folder contains:
- Simulation outputs
- Post-processing scripts
- SOFA scene files for individual studies presented in the paper

---

## 🔬 Folder Overview

### 🧬 Bio_relevance
- Run the MATLAB script:
  ```matlab
  bio_rel_v4.m
  ```
- Contains manually extracted raw data from experimental and simulation studies
- The script performs post-processing and generates plots (some used in the paper after visual refinement)

---

### 🕸️ Biological_web
- Contains results for **web1** and **web2**
- Includes:
  - Original biological web images
  - Simulation video recordings
  - SOFA scene files (`.xml`) for intact and damaged configurations

---

### 🔷 Grid_Polar_webs
- Simulation results for **3D-printed Grid and Polar web designs**
- Includes:
  - Simulation videos
  - SOFA scene files (`.xml`) for intact and damaged cases
  - MATLAB figure files (`.fig`) showing:
    - Web geometries
    - Excitation point locations

---

### ⚙️ Optimization
- Results for **seed and optimized web configurations**
- Configurations include:
  - Symmetric web seed (without free-zone features)
  - Symmetric web with free-zone features

- Optimization cases:
  - Based on **5 parameters**
  - Based on **9 parameters**

- Includes:
  - Simulation videos
  - SOFA scene files (`.xml`) for intact and damaged configurations
  - MATLAB figure files (`.fig`) for geometries and excitation points

---

### 📈 Sensitivity_analysis
- Run the MATLAB script:
  ```matlab
  results_sensitivity.m
  ```
- Contains manually extracted data from simulation studies
- Script performs post-processing and generates plots used in the paper

---

## ▶️ Running SOFA Simulation Examples

Example SOFA scenes are located in subfolders in:
- `Studies`

### Steps to Run

1. Open **Command Prompt**
2. Launch SOFA:
   ```bash
   runSofa
   ```
3. Use the SOFA GUI to open a scene file (`.xml` or `.py`)
4. Run the simulation within the interface

---

## ✅ Summary

- Use MATLAB scripts for post-processing and analysis
- Use SOFA scene files for simulations (intact and damaged cases)
- Refer to videos and figures for visualization and validation

---
