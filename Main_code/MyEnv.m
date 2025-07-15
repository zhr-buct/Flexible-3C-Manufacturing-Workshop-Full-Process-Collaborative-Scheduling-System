classdef MyEnv< rl.env.MATLABEnvironment
    
    properties
        data = []
        info = []
        % 种群大小
        PopulationSize = 40
        % 个体向量长度
        IndividualLength
        % 操作算子数量
        NumOperators = 20
        % 状态维度
        StateSize = 4
        % 动作维度
        ActionSize
        % 当前种群
        CurrentPopulation
        % 当前状态(适应度标准差)
        CurrentState

        fitnew
        fitold
    end

    methods
        function this = MyEnv(data, info)
            
            % 初始化观察空间
            ObservationInfo = rlNumericSpec([1 4]);
            ObservationInfo.Name = 'Population State';
            ObservationInfo.Description = 'Standard Deviation and Mean of Fitness';

            % 初始化动作空间
            % ActionInfo = rlNumericSpec([1 11]);
            ActionInfo = rlFiniteSetSpec({1;2;3;4;5;6;7;8;9;10;11;12;13;14;15;16;17;18;19;20});
            ActionInfo.Name = 'Operator Action';

            % 调用父类构造函数
            this = this@rl.env.MATLABEnvironment(ObservationInfo, ActionInfo);
            
            this.data = data;
            this.info = info;
            % 设置个体向量长度
            this.IndividualLength = data.n * 3;
            this.ActionSize = this.NumOperators;

            % 初始化种群和状态
            this.CurrentPopulation = RL_creat_pop(data, info);
            this.fitold = decode_01(this.CurrentPopulation,info,data);
            this.fitnew = this.fitold;
            [inputFeatures, ~] = calculate_input(this.CurrentPopulation, this.info, this.data, this.fitnew, this.fitold);
            this.CurrentState = round(inputFeatures);
           
    
        end






        function [Observation, Reward, IsDone, Info] = step(this, Action)
            [~, ~, oldfit] = calculate_std(this.CurrentPopulation, this.info, this.data);

            % 执行操作算子,并更新种群
            [this.info, newPopulation,newfit] = performOperator(this.CurrentPopulation, Action, this.info, this.data, oldfit);
            
            % 计算新状态和适应度标准差
            [inputFeatures, ~] = calculate_input(newPopulation, this.info, this.data, newfit, oldfit);
            newState = inputFeatures;
            
            % 计算奖励
            Reward = RL_reward(newfit, oldfit, this.info);
           
            % 更新环境状态
            this.CurrentPopulation = newPopulation;
            this.CurrentState = newState;

            Observation = this.CurrentState;
            IsDone = false;
            Info = [];
        end

        function InitialObservation = reset(this)
            % 重置环境状态
            this.CurrentPopulation = RL_creat_pop(this.data, this.info);
            this.fitold = decode_01(this.CurrentPopulation,this.info,this.data);
            this.fitnew = this.fitold;

            [inputFeatures, ~] = calculate_input(this.CurrentPopulation, this.info, this.data, this.fitnew, this.fitold);
            this.CurrentState = inputFeatures;
            
            InitialObservation = this.CurrentState;
        end
    end
end