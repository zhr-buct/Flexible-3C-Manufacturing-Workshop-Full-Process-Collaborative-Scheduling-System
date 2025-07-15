function [info,solnew]=insert_seq(sol,data,info)

for x = 1 : info.tl
    soltemp=sol;
    fit=decode(sol,info,data);
    temp=randperm(data.n);
    i=temp(1);
    j=temp(2);
    soltemp(data.n+j)=sol(data.n+i);
    soltemp(data.n+i:data.n+j-1)=sol(data.n+i+1:data.n+j);
    fittemp=decode(soltemp,info,data);
    if fittemp<fit
        sol=soltemp;
    end
end
solnew=sol;