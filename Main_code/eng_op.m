function [info,solnew]=eng_op(data,info,solnew,eng_op)


if eng_op == 12
    [info,solnew]=swapsol_eng(solnew,data,info); % 7
    [info,solnew]=insert_eng(solnew,data,info); % 8
elseif eng_op == 23
    [info,solnew]=insert_eng(solnew,data,info); % 8
    [info,solnew]=mutate_eng(solnew,data,info); % 9
elseif eng_op == 123
    [info,solnew]=swapsol_eng(solnew,data,info); % 7
    [info,solnew]=insert_eng(solnew,data,info); % 8
    [info,solnew]=mutate_eng(solnew,data,info); % 9
end