function [info,solnew]=aco_op(data,info,sol,aco_op)


if aco_op == 12
    [info,solnew]=swapsol_aco(sol,data,info); % 1 
    [info,solnew]=insert_aco(solnew,data,info); % 2
elseif aco_op == 13
    [info,solnew]=swapsol_aco(sol,data,info); % 1 
    [info,solnew]=mutate_aco(solnew,data,info);  % 3
elseif aco_op == 23
    [info,solnew]=insert_aco(sol,data,info); % 2
    [info,solnew]=mutate_aco(solnew,data,info);  % 3
elseif aco_op == 123
    [info,solnew]=swapsol_aco(sol,data,info); % 1 
    [info,solnew]=insert_aco(solnew,data,info); % 2
    [info,solnew]=mutate_aco(solnew,data,info);  % 3







end