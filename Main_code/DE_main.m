function [info,pop] = DE_main(pop,data,info,fit)


    info.n=data.n;
    info.m=data.m;
    info.h=1;
    info.cmax=data.cmax;
    % 设置算法参数
    pop_size = size(pop, 1);  
    dim = size(pop, 2);  % 决策变量维度
    F = 0.001;  % 变异因子
    max_gen = 1;  % 最大迭代次数
    gen = 1;  % 当前迭代次数
    cr = 0.5;


    v = zeros(pop_size, dim);
    v1 = zeros(pop_size, dim);
    v2 = zeros(pop_size, dim);
    % 开始DE迭代
    while gen <= max_gen
        % 变异操作
        for i = 1:pop_size
            % 保证3个解不相同
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
            r4 = randi(pop_size);
            while r4 == i || r4 == r1 || r4 == r2 || r4 == r3
                r4 = randi(pop_size);
            end

            



            [~,best]=min(fit);

            old_pop = pop;
            [sorted,index] = sort(fit);
            % 选出两个最强个体
            min_index = index(1:3);
            best1_pop = pop(min_index(1),:);
            best2_pop = pop(min_index(2),:);
            best3_pop = pop(min_index(3),:);


            % j1 = randi([1,data.n*3-1]);
            % j2 = randi([j1,data.n*3]);
            
            
            % v_i = pop(i,:) + F * (best1_pop - pop(i,:)) + F * (best2_pop - pop(i,:))+ F * (best3_pop - pop(i,:));
            % u=  v_i;


            v_i = F * (pop(r1,:) - pop(r2,:))  + F * (pop(r3,:) - pop(r4,:));
            u = pop(r4,:) + v_i;
            
            for j = 1: data.n*3
                if rand() < cr
                    pop(i, j)=u(j);
                end
            end

            pop_i = pop(i,:); % 初始化试验个体为当前个体
            j_rand = randi([1 data.n*3]); % 随机选择一个起始维度
            for j = 1:data.n*3
                if rand() < cr || j == j_rand
                    pop_i(j) = u(j); % 从变异个体复制
                end
            end
            
            pop(i,:) = pop_i;
            
            
            for j = 1:data.n*3
                if pop(i,j) <= 0 || pop(i,j) >= 1  && rand() < 0.8
                    pop(i,j) = old_pop(i,j);
                end
            end
            % fit_old = decode_01(old_pop(i,:),info,data);
            % fit_new = decode_01(pop(i,:),info,data);
            % if fit_old < fit_new
            %     pop(i,:) = old_pop(i,:);
            % end


            % v(i, :) = pop(i, :) + F * (  best1_pop - pop(r1,:)  ) + F * (  best2_pop - pop(r2,:)  ) + F * (  best3_pop - pop(r3,:)  );
            
            % v(i, :) = pop(i, :) + F * (  best1_pop - pop(i,:)  ) + F * (  best2_pop - pop(i,:)  ) + F * (  best3_pop - pop(i,:)  );
            % for j = 1:data.n*3
            %     if v(i,j) <= 0 || v(i,j) >= 1
            %         v(i,j) = old_pop(i,j);
            %     end
            % end





            % v1(i, :) = pop(i, :) + F * (pop(best,:)-pop(i,:)) + F * (  pop(r1, :) - pop(r2, :)  ) ;
            % for j = 1:data.n*3
            %     if v1(i,j) <= 0 || v1(i,j) >= 1
            %         v1(i,j) = old_pop(i,j);
            %     end
            % end
            % v2(i, :)=pop(i,:)+rand*(pop(r1,:)-pop(i,:))+F*(pop(r3,:)-pop(r2,:));
            % for j = 1:data.n*3
            %     if v2(i,j) <= 0 || v2(i,j) >= 1
            %         v2(i,j) = old_pop(i,j);
            %     end
            % end
            % 
            % e_v1 = decode_01(v1(i, :),info,data);
            % e_v2 = decode_01(v2(i, :),info,data);
            % if e_v1<=e_v2
            %     v(i,:) = v1(i,:);
            % else 
            %     v(i,:) = v2(i,:);
            % end


        end 
        

        % pop = v;
        gen = gen+1;
    end

end







