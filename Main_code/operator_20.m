function [info,pop,fit]=operator_20(pop,data,info,fit)

% GA：单交叉 + 2突变
[pop_size, ~]=size(pop);
for x = 1 : info.tl
    % 单点交叉
    [info,pop1] = RL_GA_cross_12(pop,info,fit);
    % 突变操作
    [info,popout] = RL_GA_mutation2_11(pop1, info, data);

    fitnew = decode_01(popout,info,data);
    for i = 1 : pop_size
       if fitnew(i) < fit(i)
          pop(i,:)=popout(i,:);
          fit(i)=fitnew(i);
       end
    end
end












