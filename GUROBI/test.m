clear
clc
load datain.mat


info.mode = 1;
info.num  = 3;


if info.mode==1
    temp=['data=datain.fft',num2str(info.num),';'];
elseif info.mode==2
    temp=['data=datain.gs',num2str(info.num),';'];
else
    error('unavailable');
end
eval(temp)

info = setuppara(info);
% 定义变量:sdpvar:实数变量,intvar:整数变量，binvar:0-1变量

x = sdpvar(1,2,'full');


% 写目标函数
f = 2*x(1)+3*x(2);


% 定义约束条件
Constraints = [];
Constraints = [Constraints, x(1)+x(2)>=350];
Constraints = [Constraints,x(1)>=100];
Constraints = [Constraints,2*x(1)+x(2)<=600];
Constraints = [Constraints,x(1)>=0];
Constraints = [Constraints,x(2)>=0];





% % 选择求解器
% ops = sdpsettings('solver','cplex','verbose',2);
% 
% % 调用cplex求解目标函数,求最小值
% optimize(Constraints,f,ops)

% ops = sdpsettings();
ops = sdpsettings('verbose',1,'solver','gurobi');
solvesdp(Constraints,f,ops)


for j = 1:data.n
    data_xh = data.xh(j,:);
    for i = data_xh
        if i ~= j && i~=0
            disp(i)
        end
    end
    disp(' ')
    disp(' ')
end



[data.DAG, ~] = ranku(data);

% 初始化描述任务前驱关系的矩阵
x = zeros(data.n, data.m);

% 遍历每个任务
for i = 1:data.n
    % 查找任务 i 的前驱任务
    predecessors = find(data.DAG(:, i));
    
    % 更新 x(i, :) 对应的列
    x(i, predecessors) = 1;
end

index = find(x(10,:)==1);
