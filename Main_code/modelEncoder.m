function dlZ = modelEncoder(parameters,dlX,sequenceLengths)

% Embedding.
weights = parameters.emb.Weights;
dlZ = embedding(dlX,weights);

% LSTM.
inputWeights = parameters.lstmEncoder.InputWeights;
recurrentWeights = parameters.lstmEncoder.RecurrentWeights;
bias = parameters.lstmEncoder.Bias;
numHiddenUnits = size(recurrentWeights,2);
hiddenState = zeros(numHiddenUnits,1,'like',dlX);
cellState = zeros(numHiddenUnits,1,'like',dlX);

dlZ1 = lstm(dlZ,hiddenState,cellState,inputWeights,recurrentWeights,bias,'DataFormat','CBT');

% Output mode 'last' with masking.
miniBatchSize = size(dlZ1,2);
dlZ = zeros(numHiddenUnits,miniBatchSize,'like',dlZ1);

for n = 1:miniBatchSize
    t = sequenceLengths(n);
    dlZ(:,n) = dlZ1(:,n,t);
end

% Fully connect.
weights = parameters.fcEncoder.Weights;
bias = parameters.fcEncoder.Bias;
dlZ = fullyconnect(dlZ,weights,bias,'DataFormat','CB');

end