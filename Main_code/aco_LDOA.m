function [popout, fit] = aco_LDOA(pop,data,info,aco_net,fit)

    % Low-dimensional optimization algorithm, LSTM低维优化算法


    [pop_size,~] = size(pop);
    [pop1,len_LSTM_aco,dlX_all,dlZ_all] = LSTM_reduction(pop,info,data,aco_net);

    [info,pop2] = RL_GA_cross(pop1,info,fit);
    [info,pop3] = RL_GA_mutation2(pop2, info, data);

    popout = LSTM_rise(pop3,info,data,aco_net,len_LSTM_aco,dlX_all,dlZ_all);
    
    % 强耦合子解匹配算法
    for i = 1 : pop_size
        [~,popout(i,data.n+1:data.n*2)] = sort(popout(i,data.n+1:data.n*2) * data.n);
        [info,popout(i,:)]=swapsol_seq(popout(i,:),data,info); 
        [info,popout(i,:)]=insert_seq(popout(i,:),data,info);
    end



    buchang_aco = 1 / data.m;
    buchang_seq = 1 / data.n;
    for i = 1:pop_size
        for j = 1:data.n
            popout(i,j) = popout(i,j) / data.m - rand() * buchang_aco;
            popout(i,data.n + j) = popout(i,data.n + j) / data.n - rand() * buchang_seq;
        end
    end

    [fitnew,~] = decode_01(popout,info,data);
    
    for i = 1 : pop_size
       if fitnew(i) < fit(i)
          pop(i,:) = popout(i,:);
          fit(i)=fitnew(i);
       end
    end


end