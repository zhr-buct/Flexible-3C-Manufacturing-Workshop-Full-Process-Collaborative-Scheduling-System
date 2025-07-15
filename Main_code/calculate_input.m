function [inputFeatures, fit] = calculate_input(pop,info,data,fit,fitold)


pop_size = size(pop,1);

if info.mode == 1
    min_fit = [181.51 195.26 220.51 269.26 300 325.92 372.45 402.79 767.32 746.49 2000 2500 2500 2000 2500 2500];
elseif info.mode == 2
    min_fit = [198.48 142.96 343.69 266.47 382.24 274.59 791.44 686.03 919.15 743.23 2000 2000 2500 2500 5000 4000];
end


% 状态1：种群的标准差
standardDeviation = std(fit) / 1000;
% standardDeviation = 1 / exp(-standardDeviation);


% 状态2：种群的平均适应度
mean_fit = min_fit(info.num) / mean(fit);




% 状态3：种群适应度最小值
min_fit = min_fit(info.num) / min(fit);




% 状态4： 算法进化速率
sum_ev = 0;
for i = 1 : pop_size
    sum_ev = sum_ev + ( fitold(i) - fit(i) );
end
E_V = sqrt( info.np * ( min(fitold) - min(fit) ) ) / ( sum_ev + 1 )  ;



inputFeatures = [standardDeviation, mean_fit, min_fit , E_V ];












% 状态3：种群的熵
% population_entropy = calculate_population_entropy(fit);
% 状态4：种群的平均相似度
% avg_similarity = calculate_avg_population_similarity(pop);
% 状态6：种群的聚类系数
% avg_clustering_coefficient = calculate_avg_clustering_coefficient(pop);
end