function [fit,able,fadv,popin]=decode_g_result(popin,info,data)
% popin=sol

fp=popin(1:data.n); % sch.xij
info.n = data.n;
info.m = data.m;
info.cmax = data.cmax;

seq=zeros(1,info.n);
xh=data.xh;
hx=data.hx;
j=1;
sol = zeros(1,data.n*3);
% 利用调度结果中的任务开始时间sch.st进行排序。这里的sol(info.n+1:2*info.n)就是任务顺序
[~,index]=sort(popin(info.n+1:2*info.n));

% 这段代码的作用是根据先后约束确定实际任务的优先级，并生成一个任务序列 seq。
indexflag=zeros(1,info.n);
while j<info.n+1
    for i=1:info.n
        if all(xh(index(i),:)==0)&&(indexflag(i)==0) % 首先检查任务 index(i) 的所有前置任务
                                                     % 是否已经完成（即在 xh 中对应的行全为零）
                                                     % 且任务 index(i) 在 indexflag 中对应的位置为零。
                                                     % 如果满足这两个条件，表示任务可以添加到任务序列中。
            seq(j)=index(i);
            j=j+1;
            indexflag(i)=1;
            % 通过嵌套的两个 for 循环，将任务 index(i) 在 hx 中对应的前置任务位置设置为零
            % 表示这些前置任务已经被当前任务 index(i) 所取代。
            for k=1:size(hx,2)
                for l=1:size(xh,2)
                    if hx(index(i),k)~=0
                        if xh(hx(index(i),k),l)==index(i)
                            xh(hx(index(i),k),l)=0;
                            break
                        end
                    end
                end
            end
        end
    end
end

seq = popin(data.n+1:data.n*2);




f = popin(info.n*2+1:info.n*3);

% 对每个任务进行循环计算，得到每个任务的启动时间、完成时间
% 并更新处理器类型的最后任务的完成时间。
xh=data.xh;
for k=1:data.m
    mt=zeros(1,info.m);
    st=zeros(1,info.n);
    dt=zeros(1,info.n);
    dn=zeros(1,info.n);
    for i=1:info.n
        curr = seq(i);
        
        dn(curr)=fp(curr);
        temp=find(xh(curr,:)>0);
        if ~isempty(temp)
            tst=zeros(1,length(temp));
            for j=1:length(temp)
                if dn(curr)~=dn(xh(curr,j))
                    tst(j)=dt(xh(curr,j))+data.st(xh(curr,j),curr);
                else
                    tst(j)=dt(xh(curr,j));
                end
            end
        end
        if ~isempty(temp)
            tlast=max(tst);
        else
            tlast=0;
        end
        st(curr)=max(mt(fp(curr)),tlast);
        dt(curr) = st( curr ) + data.ct(curr,dn(curr))/f(curr);
        mt(fp(curr))=dt(curr);
    end
end

% 判断任务调度是否满足总计算时间约束
if max(mt)>info.cmax+0.1
    able=0;
else
    able=1;
end

% 计算了各个处理器类型的能量消耗以及总能量消耗。
em=max(mt)*data.pks;%各个机器的Es能量
e=sum(em);

% 这段代码计算了每个任务的能量消耗，并将其累加到总能量消耗 e 中。
for i=1:info.n
    e=e+(   (data.p(dn(i))+data.c(dn(i))* (  f(i)^3)  ) * (data.ct(i,dn(i))/f(i))   );
end


% for i=1:info.n
%     e=e+((data.p(dn(i))+data.c(dn(i))*f(i)^(data.mk(dn(i))))*(dt(i)-st(i)));
% end






% fadv
fadv=zeros(1,info.n);
for i=1:info.n
    if popin(info.n*2+i)>=0.99
        fadv(i)=1;
    end
end

% 这段代码计算了一个适应度值 fit
% 基于最大完成时间 max(mt) 和总计算时间约束 info.cmax 的差异以及能量消耗 e。

% 如果最大完成时间与总计算时间约束之间的差异大于 0，即超过了约束
% 那么将适应度值 fit 计算为能量消耗 e 加上差异乘以 2，再加上 100。
if max(mt)-info.cmax > 0.1
    fit=e+(max(mt)-info.cmax)*2 + 100;
else
    fit=e;
end
