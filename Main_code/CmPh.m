function popout=CmPh(pop,popb,info,fit)

f=1./fit;
f=f./sum(f);
f=cumsum(f);

[ps, len]=size(pop);
for i=1:2:round(ps/2)
    i1=find(rand<=f,1,'first');
    i2=find(rand<=f,1,'first');
    j=randi([1 len]);
    pop(i1,:)=[pop(i1,1:j) pop(i2,j+1:end)];
    pop(i2,:)=[pop(i2,1:j) pop(i1,j+1:end)];
end

popout=pop;
[ps,l]=size(pop);

for i=1:ps
    temp=rand(1,1);
    if temp<info.pm
        temp=randperm(l);
        cw1=temp(1);
        cw2=temp(2);
        popout(i,cw1)=rand(1,1);
        popout(i,cw2)=rand(1,1);
    end
end