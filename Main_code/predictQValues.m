function qValues = predictQValues(dqn, stateInput)
    % 使用神经网络预测Q值
    dlYPred = dqn.Network.predict(stateInput);
    
    % 将预测结果转换为Q值向量
    qValues = dlYPred;
end