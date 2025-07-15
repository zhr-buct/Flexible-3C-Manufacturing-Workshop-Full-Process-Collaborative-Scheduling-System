function critic = buildCriticNetwork(state_size)


    % 定义Critic网络结构
    input_layer = sequenceInputLayer([state_size + 1, 1], 'Name', 'input');
    
    
    fc1 = fullyConnectedLayer(64, 'Name', 'fc1');
    relu1 = reluLayer('Name', 'relu1');
    fc2 = fullyConnectedLayer(32, 'Name', 'fc2');
    relu2 = reluLayer('Name', 'relu2');
    output_layer = fullyConnectedLayer(1, 'Name', 'output');
    
    % 连接网络层
    layers = [
        input_layer

        fc1
        relu1
        fc2
        relu2
        output_layer
    ];

    % 创建神经网络
    lgraph = dlnetwork(layers);




     

    critic = lgraph;
    






end