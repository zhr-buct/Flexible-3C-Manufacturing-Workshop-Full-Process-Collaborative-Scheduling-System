function popout=GWO_gen(poptemp,info,fit)



[~,index]=sort(fit);
pop_a=poptemp(index(1),:);
pop_b=poptemp(index(2),:);
pop_c=poptemp(index(3),:);

for i=1:round(size(poptemp,1)/3)
    da=info.l*rand(1,1)*pop_a-poptemp(i,:);
    db=info.l*rand(1,1)*pop_b-poptemp(i,:);
    dc=info.l*rand(1,1)*pop_c-poptemp(i,:);
    y1=pop_a-(rand(1,1)*2-1)*da;
    y2=pop_b-(rand(1,1)*2-1)*db;
    y3=pop_c-(rand(1,1)*2-1)*dc;
    poptemp(i,:)=(y1+y2+y3)/3;
end

poptemp=mod(poptemp, 1);

f=1./fit;
f=f./sum(f);
f=cumsum(f);

[ps, len]=size(poptemp);
for i=1:2:round(ps)
    i1=find(rand<=f,1,'first');
    i2=find(rand<=f,1,'first');
    j=randi([1 len]);
    poptemp(i1,:)=[poptemp(i1,1:j) poptemp(i2,j+1:end)];
    poptemp(i2,:)=[poptemp(i2,1:j) poptemp(i1,j+1:end)];
end

popout=poptemp;
[ps,l]=size(poptemp);
pm = 0.4;
for i=1:2:ps
    temp=rand(1,1);
    if temp < pm
        temp=randperm(l);
        cw1=temp(1);
        cw2=temp(2);
        popout(i,cw1)=rand(1,1);
        popout(i,cw2)=rand(1,1);
    end
end