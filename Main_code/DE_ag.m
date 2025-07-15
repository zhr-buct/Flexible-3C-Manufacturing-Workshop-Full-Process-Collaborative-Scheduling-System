function [info, popout] = DE_ag(pop, info, fitness, data)
    % 设置算法参数
    pop_size = size(pop, 1);  
    dim = size(pop, 2);  % 决策变量维度
    F = 0.0511111;  % 变异因子
    CR = 0.2;  % 交叉概率
    max_gen = 1;  % 最大迭代次数
    gen = 1;  % 当前迭代次数
    fitness_u = zeros(1, pop_size);
    popout = zeros(pop_size,data.n*3);
    % 对种群进行归一化

    for i=1:pop_size
        pop(i,1:data.n) = pop(i,1:data.n) / data.m;
        pop(i,data.n+1:data.n*2) = pop(i,data.n+1:data.n*2) / data.n;
    end
    v = zeros(pop_size, dim);

    % 开始DE迭代
    while gen <= max_gen
        % 变异操作
        
        for i = 1:pop_size
            r1 = randi(pop_size);
            while r1 == i
                r1 = randi(pop_size);
            end
            r2 = randi(pop_size);
            while r2 == i || r2 == r1
                r2 = randi(pop_size);
            end
            r3 = randi(pop_size);
            while r3 == i || r3 == r1 || r3 == r2
                r3 = randi(pop_size);
            end

            v(i, :) = pop(r1, :) + F * (pop(r2, :) - pop(r3, :)) ;
            for j = 1:data.n*3
                if v(i,j) <= 0 || v(i,j) >= 1
                    v(i,j) = rand();
                end
            end
        end 
 



        % 交叉操作
        u = pop;
        for i = 1:pop_size
            jrand = randi(dim);
            for j = 1:dim
                if rand() <= CR || j == jrand
                    u(i, j) = v(i, j);
                end
            end
        end
        for i =1:pop_size
            for j = 1:data.n*3
                if u(i,j) <= 0 || u(i,j) >= 1
                    u(i,j) = rand();
                end
            end
        end 
        

        % 选择操作
        
        for i = 1:pop_size
            [fitness_u(i),~]=decode_GA(u(i,:),info,data,fitness);
            if fitness_u(i) < fitness(i)
                pop(i, :) = u(i, :);
                fitness(i) = fitness_u(i);
            end
        end

        gen = gen + 1;
    end
    for i=1:pop_size
        popout(i,1:data.n) = ceil(pop(i,1:data.n) * data.m);
        [~,popout(i,data.n+1:data.n*2)] = sort(pop(i,data.n+1:data.n*2) * data.n);
        popout(i,data.n*2+1:data.n*3) = pop(i,data.n*2+1:data.n*3);
    end
end





