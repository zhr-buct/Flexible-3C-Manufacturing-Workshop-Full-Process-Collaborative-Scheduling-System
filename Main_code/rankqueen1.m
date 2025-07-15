% rankqueen1函数的作用是根据任务的权重和依赖关系计算任务的排名
% 并返回按照排名排序后的任务索引数组
% 这个函数在后续的代码中可能用于任务调度或优化算法中。
% data.aft是dataheft.aft = dataheft.hx;
% data.w是dataheft.w = dataheft.ct;
% data.c是dataheft.c = dataheft.st;

function  indexS = rankqueen1(data,info) % 返回一个排序后的任务索引数组indexS


% 这段代码的目的是构建一个有向无环图（DAG）的邻接矩阵表示，用于后续计算任务的排名。
DAG_Matrix = zeros(info.n, info.n);
% 通过两个嵌套的for循环遍历data.aft矩阵的每个元素。
% 外部循环iRow控制行的迭代，内部循环iColumn控制列的迭代。
for iRow = 1:size(data.aft, 1)
    for iColumn = 1:size(data.aft, 2)
        if ~eq(data.aft(iRow, iColumn), 0) % 如果data.aft(iRow, iColumn)不等于零
            DAG_Matrix(iRow, data.aft(iRow, iColumn)) = 100;
        end
    end
end
% 最后结果是一个只有100和0的矩阵，例如（3，4）位置是100，则表示节点3指向节点4



% 计算任务的排名（rank）
rank=zeros(1,info.n);

for i=info.n:-1:1   % 逆序循环
    w=0;    % 变量 w 用于计算当前任务的权重总和。
    for j=1:info.m
        w=w+data.w(i,j);   % 计算第i个任务在5个机器上运行的计算时间之和
    end

    if i==info.n
        rank(i)=w/info.m;
    else 
        temp=0;
        for k=1:info.n
             if data.c(i,k)~=-1 
                 temp=max(temp,rank(k)+data.c(i,k));% 如果第i个和第k个任务之间的整定时间不为-1
                                                    % 就是有整定时间的话，就求temp是求最大时间
             end
        end
        rank(i)=w/info.m+temp;
    end
end


[rank, indexS]=sort(rank,'descend');