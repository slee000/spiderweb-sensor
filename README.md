
This GitHub repository is composed of **code and data**.

## Getting Started
To run the codes, you need **Python** or **MATLAB**.
For data collection, use **Arduino** or any equivalent MCU.

All code is compatible with Linux, macOS, and Windows.

Data can be viewed with any program that supports the **.csv** format.

---
---

<!-- Codes -->
## Codes
See the **`Codes`** folder.

---

### 1.1 Data Collection
- **Location**: `Arduino` folder
- **Dependency**: Install the [Arduino library for the CD74HC4067 MUX](https://github.com/waspinator/CD74HC4067)

---

### 1.2 Machine Learning (GRU)
- **Location**:
  - **Classification**: `classification` folder
  - **Regression**: `Regression` folder
  
- **Dependencies**:
  - Python
  - [PyTorch](https://pytorch.org/) (Python)
  - [NumPy](https://numpy.org/) (Python)
  - [Matplotlib](https://matplotlib.org/) (Python, for visualization)
  - Optional: CUDA (for NVIDIA GPU acceleration)

- **Execution**:
  - Run `Train_.py` to train the model and save it.
  - Run `Test_.py` to perform estimation and evaluation.

---

### 1.3 Latent Space Structuring Analysis
- **Location**: `Analysis - Latent space structuring` folder

- **Dependencies**:
  - Python
  - [NumPy](https://numpy.org/) (Python)
  - [Scikit-learn](https://scikit-learn.org/) (Python)
  - [Pandas](https://pandas.pydata.org/) (Python)

- **Execution**:
  - For 2D reduction: Run `tSNE_2D.py`
  - For 3D reduction: Run `tSNE_3D.py`

---

### 1.4 Uniqueness Analysis
- **Location**: `Analysis - Uniqueness analysis` folder
- **Dependency**: MATLAB

---
---

## Data
See the **`Data`** folder.

Detailed information is available through folder names and data file names. **`Train`** is for training, and **`Test`** is for evaluation.

---
