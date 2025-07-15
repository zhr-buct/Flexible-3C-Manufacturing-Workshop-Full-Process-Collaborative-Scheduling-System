function [info,solnew,fit]=mutate_eng(sol,data,info)


soltemp=sol;
fit=decode(sol,info,data);

for i=1:data.n
    soltemp(data.n*2+i)=rand(1,1);
    fittemp=decode(soltemp,info,data);
    if fittemp<fit
        sol=soltemp;
        fit = fittemp;
        if fittemp<info.fitbest
            info.solbest=sol;
            info.fitbest=fittemp;
        end
    else
        temp=rand(1,1);
        if exp((fit-fittemp)/fit)>temp
            sol=soltemp;
        end
    end
end

for i=1:data.n
    temp=randperm(info.n); % 用于生成随机排列(从1 - info.n)
    temp1=temp(1);
    temp2=temp(2);
    soltemp(data.n*2+temp1)=rand(1,1); % 生成一个0-1之间的随机数
    soltemp(data.n*2+temp2)=rand(1,1);
    fittemp=decode(soltemp,info,data);
    if fittemp<fit
        sol=soltemp;
        if fittemp<info.fitbest
            info.solbest=sol;
            info.fitbest=fittemp;
        end
    end
end
solnew=info.solbest;