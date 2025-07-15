function [poptemp,len,dlX_all,dlZ_all,dlX,lstm_sol] = LSTM_reduction(pop,info,data,aco_net)


    popnew = [];
    pop_size = size(pop, 1);
    dlX_all=[];
    dlZ_all=[];
    for i = 1:pop_size
        pop(i, 1:data.n) = ceil( pop(i , 1 : data.n) * data.m );
    end

    for i = 1:pop_size
        test_data = [1 pop(i, 1:data.n)+1 data.n+2];

        parameters = aco_net;
        sequenceLength=length(test_data);
        executionEnvironment = "auto";
        dlX = dlarray(test_data,'BTC');  % 理解成test_data
        if (executionEnvironment == "auto" && canUseGPU) || executionEnvironment == "gpu"
            dlX = gpuArray(dlX);
        end

        dlX_all = [dlX_all; dlX];

        dlZ = modelEncoder(parameters,dlX,sequenceLength);
        lstm_sol = double(dlZ); 
        soltemp = lstm_sol';
        dlZ_all = [dlZ_all, lstm_sol];
    
        popnew = [popnew; soltemp pop(i, data.n+1:data.n*3)] ;   

        


    end

    poptemp = zeros(pop_size, size(popnew(1,:),2));
    for i = 1 : pop_size
        for j = 1:size(popnew(1,:),2)
            poptemp(i,j) = popnew(i,j);
        end
    end




    len = length(soltemp);