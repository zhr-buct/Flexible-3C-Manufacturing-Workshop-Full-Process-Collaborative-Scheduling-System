function  [DAG_Matrix, indexS] = ranku(data)

% HEFT的预处理部分
% 输入data，包含：
% 1.任务之间的 依赖关系（先序或者后序）data.hx
% 2.任务在不同机器数的 执行时间 data.m  data.ct
% 3.任务之间的 整定时间 data.st

% 得到 DAG矩阵 和 计算任务的排名


% 计算量越大、整定时间越长的任务在排名中具有更高的权重和更靠前的位置
% 即最小化任务的总执行时间和最大化计算资源的利用率。
% 通过将计算量较大和整定时间较长的任务放在更高的位置
% 可以更好地平衡任务之间的依赖关系和执行时间，从而提高整体调度的效率。

% 即比较任务优先级相同的时候，对其权重进行排序

info.m = data.m;  % 机器数
info.n = size(data.ct,1); % 任务数
data.w = data.ct;  % 任务执行任务的时间

% 这段代码的目的是构建一个有向无环图（DAG）的邻接矩阵表示，用于后续计算任务的排名。
DAG_Matrix = zeros(info.n, info.n);
% 通过两个嵌套的for循环遍历data.hx矩阵的每个元素。
% 外部循环iRow控制行的迭代，内部循环iColumn控制列的迭代。
for iRow = 1:size(data.hx, 1)
    for iColumn = 1:size(data.hx, 2)
        if ~eq(data.hx(iRow, iColumn), 0) % 如果data.hx(iRow, iColumn)不等于零,代表iRow有后续任务
            DAG_Matrix(iRow, data.hx(iRow, iColumn)) = 1;
        end
    end
end
% 最后结果是一个只有1和0的矩阵，例如（3，4）位置是1，则表示节点3指向节点4

rank=zeros(1,info.n);

for i=info.n:-1:1   % 逆序循环
    w=0;    % 变量 w 用于计算当前任务的权重总和。
    for j=1:info.m
        w=w+data.w(i,j);   % 计算第i个任务在4个机器上运行的计算时间之和
    end

    if i==info.n
        rank(i)=w/info.m;  % 最后一个任务的rank
    
    else 
        temp=0;
        for k=1:info.n
             if data.st(i,k)~=-1
                 temp=max(temp,rank(k)+data.st(i,k));% 如果第i个和第k个任务之间的整定时间不为-1
                                                    % 任务i到k的整定时间+任务k的执行时间的最大值
                 % disp([i, k,temp]);               % 就是求在任务i之前的任务k最晚完成时间
             end
         end
        rank(i)=w/info.m+temp;  % 任务i的权重，权重越大代表先执行
    end
end

[rank, indexS]=sort(rank,'descend');