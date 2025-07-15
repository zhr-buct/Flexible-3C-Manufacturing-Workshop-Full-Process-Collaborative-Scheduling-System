function [energy,time,fit_curve]=ACS(info,data)

info.m=data.m;
info.MPEn=3;
info.MPEv=2;
info.n=data.n;  
tic
info.h=0.1;
info.np=40;
info.pa=0.25;
info.pc=0.8;
info.pm=0.15;
info.lamda=1;
info.cmax=data.cmax;
pop=rand(info.np,info.n*3);
fit=zeros(1,info.np);
info.dis=0.5;
able=zeros(1,info.np);

for i=1:info.np
   [fit(i),able(i)]=decode_ACS(pop(i,:),info,data);
end

info.h=MPE(pop,info,fit,data);
fitnew=zeros(size(fit));
fitb=zeros(1,info.ng);
adv=zeros(info.np,info.n);   
fithis=zeros(info.ng,info.np);
fit_curve = zeros(1,info.ng);
for I=1:info.ng
    time_cost=toc;
    if time_cost>info.maxrt
        break
    end
    [~,index]=sort(fit);
    fithis(I,:)=fit;
    fitb(I)=min(fit);
    popb=pop(index(1),:);
    info.h=MPE(pop,info,fit,data);
    poptemp=muPh(pop,popb,info);
    
    for i=1:info.np
        [fitnew(i),able(i)]=decode_ACS(poptemp(i,:),info,data);
    end
    poppa=CmPh(poptemp,popb,info,fitnew);
    for i=1:info.np
        [fitnew(i),able(i)]=decode_ACS(poppa(i,:),info,data);
    end
    for i=1:info.np
       if fitnew(i)<fit(i)
          pop(i,:)=poppa(i,:);
          fit(i)=fitnew(i);
       end
    end
    fit_curve(I) = min(fit);
end   

energy=min(fit);
time=time_cost;