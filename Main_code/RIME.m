function [Rimepop, Rime_rates]=RIME(pop,data,info,Max_iter)
    % 冰霜优化算法
    info.n = data.n;
    info.m = data.m;
    info.h=1;
    info.cmax = data.cmax;
    lb = 0;
    ub = 1;
    dim = data.n*3;
    [N, ~]=size(pop);
    Best_rime=zeros(1,dim);
    Best_rime_rate=inf;
    Rimepop = pop;
    Lb=lb.*ones(1,dim);
    Ub=ub.*ones(1,dim);
    it=1;
    Rime_rates=zeros(1,N);
    newRime_rates=zeros(1,N);
    W = 5;%Soft-rime parameters, discussed in subsection 4.3.1 of the paper
    %Calculate the fitness value of the initial position
    for i = 1:N
        %Calculate the fitness value for each search agent
        Rime_rates(1,i) = decode_01( Rimepop(i,:), info, data );  
        % Make greedy selections
        if Rime_rates(1,i) < Best_rime_rate
            Best_rime_rate=Rime_rates(1,i);
            Best_rime=Rimepop(i,:);
        end
    end
    
    % Main loop
    while it <= 1
        RimeFactor = 0.1 * (rand-0.5)*2*cos((pi*it/(Max_iter/10)))*(1-round(it*W/Max_iter)/W);%Parameters of Eq.(3),(4),(5)
        E = 0.1 * sqrt(it / Max_iter);%Eq.(6)
        newRimepop = Rimepop;%Recording new populations
        normalized_rime_rates = normr(Rime_rates);%Parameters of Eq.(7)
        for i = 1 : N
            for j = 1 : dim
                % Soft-rime search strategy
                r1 = rand();
                if r1 < E
                    newRimepop(i,j) = Best_rime(1,j)+RimeFactor*((Ub(j)-Lb(j))*rand+Lb(j));%Eq.(3)
                end
                
                % Hard-rime puncture mechanism
                r2=rand();
                if r2 < normalized_rime_rates(i)
                    newRimepop(i,j)=Best_rime(1,j);%Eq.(7)
                end
            end
        end
    
        for i=1:N
            newRimepop(i,:) = Bounds( newRimepop(i,:), Ub, Lb, Best_rime);
            newRime_rates(1,i) = decode_01( newRimepop(i,:), info, data );  
            %Positive greedy selection mechanism
            if newRime_rates(1,i)<Rime_rates(1,i)
                Rime_rates(1,i) = newRime_rates(1,i);
                Rimepop(i,:) = newRimepop(i,:);
                if newRime_rates(1,i)< Best_rime_rate
                   Best_rime_rate=Rime_rates(1,i);
                   Best_rime=Rimepop(i,:);
                end
            end
        end
        it=it+1;
    end








end



