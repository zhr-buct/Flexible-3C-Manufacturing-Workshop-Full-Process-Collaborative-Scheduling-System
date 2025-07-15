function [info,solnew,fit]=insert_eng(sol,data,info)

%将第i个task的ECU插入到第j个位置
soltemp=sol;
fit=decode(sol,info,data);


temp2=randperm(data.n);
j=temp2(1);
i=temp2(2);
soltemp(data.n * 2+j)=sol(data.n * 2+i);
soltemp(data.n * 2+i:data.n * 2+j-1)=sol(data.n * 2+i+1:data.n * 2+j);
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
 

solnew=info.solbest;