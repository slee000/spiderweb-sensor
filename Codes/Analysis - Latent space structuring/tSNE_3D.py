################################################################################
# Sudong Lee ( sudong.lee (at) epfl.ch )
#   CREATE Lab
#		: https://www.epfl.ch/labs/create/
#   Institute of Mechanical Engineering (IGM)
#   School of Engineering (STI)
#   EPFL
################################################################################


import numpy as np
from sklearn.manifold import TSNE
import matplotlib.pyplot as plt
import pandas as pd

xy_ = np.loadtxt('/*** File Name ***/', delimiter=',', dtype=np.float32)
print(np.shape(xy_))

data = xy_[:, 2:23]
data_min = np.min(data)
data_max = np.max(data)
data_normalized = (data - data_min) / (data_max - data_min)
labels = xy_[:, 0]

data_ = np.zeros((24, 6, 57, 23))
for j in range (6):
    for i in range(24):
        row_ = 57*24*(j) + 57*(i)
        data_[i,j,:,:] = xy_[row_:row_+57,:]

print(np.shape(data_normalized))

tsne = TSNE(n_components=3, n_jobs=-1)
encodedData = tsne.fit_transform(data_normalized)

print("Reduced Data Shape:", encodedData.shape)

df = pd.DataFrame(encodedData, columns=["TSNE1", "TSNE2", "TSNE3"])
df["Label"] = labels
df.to_csv("encodedData_tSNE_.csv", index=False)
print("Saved - encodedData")

fig = plt.figure(figsize=(8, 6))
ax = fig.add_subplot(111, projection='3d')
ax.scatter(encodedData[:, 0], encodedData[:, 1], encodedData[:, 2], s=10, c='blue', alpha=0.5)
ax.set_xlabel('Feature 1')
ax.set_ylabel('Feature 2')
ax.set_zlabel('Feature 3')
plt.title("3D Feature Representation")
plt.show()
