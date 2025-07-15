function [actor,critic,agent] = build_AC(obsInfo, actInfo)

    % 定义Actor网络结构
    input_layer = featureInputLayer(prod(obsInfo.Dimension), 'Name', 'input');
    fc1 = fullyConnectedLayer(64, 'Name', 'fc1');
    relu1 = reluLayer('Name', 'relu1');
    zheng = dropoutLayer(0.5); % 添加一个dropout层，dropout率为0.5， 防止过拟合
    fc2 = fullyConnectedLayer(32, 'Name', 'fc2');
    relu2 = reluLayer('Name', 'relu2');
    output_layer = fullyConnectedLayer(numel(actInfo.Elements), 'Name', 'output');
    softmax_layer = softmaxLayer('Name', 'softmax');


    net = [  
        input_layer
        fc1
        relu1
        zheng
        fc2
        relu2
        output_layer
        softmax_layer

        ];
    
    net = dlnetwork(net);
    
    
    % plot(net)
    % summary(net)
    
    
    actor = rlDiscreteCategoricalActor(net,obsInfo,actInfo);
    
    
    % act = getAction(actor,{1}); 
    % disp(act)
    % prb = evaluate(actor,{1});
    % disp(prb{1})



     % 定义Critic网络结构
    input_layer = featureInputLayer(prod(obsInfo.Dimension), 'Name', 'input');
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

    dlnet = dlnetwork(layers);
    % plot(dlnet)
    % summary(dlnet)
    critic = rlValueFunction(dlnet,obsInfo);
    
    % v = getValue(critic,{1});
    % disp(v)
    actor.UseDevice = 'gpu';
    critic.UseDevice = 'gpu';



    % 设置优化器选项（注意：这里只能设置学习率、梯度等）
    actorOpts = rlOptimizerOptions('LearnRate',0.005,'GradientThreshold',1);
    criticOpts = rlOptimizerOptions('LearnRate',1e-3,'GradientThreshold',1);

    % 设置 Agent 选项
    agentOptions = rlACAgentOptions(...
        'NumStepsToLookAhead', 16, ...
        'DiscountFactor', 0.95, ...
        'ActorOptimizerOptions', actorOpts, ...
        'CriticOptimizerOptions', criticOpts, ...
        'SampleTime', 1);                     % 设置采样时间

    % 创建 Agent
    agent = rlACAgent(actor, critic, agentOptions);



    % % agent = rlACAgent(actor,critic);
    % % agent = rlPPOAgent(actor,critic);
    % agent = rlACAgent(actor,critic);
    % % agent = rlTD3Agent(actor,critic);
    % 
    % 
    % agent.AgentOptions.NumStepsToLookAhead = 16;
    % agent.AgentOptions.DiscountFactor = 0.8;
    % 
    % agent.AgentOptions.ActorOptimizerOptions.LearnRate = 1e-3;
    % agent.AgentOptions.ActorOptimizerOptions.GradientThreshold = 1;
    % 
    % agent.AgentOptions.CriticOptimizerOptions.LearnRate = 0.05;
    % agent.AgentOptions.CriticOptimizerOptions.GradientThreshold = 1;
    agent.UseExplorationPolicy = true;





end
