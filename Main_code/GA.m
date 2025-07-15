function [energy,time,fit_curve] = GA(info,data)

    pop=rand(info.np,data.n*3);
    info.n=data.n;
    info.m=data.m;
    info.h=1;
    info.cmax=data.cmax;
    fit_curve = zeros(1, info.ng);
    [fit,~] = decode_01(pop,info,data);
    fitb=zeros(1,info.ng);
    fithis=zeros(info.ng,info.np);
    tic
    for I=1: ceil(info.ng)
        time_cost=toc;
        if time_cost>info.maxrt
            break
        end
        fithis(I,:)=fit;
        fitb(I)=min(fit);
        action = 1;
        [info, pop, fit]=RL_action(pop,data,info,action,fit);
        fit_curve(I) = min(fit);
    end
    energy=min(fit);
    time=time_cost;
    
end