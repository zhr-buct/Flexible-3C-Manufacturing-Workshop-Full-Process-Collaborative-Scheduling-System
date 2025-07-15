function actor = buildActorNetwork(state_size, action_size)

    % 导入所需的函数和类
    import matlab.net.*
    import matlab.net.http.*
    import matlab.net.http.field.*
    import matlab.net.http.io.*

    % 定义Actor网络结构
    input_layer = sequenceInputLayer([state_size,1], 'Name', 'input');
    fc1 = fullyConnectedLayer(64, 'Name', 'fc1');
    relu1 = reluLayer('Name', 'relu1');
    fc2 = fullyConnectedLayer(32, 'Name', 'fc2');
    relu2 = reluLayer('Name', 'relu2');
    output_layer = fullyConnectedLayer(action_size, 'Name', 'output');
    softmax_layer = softmaxLayer('Name', 'softmax');
    
    % 连接网络层
    layers = [
        input_layer
        fc1
        relu1
        fc2
        relu2
        output_layer
        softmax_layer
    ];

    % 创建神经网络
    lgraph = dlnetwork(layers);
    actor = lgraph;
    

end