function [pop,fit] = generation(pop,info,data)
% 生成最终方案
pop_size = size(pop,1);
fit = zeros(1,pop_size);
for i =1:pop_size
    pop(i,1:data.n) = ceil(pop(i,1:data.n)*data.m);
    [~,pop(i,data.n+1:data.n*2)] = sort(pop(i,data.n+1:data.n*2) * data.n);
    pop(i,data.n*2+1:data.n*3) = pop(i,data.n*2+1:data.n*3);
end

for k = 1:pop_size
    % fit(k) = decode(pop(k,:),info,data);
    [fit(k),~,~,sol]=decode_gener_result(pop(k,:),info,data);
    pop(k,data.n+1:data.n*2) = sol;
end
