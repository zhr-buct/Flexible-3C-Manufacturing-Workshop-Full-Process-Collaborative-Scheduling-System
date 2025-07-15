function solnew=loc_energy(sol,data,info)
% 函数的目的是对解 sol 进行能量调整，以改善解的适应度或满足特定的能量限制
soltemp=sol;
info.n = data.n;
info.m = data.m;
info.cmax = data.cmax;
for i=1:1000
    soltemp(data.n*2+1:end)=sol(data.n*2+1:end)*(1-i/1000);
    ab=jugg(soltemp,info,data);
    if ab==0
        break
    end
end
N=i-1; % 迭代次数

%以最优为均值，随机将能量初始化,高斯分布随机初始化 soltemp 的能量部分
soltemp(data.n*2+1:end)=normrnd((i-1)/1000,0.05,1,data.n);
for i=1:data.n
    if soltemp(data.n*2+i)<=0
        soltemp(data.n*2+i)=rand(1,1);
    elseif soltemp(data.n*2+i)>=1
        soltemp(data.n*2+i)=rand(1,1);
    end
end

index=randperm(data.n);

for i=1:data.n
    soltemp(data.n*2+index(i))=unifrnd(1-N/1000,1);
    ab=jugg(soltemp,info,data);
    if ab==1
        break
    end
end

solnew=soltemp;