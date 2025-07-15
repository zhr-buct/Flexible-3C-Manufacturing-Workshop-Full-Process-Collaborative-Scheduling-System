function [info,popout] = IPDA(pop, info, data, fit)


    num = 1;
    pop_temp = rand(num, data.n*3);

    
    
    [~, sorted_indices] = sort(fit, 'descend');
    sorted_indices = sorted_indices(1:num);
    
    index = 1;
    for i = sorted_indices
        pop(i,:) = pop_temp(index,:);
        index = index + 1;
    end


    popout = pop;



