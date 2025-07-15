function [info,pop,fit]=operator_17(pop,data,info,fit)
dim = data.n * 3;
Lb=0.*ones(1,dim);
Ub=1.*ones(1,dim);
[~, len]=size(pop);
for xx = 1 : 1
    std_fit = std(fit);
    if std_fit > 1
        [info, sol, ~] = heft_sol(info,data);
        num = 1;
        [~, sorted_indices] = sort(fit, 'descend');
        sorted_indices = sorted_indices(1:num);
        index = 1;
        aco_gap = 1 / data.m;
        seq_gap = 1/ data.n;
        d1 = randi([1 data.n-1]);
        d2 = randi([d1 data.n]);
        for i = sorted_indices
            if rand() < 0.5
                pop(i, d1:d2) = sol(index,d1:d2) / data.m - aco_gap * rand();
            else
                pop(i, d1:d2) = sol(index,d1:d2) / data.m + aco_gap * rand();
            end
            if rand() < 0.5
                pop(i, data.n + d1 : data.n + d2) = sol(index, data.n+d1 : data.n + d2) / data.n - seq_gap * rand();
            else
                pop(i, data.n + d1 : data.n + d2) = sol(index, data.n+d1 : data.n + d2) / data.n + seq_gap * rand();
            end

            for x = i
                I = pop(x,:) <= Lb;
                pop(x,I) = rand(); 
                J = pop(x,:) >= Ub;
                pop(x,J) = rand(); 
            end

            % i1 = randi([1 info.np]);
            % i2 = randi([1 info.np]);
            % j = randi([1 len-2]);
            % k = randi([j+1 len-1]);
            % m = randi([k+1 len]);
            % pop(i1,:)=[pop(i1,1:j) pop(i2,j+1:k) pop(i1,k+1:m) pop(i2,m+1:end)];
            % pop(i2,:)=[pop(i2,1:j) pop(i1,j+1:k) pop(i2,k+1:m) pop(i1,m+1:end)];
            % 
            % [info,pop] = RL_GA_mutation2(pop, info, data);


            index = index + 1;
        end

        fit = decode_01(pop,info,data);
    end
end
