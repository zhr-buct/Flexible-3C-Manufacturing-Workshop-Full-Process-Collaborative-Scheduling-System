clear
clc
load ZHR_datain.mat


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

% fullPredecessorMatrix（i,:) ,一定会在i任务之前完成的任务
originalMatrix = data.xh;
numTasks = size(originalMatrix, 1);
fullPredecessorMatrix = zeros(data.n,data.n);
for i = 1:numTasks
    mergedVector = [];
    currentTaskPredecessors = {};
    task = i;
    while task > 0
        currentPredecessor = originalMatrix(task, :);
        currentPredecessor = currentPredecessor(currentPredecessor ~= 0);
        if ~isempty(currentPredecessor)
            currentTaskPredecessors = [currentTaskPredecessors, currentPredecessor];
            task = currentPredecessor;
        else
            break;
        end
    end
    for j = 1:numel(currentTaskPredecessors)
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
sum_mk1 = sdpvar(data.n, 1,'full');
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
f1 = sdpvar(data.n, 1,'full');
f_1 = sdpvar(data.n, 1,'full');

% 定义任务开始时间与完成时间的决策变量
start_time = sdpvar(data.n, 1, 'full');
fin_time = sdpvar(data.n, 1, 'full');

% 定义辅助变量z表示两个任务是否在同一个处理器上执行
z = binvar(data.n, data.n, data.m, 'full');



[data.DAG, ~] = ranku(data);


tic;
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
M1 = data.n*2;
for i = 1:data.n
    for k = 1:data.m
        Constraints = [Constraints, start_time(i) + sum(data.ct(i,:).*x(i,:)) * f_1(i) - (1-x(i,k)) * M1 <= fin_time(i)];
    end
end

for i = 1:data.n
    for k = 1:data.m
        Constraints = [Constraints, start_time(i) + sum(data.ct(i,:).*x(i,:)) * f_1(i) <= fin_time(i)];
    end
end

for i = 1:data.n
    Constraints = [Constraints, sum(data.ct(i,:).*x(i,:)) * f_1(i) == fin_time(i) - start_time(i)];
end


% 约束(8)
for i = 1:data.n
    for j = 1:data.n
        for k = 1:data.m
            if i ~= j
                Constraints = [Constraints, y(i,j) + y(j,i) >= x(i,k) + x(j,k) - 1  ];
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





% z的约束条件,如果任务i，j都在k机器上运行，则z(i, j, k) = 1
% for i = 1:data.n
%     for j = 1:data.n
%         for k = 1:data.m
%             Constraints = [Constraints, sum(z(i, j, :)) == 1];
%             Constraints = [Constraints, z(i, j, k) <= x(i, k)];
%             Constraints = [Constraints, z(i, j, k) <= x(j, k)];
%             Constraints = [Constraints, x(i, k) + x(j, k) <= 1 + z(i, j, k)];
%         end
%     end
% end







data.st(data.st == -1) = 0;
% 约束(9)
for j = 1:data.n
    % data_xh = data.xh(j,:);
    data_xh = fullPredecessorMatrix(j,:);
    for i = data_xh
        if i ~= j && i~=0
            Constraints = [Constraints, fin_time(i) + (1-y(i,j))*data.st(i,j) <= start_time(j)];
        end
    end
end






% 约束(10) 
for i = 1:data.n
    Constraints = [Constraints, start_time(i)>=0];
end


% 约束(11) 
M2 = data.cmax * 100;
for i = 1:data.n
    for j = 1:data.n
        if i ~= j
            Constraints = [Constraints, fin_time(i) - (1 - y(i,j)) * M2 <= start_time(j)];
        end
    end
end


% eng约束
for i = 1:data.n
    Constraints = [Constraints, f1(i) <= 0.99];
    Constraints = [Constraints, f1(i) >= 0.01];    
end

for i = 1:data.n
    Constraints = [Constraints, f1(i) >= sum(data.f .* x(i,:))];
end
for i = 1:data.n
    Constraints = [Constraints, f(i) == f1(i)];
end
% for i = 1:data.n
%     Constraints = [Constraints, f(i) == round(f1(i) * 1000) / 1000];
% end
for i = 1:data.n
    Constraints = [Constraints, f(i) * f_1(i) == 1];
end


for i = 1:data.n
    Constraints = [Constraints, sum_px(i) == sum(data.p .* x(i,:))];
end
for i = 1:data.n
    Constraints = [Constraints, sum_c(i) == sum(data.c .* x(i,:))];
end





% for i = 1:data.n
%     Constraints = [Constraints, sum_data_mk(i) == sum(data.mk .* x(i,:))];
% end
% % 非线性项,num_mk(i)大概是2.7，2.8左右
% for i = 1:data.n
%     Constraints = [Constraints, sum_mk(i) == f(i) ^ sum_data_mk(i)];
% end


% % 近似求解
for i = 1:data.n
    Constraints = [Constraints, sum_mk1(i) == f(i) * f(i)];
end
for i = 1:data.n
    Constraints = [Constraints, sum_mk(i) == sum_mk1(i)* f(i)];
end




for i = 1:data.n
    Constraints = [Constraints, ct_time(i) == sum( data.ct(i,:) .* x(i,:) ) * f_1(i)];
end
for i = 1:data.n
    Constraints = [Constraints, ct_time(i) == fin_time(i) - start_time(i)];
end

for i = 1:data.n
    Constraints = [Constraints, px_cmk(i) == sum_px(i) + sum_c(i) * sum_mk(i)]  ;
end


for i = 1:data.m
    Constraints = [Constraints, e_0(i) == max(fin_time) * data.pks(i)];
end
for i = 1:data.n
    Constraints = [Constraints, e_1(i) == px_cmk(i) * ct_time(i)] ;
end
% for i = 1:data.n
%     Constraints = [Constraints, e_1(i) == px_cmk(i) * (fin_time(i) - start_time(i))] ;
% end





% 写目标函数
fit = sum(e_0) + sum(e_1);

% % 选择求解器
% ops = sdpsettings('solver','cplex','verbose',2);
% 
% % 调用cplex求解目标函数,求最小值
% optimize(Constraints,f,ops)
% ops = sdpsettings();


ops = sdpsettings('solver','gurobi','verbose',2);
% ops = sdpsettings();







% ops = sdpsettings('solver','cplex','verbose',2);
% ops = sdpsettings('verbose',1,'solver','cplex');
% solvesdp(Constraints,fit,ops);


result = optimize(Constraints, fit, ops);



value_x = value(x);
value_y = value(y);
value_start_time = value(start_time);
value_fin_time = value(fin_time);
value_fit = value(fit);
value_f = value(f);


time_cost = toc;


save ( 'res_fft9_10.mat', 'value_fin_time','value_start_time','value_x',"value_y", 'time_cost', 'value_fit','value_f')
% save ( 'res_gs14.mat', 'value_fin_time','value_start_time','value_x',"value_y", 'time_cost', 'value_fit','value_f')