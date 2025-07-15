clear
clc

load datain.mat
info.flag = 3;%1-EHEFT;2-IILS;3-ILS;4-GA;5-ACS;6-LGWO;7-AILS

info.mode = 1;%1-fft;2-gs
info.num  = 3;

if info.mode==1
    temp=['data=datain.fft',num2str(info.num),';'];
elseif info.mode==2
    temp=['data=datain.gs',num2str(info.num),';'];
else
    error('unavailable');
end
eval(temp)





% 初始化Q-Table
num_states = 1; % 状态数量
num_actions = 12; % 操作指令数量
Q = zeros(num_states, num_actions); % 初始化Q-Table为全零

% 设置超参数
learning_rate = 0.1; % 学习率
discount_factor = 0.9; % 折扣因子
num_episodes = 1000; % 迭代次数

[info,sol,sch] = heft_sol(info,data);



% 创建一个空的图像对象
figure;



% Q-learning算法
for episode = 1:num_episodes
    disp(episode)
%     % 根据当前状态选择动作（使用ε-greedy策略）
%     epsilon = 0.9; % ε-greedy策略中的ε值，用于探索与利用的权衡
%     if rand < epsilon
%         info.num_xuanze = randi([1,12]);    
%      else
%          [~, info.num_xuanze] = max(Q(1, :)); % 选择具有最大Q值的操作指令
%     end
%     
    reward_xl = [];
    for k = 1:12
        info.num_xuanze = k;
        

        fit_zuichu = decode(sol,info,data);
        info.fitbest=decode(sol,info,data);
        info.solbest=sol;
        
        solnew = sol;
        fitold = info.fitbest;
        time_all = 0;
       
        fitold = fit_zuichu;
        % 执行动作，观察环境反馈'
        
        [info,reward] = get_reward(data,info,sol,fitold); % 根据奖励函数计算奖励值
        
        reward_xl(k) = reward;
    end

    % 给予reward最高的前几一定的额外奖励，后几名一些惩罚
    % 以此来对降低能耗不稳定的操作指令进行一定的限制，对名列前茅并且能耗降低稳定的进行一定的奖励
    % 复制原始向量
    modified_vector = reward_xl;
    % 找到最大的三个元素
    [sorted_values, sorted_indices] = sort(reward_xl, 'descend');
    top_three_indices = sorted_indices(1:3);
    top_three_values = sorted_values(1:3);
        
    % 将最大的三个元素乘以
    modified_vector(top_three_indices) = top_three_values * 1.2;
    
    reward_xl = modified_vector;
    
    
     % 更新Q值函数
     %Q = (1 - learning_rate) * Q + learning_rate * reward_xl;
     Q =  Q + learning_rate * reward_xl;
     
     Q_av = sum(Q) / 12;
     Q = Q - Q_av;
     
     % 绘制柱状图
    bar(Q);
    title(['Quality of operation']);
    xlabel('Operation instruction combination');
    ylabel('reward');
     % 设置纵坐标范围
    ylim([-num_episodes/1000, num_episodes/1000]);
    % 暂停一段时间，以便观察图像更新
    pause(0.000000000000000000000000000000001);

end

% 使用训练好的Q-Table做出决策
[~, best_action] = max(Q(1, :)); % 选择具有最大Q值的操作指令作为最优决策