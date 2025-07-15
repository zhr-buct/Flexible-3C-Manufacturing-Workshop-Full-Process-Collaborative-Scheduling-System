function s=getState(pop,popb,fit,info,fithis,I)

e=0;%0-20;20-50;51+
r=0;%0-30;30-1000;1000+
d=0;%0-100;100-10000;10000+

[pop_size,~] = size(pop);

for i=1:pop_size
    for j=1:size(pop,2)
        e=e+(pop(i,j)-popb(j))^2;
    end
end
if e<=400
    indexE=1;
elseif (e>400)&&(e<=600)
    indexE=2;
else
    indexE=3;
end
temp=sum(fit)/pop_size;
for i=1:pop_size
    for j=1:pop_size
        d=d+abs(fit(i)-fit(j))*(fit(i)-temp)^2;
    end
end
d=sqrt(d);
if d<=40000
    indexD=1;
elseif (d>40000)&&(d<=100000)
    indexD=2;
else
    indexD=3;
end
for i=1:pop_size
    if I>=3
        r=(sum(fithis(I-1,:))-sum(fithis(I,:)))/((sum(fithis(I-2,:))-sum(fithis(I-1,:)))+1);
    end
end
if I>3
    if r<=30
        indexR=1;
    elseif (r>30)&&(r<=1000)
        indexR=2;
    else
        indexR=3;
    end
else
    indexR=3;
end
t=I/info.ng;
if t<=1/3
    indexT=1;
elseif (t>1/3)&&(t<2/3)
    indexT=2;
else
    indexT=3;
end

load Smatrix.mat
s=sMatrix(indexE,indexD,indexR,indexT);