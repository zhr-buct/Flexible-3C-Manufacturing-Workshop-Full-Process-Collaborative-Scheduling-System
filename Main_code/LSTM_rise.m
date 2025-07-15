function poptemp = LSTM_rise(pop,info,data,aco_net,len,dlX,dlZ)
    
    pop_size = size(pop,1);
    popnew = [];
    for i = 1 : pop_size
        state = struct;
        state.HiddenState = dlZ(:,i);
        state.CellState = zeros(size(dlZ(:,i)),'like',dlZ(:,i));

        temp_dlx = dlX(i,:,:);

        dlY = modelDecoder(aco_net, temp_dlx, state);
        
        [~,idx] = max(dlY,[],1);  % 选出dlY当中每个类的最大值所在的位置
        idx = squeeze(idx)';
        res = idx(1:end-2);
        solnew = res-1; % 和前面的机器数加1做个抵消
        for k=1 : data.n
            if (solnew(k) > data.m)||(solnew(k)<1)
                solnew(k) = randi([1 data.m]);
            end
        end

        sol = [solnew, pop(i,len+1:end)];
        

        popnew = [popnew; sol];


    end

    poptemp = zeros(pop_size,size(popnew(1,:),2));
    for i = 1 : pop_size
        for j = 1:size(popnew(1,:),2)
            poptemp(i,j) = popnew(i,j);
        end
    end








    