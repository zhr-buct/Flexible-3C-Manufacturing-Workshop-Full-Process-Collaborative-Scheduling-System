function sol = pop_initial(sol,info,data)


soltemp = sol;


temp1 = randi(data.n);
temp2 = randi(data.n);
temp3 = randi(data.n);
if rand() > 0.2
    sol(temp1) = soltemp(temp2);
    sol(temp2) = soltemp(temp1);
    sol(temp3) = randi(data.m);
else
    sol(temp3) = randi(data.m);
end

temp4 = randi(data.n);
temp5 = randi(data.n);
temp6 = randi(data.n);
if rand() > 0.2
    sol(data.n + temp4) = soltemp(data.n + temp5);
    sol(data.n + temp5) = soltemp(data.n + temp4);
    sol(data.n + temp6) = randi(data.n);
else
    sol(data.n + temp6) = randi(data.n);
end


for i = 1:data.n
    if rand() > 0.8
        sol(2*data.n + i) = rand();
    end
end






