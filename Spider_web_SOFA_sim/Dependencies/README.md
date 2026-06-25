# Web Simulator Setup Guide

This document provides detailed instructions for installing dependencies and configuring the environment required to run the web simulator.

---

## 📦 Dependencies

The `Dependencies` folder contains all required software and supporting packages.

> ⚠️ **Important:**  
> This project is supported **only on Windows 11** and requires the exact software versions listed below.

---

## 🛠️ SOFA Framework Installation

- 📄 Official documentation: https://www.sofa-framework.org/download/
- 📁 Source files: https://drive.google.com/drive/folders/1W4D4ZSmeXG27WHEwfJXNdBx6JisGjVLr?usp=sharing
- ✅ Required version: **SOFA_v22.12.00_Win64**

### Installation Steps

1. Install **SOFA_v22.12.00_Win64**
2. During installation:
   - Enable ✅ *"Add SOFA to the system PATH"*
   - Install to directory:
     ```
     C:\SOFA
     ```
     *(Avoid version-specific subdirectories)*
   - Proceed with default options

### Environment Variables

Ensure the following paths are added to your system `PATH`:

```
C:\SOFA\bin
C:\SOFA\plugins\SofaPython3\lib\python3\site-packages
```

---

## 🐍 Python Installation & Integration

- 📄 Documentation: https://sofapython3.readthedocs.io/en/latest/menu/SofaPlugin.html
- 📁 Source files: https://drive.google.com/drive/folders/1W4D4ZSmeXG27WHEwfJXNdBx6JisGjVLr?usp=sharing
- ✅ Required version: **Python 3.8.8 (64-bit)**
- ⚠️ Install **after SOFA**

### Installation Steps

1. Install `python-3.8.8-amd64.exe` using **Custom Installation**
2. Enable:
   - ✅ *Add Python 3.8 to PATH*
   - ✅ *Disable path length limit* (if available)
3. Continue with default settings

4. Restart your system

### Install Required Packages

```bash
pip install pandas
pip install matplotlib
```

### Add Python to PATH

```
C:\Users\<CURRENT_USER_NAME>\AppData\Local\Programs\Python\Python38
C:\Users\<CURRENT_USER_NAME>\AppData\Local\Programs\Python\Python38\Scripts
```

5. Restart your system again

6. Install additional dependency:

```bash
pip install numpy
```

---

## 🔌 Enable SofaPython3 Plugin

Edit the following file:

```
C:\SOFA\bin\plugin_list.conf
```

Add this line to end of the file:

```
SofaPython3 NO_VERSION
```

---

## ▶️ Running SOFA Simulations

Run a scene file using:

```bash
runSofa scene_name.py
```

---

## 💡 Running Scripts Outside SOFA GUI

To run Python scripts directly (e.g., via VS Code), include the following at the top of your script:

```python
import sys
sys.path.append('C:\\SOFA\\plugins\\SofaPython3\\lib\\python3\\site-packages')
```

> ⚠️ Ensure you navigate to the script directory using `cd` before execution.

---

## 📐 MATLAB Requirements

Install the following toolboxes:

- Statistics and Machine Learning Toolbox
- Optimization Toolbox
- Global Optimization Toolbox
- Deep Learning Toolbox

---

## ✅ Checklist

- ✅ Windows 11 installed
- ✅ SOFA v22.12.00 installed at `C:\SOFA`
- ✅ Python 3.8.8 installed
- ✅ Required Python packages installed
- ✅ Environment variables configured
- ✅ SofaPython3 plugin enabled
- ✅ MATLAB toolboxes installed

---

## 📌 Notes

- Using different versions may cause compatibility issues
- Ensure paths are entered exactly as specified

---
