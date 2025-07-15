function [info,solnew]=perturbation_all(sol,data,info)

solnew=sol;

k=randi([2 data.n]);
j=data.hx(k,1);
i=data.xh(k,1);
if j<1
    j=1;
end
if i<1
    i=1;
end
if j>data.n
    j=data.n;
end
if i>data.n
    i=data.n;
end
if i<j
    r=randi([i j]);
else
    r=randi([j i]);
end

solnew(k)=sol(r);
solnew(r)=sol(k);

solnew(data.n+k)=sol(data.n+r);
solnew(data.n+r)=sol(data.n+k);

fit=decode(sol,info,data);
fitnew=decode(solnew,info,data);

if fitnew>fit
    solnew=sol;
end