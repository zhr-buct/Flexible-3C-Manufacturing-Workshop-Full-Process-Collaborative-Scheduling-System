function [dlY,state] = modelDecoder(parameters,dlX,state)

% Embedding.
weights = parameters.emb.Weights;
dlX = embedding(dlX,weights);

% LSTM.
inputWeights = parameters.lstmDecoder.InputWeights;
recurrentWeights = parameters.lstmDecoder.RecurrentWeights;
bias = parameters.lstmDecoder.Bias;
hiddenState = state.HiddenState;
cellState = state.CellState;

[dlY,hiddenState,cellState] = lstm(dlX,hiddenState,cellState, ...
    inputWeights,recurrentWeights,bias,'DataFormat','CBT');

state.HiddenState = hiddenState;
state.CellState = cellState;

% Fully connect.
weights = parameters.fcDecoder.Weights;
bias = parameters.fcDecoder.Bias;
dlY = fullyconnect(dlY,weights,bias,'DataFormat','CBT');

% Softmax.
dlY = softmax(dlY,'DataFormat','CBT');

end