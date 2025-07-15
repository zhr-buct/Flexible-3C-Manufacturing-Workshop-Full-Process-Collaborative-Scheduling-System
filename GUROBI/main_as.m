clear
clc
load datain.mat


info.mode = 1;
info.num  = 9;


if info.mode==1
    temp=['data=datain.fft',num2str(info.num),';'];
elseif info.mode==2
    temp=['data=datain.gs',num2str(info.num),';'];
else
    error('unavailable');
end
eval(temp)

info = setuppara(info);

[data.DAG, ~] = ranku(data);
% 原始矩阵
originalMatrix = data.xh;

% 获取矩阵的行数
numTasks = size(originalMatrix, 1);
% 初始化完整前驱关系矩阵，每一行初始化为空元胞数组
fullPredecessorMatrix = zeros(data.n,data.n);
% 遍历任务，构建完整前驱链
for i = 1:numTasks
    mergedVector = [];
    currentTaskPredecessors = {}; % 当前任务的前驱任务集合
    task = i;
    while task > 0 % 当任务编号大于0时继续寻找前驱
        currentPredecessor = originalMatrix(task, :); % 当前任务的直接前驱
        currentPredecessor = currentPredecessor(currentPredecessor ~= 0); % 移除0值
        if ~isempty(currentPredecessor)
            currentTaskPredecessors = [currentTaskPredecessors, currentPredecessor]; % 添加前驱
            task = currentPredecessor; % 将当前任务设置为其前驱，继续循环
        else
            break; % 没有更多前驱，跳出循环
        end
    end
    for j = 1:numel(currentTaskPredecessors)
        % 将cell数组中的每个元素（可能为向量）展平并添加到mergedVector中
        mergedVector = [mergedVector; currentTaskPredecessors{j}(:)];
    end
    [mergedVector , ~] = unique(mergedVector );
    if ~isempty(mergedVector)
        for k = 1:size(mergedVector,1)
            fullPredecessorMatrix(i,k) = mergedVector(k);
        end
    end
end

















% 定义变量:sdpvar:实数变量,intvar:整数变量，binvar:0-1变量
e_0 = sdpvar(data.m, 1,'full');
e_1 = sdpvar(data.n, 1,'full');
sum_c = sdpvar(data.n, 1,'full');
sum_mk = sdpvar(data.n, 1,'full');
sum_cmk = sdpvar(data.n, 1,'full');
sum_px = sdpvar(data.n, 1,'full');
ct_time = sdpvar(data.n, 1,'full');
px_cmk = sdpvar(data.n, 1,'full');
sum_e = sdpvar(1, 1,'full');
num_mk = intvar(data.n, 1,'full');
sum_data_mk = sdpvar(data.n, 1,'full');
% 任务安排，x(i,j)==1表示任务i在任务j上运行
x = binvar(data.n,data.m,'full');

% y(i,j)=1表示任务i和任务j在同一个处理器上，并且i在j任务之前运行
y = binvar(data.n,data.n,'full');

% 工作频率
f = sdpvar(data.n, 1,'full');
f_1 = sdpvar(data.n, 1,'full');

% 定义任务开始时间的决策变量
start_time = sdpvar(data.n, 1, 'full');
fin_time = sdpvar(data.n, 1, 'full');

% 定义辅助变量z表示两个任务是否在同一个处理器上执行
% z = binvar(data.n, data.n, data.m, 'full');



Constraints = [];




% 约束（2）
for i = 1:data.n
    Constraints = [Constraints, fin_time(i) <= data.cmax];
end
for i = 1:data.n
    Constraints = [Constraints, fin_time(i) >=0];
end

% 定义约束条件
% 机器安排的约束, 表示每个任务只能在一个机器上运行
% 约束（4）

for i = 1 : data.n
    Constraints = [Constraints, sum(x(i,:)) == 1];
end

% 任务开始时间的约束条件
% 任务之间的整定时间约束





% 约束（5）

for i = 1:data.n
    for k = 1:data.m
        Constraints = [Constraints, start_time(i) + sum(data.ct(i,:).*x(i,:)) == fin_time(i)];
    end
end





% 约束(8)
for i = 1:data.n
    for j = 1:data.n
        for k = 1:data.m
            if i ~= j
                Constraints = [Constraints, y(i,j) + y(j,i)>=x(i,k)+x(j,k)-1  ];
            end
        end
    end
end

for i = 1:data.n
    for j = 1:data.n
        if i == j
            Constraints = [Constraints, y(i,j) == 0];
        end
    end
end




for j = 1:data.n
    data_xh = fullPredecessorMatrix(j,:);
    for i = data_xh
        if i~=0 
            for k = 1:data.m
                Constraints = [Constraints, y(i,j)+1>=x(i,k)+x(j,k)];
            end
        end
    end
end

for j = 1:data.n
    data_xh = fullPredecessorMatrix(j,:);
    for i = data_xh
        if i~=0 
            Constraints = [Constraints, sum(x(i,:) .* x(j,:)) == y(i,j)];
        end
    end
end



% 约束(9)
for j = 1:data.n
    % data_xh = fullPredecessorMatrix(j,:);
    data_xh = data.xh(j,:);
    for i = data_xh
        if i~=0
            Constraints = [Constraints, fin_time(i) + (1-y(i,j))*data.st(i,j) <= start_time(j)];
        end
    end
end





% 约束(10) 
for i = 1:data.n
    Constraints = [Constraints, start_time(i)>=0];
end
Constraints = [Constraints, start_time(1)==0];



% 约束(11) 
M2 = data.cmax*2;
for i = 1:data.n
    for j = 1:data.n
        if i ~= j
            Constraints = [Constraints, fin_time(i) - (1 - y(i,j)) * M2 <= start_time(j)];
        end
    end
end





for i = 1:data.n
    Constraints = [Constraints, sum_px(i) == sum(data.p .* x(i,:))];
end
for i = 1:data.n
    Constraints = [Constraints, sum_c(i) == sum(data.c .* x(i,:))];
end

% eng约束
for i = 1:data.n
    Constraints = [Constraints, f(i) <= 0.99];
    Constraints = [Constraints, f(i) >= 0.01];
end
for i = 1:data.n
    Constraints = [Constraints, f(i) * f_1(i) == 1];
end




for i = 1:data.n
    Constraints = [Constraints, sum_mk(i) == 1];
end




for i = 1:data.n
    Constraints = [Constraints, sum_cmk(i) == sum_c(i) * sum_mk(i)];
end

for i = 1:data.n
    Constraints = [Constraints, ct_time(i) == sum( data.ct(i,:) .* x(i,:) )];
end
for i = 1:data.n
    Constraints = [Constraints, px_cmk(i) == (sum_px(i) + sum_cmk(i))]  ;
end
for i = 1:data.m
    Constraints = [Constraints, e_0(i) == max(fin_time) * data.pks(i)];
end
for i = 1:data.n
    Constraints = [Constraints, e_1(i) == px_cmk(i) * ct_time(i)] ;
end
for i = 1:data.m
    Constraints = [Constraints, e_0(i) == max(fin_time) * data.pks(i)];
end




% 写目标函数

fit = sum(e_0) + sum(e_1);


% fit = sum(sum_mk);

% fit = sum(sum_px);


% % 选择求解器
% ops = sdpsettings('solver','cplex','verbose',2);
% 
% % 调用cplex求解目标函数,求最小值
% optimize(Constraints,f,ops)
% ops = sdpsettings();
ops = sdpsettings('verbose',1,'solver','gurobi');
% ops = sdpsettings('verbose',1,'solver','cplex');
solvesdp(Constraints,fit,ops);
% problem = optimize(Constraints, fit,ops);


value_x = value(x);
value_y = value(y);
value_start_time = value(start_time);
value_fin_time = value(fin_time);
% disp(value(x))
% disp(value(y))
% disp(value(f))
% disp(value(f_1))




