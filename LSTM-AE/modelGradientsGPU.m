function [gradients, loss] = modelGradientsGPU(parameters,dlX,sequenceLengths)

% 将模型和输入数据移动到GPU
parameters = dlupdate(@(x) gpuArray(x), parameters);
dlX = gpuArray(dlX);
sequenceLengths = gpuArray(sequenceLengths);

% Model encoder.
dlZ = modelEncoder(parameters,dlX,sequenceLengths);

% Initialize LSTM state.
state = struct;
state.HiddenState = dlZ;
state.CellState = gpuArray.zeros(size(dlZ),'like',dlZ);

% Teacher forcing.
dlY = modelDecoder(parameters,dlX,state);

% Loss.
dlYPred = dlY(:,:,1:end-1);
dlT = dlX(:,:,2:end);
loss = mean(maskedCrossEntropy(dlYPred,dlT,sequenceLengths));

% Gradients.
gradients = dlgradient(loss,parameters);

% Normalize loss for plotting.
sequenceLength = size(dlX,3);
loss = loss / sequenceLength;

% 将梯度和损失移动回CPU
gradients = dlupdate(@(x) gather(x), gradients);
loss = dlupdate(@(x) gather(x), loss);

end