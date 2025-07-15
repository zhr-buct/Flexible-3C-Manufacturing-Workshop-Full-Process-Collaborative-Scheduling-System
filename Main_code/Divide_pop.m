function [pop_HD, pop_LD] = Divide_pop(pop, info, data, num_LD, num_HD)
    

    [pop_size, ~] = size(pop);
    
    index_HD = 1:num_HD;
    pop_HD = pop(index_HD, :);

    index_LD = num_HD+1:pop_size;
    pop_LD = pop(index_LD, :);



    
end