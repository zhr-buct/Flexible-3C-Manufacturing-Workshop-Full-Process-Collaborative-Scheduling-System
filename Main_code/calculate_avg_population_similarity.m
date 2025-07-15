function avg_similarity = calculate_avg_population_similarity(population)


% avg_similarity - 种群平均相似度

num_individuals = size(population, 1); % 种群中个体的数量

% 计算每对个体之间的相似度
similarity_sum = 0;
for i = 1:num_individuals-1
    for j = i+1:num_individuals
        similarity_sum = similarity_sum + calculate_individual_similarity(population(i,:), population(j,:));
    end
end


% 计算平均相似度
avg_similarity = 2 * similarity_sum / (num_individuals * (num_individuals - 1));
end


function similarity = calculate_individual_similarity(individual1, individual2)
% 计算两个个体之间的相似度
% 这里假设个体表示为向量,可以根据实际情况修改相似度计算方法
similarity = 1 - norm(individual1 - individual2) / norm(individual1 + individual2);
end