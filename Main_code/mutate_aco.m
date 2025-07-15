function [info,solnew,fit]=mutate_aco(sol,data,info)

soltemp=sol;
fit=decode(sol,info,data);

for i=1:data.n-1
    soltemp(i)=randi(info.m);
    fittemp=decode(soltemp,info,data);
    if fittemp<fit
        sol=soltemp;
        fit = fittemp;
    end
end

solnew=sol;