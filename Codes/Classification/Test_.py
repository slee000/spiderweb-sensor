################################################################################
# Sudong Lee ( sudong.lee (at) epfl.ch )
#   CREATE Lab
#		: https://www.epfl.ch/labs/create/
#   Institute of Mechanical Engineering (IGM)
#   School of Engineering (STI)
#   EPFL
################################################################################


import torch
import numpy as np

import os
import time

from Model_ import GRU_Classifier_

input_size = 21
one_touch_length = 57
hidden_size = 2**7
num_layers = 2**3
output_size = 24
dropout = 0.25
bidirectional = True
num_heads = 2**2
device = 'cpu'

model_ = GRU_Classifier_(input_size, hidden_size, num_layers, output_size, dropout=dropout, bidirectional=bidirectional, num_heads=num_heads).to(device)
model_.load_state_dict(torch.load('/*** Model Name ***/'))

xy_ = np.loadtxt('/*** File Name ***/', delimiter=',', dtype=np.float32)
x_Testing_ = np.zeros((144, one_touch_length, input_size))
y_Testing_ = np.zeros(144)
for i in range (144):
    j = i*one_touch_length
    x_Testing_[i,:,:] = xy_[j:j+one_touch_length, 2:(2+input_size)]
    y_Testing_[i] = xy_[j, 0]

print("Total row:", i+1)

x_Testing = torch.FloatTensor(x_Testing_)
y_Testing = torch.LongTensor(y_Testing_)

outputfile = open('output_.csv','w')
correct = 0
total = 0
model_.eval()
startTime = time.time()
with torch.no_grad():
    for i, data in enumerate(x_Testing):
        data = data.unsqueeze(0)
        output = model_(data)
        _, predicted = torch.max(output, dim=1)
        total += 1
        correct += (predicted == y_Testing[i]).sum().item()
        result_s = np.append( y_Testing[i], predicted )
        outputfile.write(",".join(str(datum) for datum in result_s))
        outputfile.write("\n")         
outputfile.close()
print(f'Accuracy of the model: {100 * correct / total:.2f}%')
print("Time: ", (time.time() - startTime), "s //  Frequency: ", len(y_Testing)/(time.time() - startTime), "Hz")
