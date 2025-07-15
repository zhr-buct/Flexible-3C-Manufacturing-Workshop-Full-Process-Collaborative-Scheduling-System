function [info,solnew,fit]=random_seq(sol,data,info)

soltemp=sol;
fit=decode(sol,info,data);
vec = 1:data.n;

for i=1:data.n
   
    idx = randperm(length(vec));
    soltemp(data.n+1:data.n*2) = vec(idx);
    
    fittemp = decode(soltemp,info,data);
    %[fittemp,seq]=decode_seq(soltemp,info,data);
    
    if fittemp<fit
        %soltemp(data.n+1:data.n*2) = seq;
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
solnew=info.solbest;