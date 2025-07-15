function [standardDeviation, mean_fit,fit] = calculate_std(pop,info,data)



fit = decode_01(pop,info,data);



stdfit = std(fit);


% fft_gs = info.mode;
% num = info.num;


% max_std = 0;
% min_std = 1000;
% if stdfit < max_std
%     standardDeviation = 0;
% elseif stdfit >= min_std
%     standardDeviation = 1;
% else
%     standardDeviation = ( stdfit - min_std ) / ( max_std - min_std );
% end

standardDeviation = stdfit;

mean_fit = mean(fit);





