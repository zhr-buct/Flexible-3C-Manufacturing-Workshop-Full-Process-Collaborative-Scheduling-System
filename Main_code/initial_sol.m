function sol=initial_sol(sch,data)
% 将初始解的前"data.n"个元素设置为调度结果"sch.xij"，即每个任务所在的机器。
sol(1:data.n)=sch.xij;
% 对于初始解的后半部分，即从"data.n+1"到"data.n*2"的元素
% 利用调度结果中的任务开始时间"sch.st"进行排序的结果，结果得到任务的开始时间顺序。
[~,sol(data.n+1:data.n*2)]=sort(sch.st/(max(sch.st)+1));
% 初始解的最后"data.n"个元素，即从"data.n2+1"到"data.n3"的元素
% 设置为1，表示所有任务都处于激活状态。
sol(data.n*2+1:data.n*3)=ones(1,data.n);