################################################################################
# Sudong Lee ( sudong.lee (at) epfl.ch )
#   CREATE Lab
#		: https://www.epfl.ch/labs/create/
#   Institute of Mechanical Engineering (IGM)
#   School of Engineering (STI)
#   EPFL
################################################################################


import torch
import torch.nn as nn
import torch.nn.functional as F

class GRU_Classifier_(nn.Module):
    def __init__(self, input_size, hidden_size, num_layers, output_size, dropout=0.5, bidirectional=False, num_heads=4):
        super(GRU_Classifier_, self).__init__()
        self.hidden_size = hidden_size
        self.num_layers = num_layers
        self.bidirectional = bidirectional
        self.num_directions = 2 if bidirectional else 1
        self.num_heads = num_heads
        
        self.gru = nn.GRU(input_size, hidden_size, num_layers, batch_first=True, dropout=dropout, bidirectional=bidirectional)

        self.multihead_attention = nn.MultiheadAttention(embed_dim=hidden_size * self.num_directions, num_heads=num_heads, batch_first=True)

        self.fc = nn.Linear(hidden_size * self.num_directions, output_size)
        self.dropout = nn.Dropout(p=dropout)
        
    def forward(self, x):
        batch_size = x.size(0)
        h0 = torch.zeros(self.num_layers * self.num_directions, batch_size, self.hidden_size).to(x.device)
        
        gru_out, _ = self.gru(x, h0)

        attn_output, _ = self.multihead_attention(gru_out, gru_out, gru_out)
        context = torch.mean(attn_output, dim=1)

        context = self.dropout(context)
        out = self.fc(context)

        return out
