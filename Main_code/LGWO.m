function [energy,time,fit_curve]=LGWO(info,data)

info.h=0.1;
info.np=40;
info.pc=0.8;
info.pm=0.15;
info.lamda=1;
info.cmax=data.cmax;
info.m=data.m;
info.n=data.n;
fit_curve = zeros(1, info.ng);
if info.num<=4
    load Qres_small.mat
elseif (info.num>4)&&(info.num<8)
    load Qres_medium.mat
else
    load Qres_large.mat
end

tic
pop=rand(info.np,info.n*3); 
[fit,~]=decode_01(pop,info,data);
fitb=zeros(1,info.ng);   
fithis=zeros(info.ng,info.np);
for I=1:info.ng
    time_cost=toc;
    if time_cost>info.maxrt
        break
    end
    [~,index]=sort(fit);
    fithis(I,:)=fit;
    fitb(I)=min(fit);
    popb=pop(index(1),:);
    s=getState(pop,popb,fit,info,fithis,I);
    [~,info.l]=max(Q(s,:));
    poptemp = GWO_gen(pop,info,fit);
    [fitnew,~]=decode_01(poptemp,info,data);

    for i=1:info.np
       if fitnew(i)<fit(i)
          pop(i,:)=poptemp(i,:);
          fit(i)=fitnew(i);
       end
    end
    fit_curve(I) = min(fit);
end
energy=min(fit);
time=time_cost;
