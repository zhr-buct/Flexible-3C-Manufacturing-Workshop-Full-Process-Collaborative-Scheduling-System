function [x, fval, exitflag, output] = feasibleDirectionMethod(x0, data, info)
% 可行方向法求解约束优化问题
% min f(x)
% s.t. ConsViolation(x) <= 0

% 输入：
%   x0: 初始解
%   data: 数据结构体
%   info: 信息结构体

% 输出：
%   x: 最优解
%   fval: 最优目标函数值
%   exitflag: 退出标志
%   output: 优化输出结构体

% 初始化
maxIter = 1000;
tolFun = 1e-6;
tolCon = 1e-6;
alpha = 0.1;
beta = 0.5;

% 迭代搜索
for iter = 1:maxIter
    % 计算当前解的适应度值
    fval = decode(x0, info, data);
    
    % 计算约束违反量
    ConsViolation = 1;
    
    % 生成随机方向作为可行方向
    d = rand(size(x0)) - 0.5;
    
    % 构建线性规划子问题
    f = -d;
    A_lin = [];
    b_lin = [];
    
    if ~isempty(ConsViolation)
        A_lin = repmat(ConsViolation', length(d), 1);
        b_lin = -ones(size(ConsViolation));
    end
    
    % 求解线性规划子问题,获得可行方向的步长
    [step, ~, exitflag, ~] = linprog(f, A_lin, b_lin, [], [], [], [], optimset('Display', 'off'));
    
    % 检查线性规划求解状态
    if exitflag <= 0
        output.message = 'Linear program solver failed';
        break;
    end
    
    % 更新迭代点
    x = x0 + alpha*step*d;
    
    % 检查收敛性
    if norm(step*d) < tolFun && max(ConsViolation) < tolCon
        output.message = 'Optimization converged';
        exitflag = 1;
        break;
    end
    
    % 更新步长因子
    alpha = alpha*beta;
    
    % 更新迭代点
    x0 = x;
end

% 检查是否达到最大迭代次数
if iter >= maxIter
    output.message = 'Maximum number of iterations reached';
    exitflag = 0;
end

% 输出结果
output.iterations = iter;
output.funcCount = iter + 1;
end