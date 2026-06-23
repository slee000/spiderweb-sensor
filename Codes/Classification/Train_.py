################################################################################
# Sudong Lee ( sudong.lee (at) epfl.ch )
#   CREATE Lab
#		: https://www.epfl.ch/labs/create/
#   Institute of Mechanical Engineering (IGM)
#   School of Engineering (STI)
#   EPFL
################################################################################


import numpy as np
import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim
from torch.utils.data import DataLoader, TensorDataset

import os
from datetime import datetime
import matplotlib.pyplot as plt

from Model_ import GRU_Classifier_

input_size = 21
one_touch_length = 57
hidden_size = 2**7
num_layers = 2**3
output_size = 24
dropout = 0.25
bidirectional = True
num_heads = 2**2
device = 'cuda' if torch.cuda.is_available() else 'cpu'

num_epochs = 2**12
batch_size = 2**10
learning_rate = 0.001

###
xy_ = np.loadtxt('/*** File Name ***/', delimiter=',', dtype=np.float32)
x_Training_ = np.zeros((336, one_touch_length, input_size))
y_Training_ = np.zeros(336)
for i in range (336):
    j = i*one_touch_length
    x_Training_[i,:,:] = xy_[j:j+one_touch_length, 2:(2+input_size)]
    y_Training_[i] = xy_[j, 0]

print("Total row:", i+1)
x_Training = torch.FloatTensor(x_Training_).to(device)
y_Training = torch.LongTensor(y_Training_).to(device)
print(x_Training)
print(np.shape(x_Training))
print(y_Training)
print(np.shape(y_Training))

dataset = TensorDataset(x_Training, y_Training)
train_loader = DataLoader(dataset, batch_size=batch_size, shuffle=True)

###
model = GRU_Classifier_(input_size, hidden_size, num_layers, output_size, dropout=dropout, bidirectional=bidirectional, num_heads=num_heads).to(device)
criterion = nn.CrossEntropyLoss()
optimizer = optim.Adam(model.parameters(), lr=learning_rate)

total_loss = []
startTime = datetime.now()
for epoch in range(num_epochs):
    model.train()
    running_loss = 0.0
    for inputs, labels in train_loader:
        outputs = model(inputs)
        loss = criterion(outputs, labels)
        
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()
        running_loss += loss.item()

    total_loss.append(running_loss)
    plt.clf()
    plt.plot(range(len(total_loss)), total_loss)
    plt.ylabel('Loss')
    plt.xlabel('Epoch')
    plt.pause(0.0001)
        
    if (epoch+1) % 10 == 0:
        print("Training... //", "   Epoch: ",epoch+1, "/", num_epochs, "//   Loss: ", running_loss, "//   Training Time: ", datetime.now() - startTime)

save_dir = './Save/'
if not os.path.exists(save_dir):
    os.makedirs(save_dir)
save_path = save_dir + 'Model_' + '.pt'
torch.save(model.state_dict(), save_path)
