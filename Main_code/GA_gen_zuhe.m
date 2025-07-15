function popout=GA_gen_zuhe(pop,info,fit)

[ps, len]=size(pop);
ncr=round(ps*info.pc);
nmu=round(ps*info.pm);
popout=pop;
f=1./fit;
f=f./sum(f);
f=cumsum(f);

for i=1:2:ncr
    i1=find(rand<=f,1,'first');
    i2=find(rand<=f,1,'first');
    j=randi([1 len]);
    popout(i1,:)=[pop(i1,1:j) pop(i2,j+1:end)];
    popout(i2,:)=[pop(i2,1:j) pop(i1,j+1:end)];
end

for i=1:nmu
    j=randi([1 ps]);
    j1=randi([1 len-1]);
    j2=randi([j1+1 len]);

%     popout(j,j1)=rand(1,1);
%     popout(j,j2)=rand(1,1);

    popout(j,j1)=randi([1,9]);
    popout(j,j2)=randi([1,9]);
end