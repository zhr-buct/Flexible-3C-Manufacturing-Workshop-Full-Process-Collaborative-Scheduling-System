function maskedLoss = maskedCrossEntropy(dlY,T,sequenceLengths)

numClasses = size(dlY,1);
miniBatchSize = size(dlY,2);
sequenceLength = size(dlY,3);

maskedLoss = zeros(sequenceLength,miniBatchSize,'like',dlY);

for t = 1:sequenceLength
    T1 = single(oneHot(T(:,:,t),numClasses));
    
    mask = (t<=sequenceLengths)';
 
    maskedLoss(t,:) = mask .* crossentropy(dlY(:,:,t),T1,'DataFormat','CBT');
end

maskedLoss = sum(maskedLoss,1);

end