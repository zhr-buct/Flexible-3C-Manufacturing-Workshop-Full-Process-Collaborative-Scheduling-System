function C = calculate_avg_clustering_coefficient(population)
% 计算种群的聚类系数
% 输入:
%   population: 种群,每一行代表一个个体
%   similarity_func: 计算个体之间相似度的函数句柄,输入为两个个体,输出为相似度值
% 输出:
%   C: 种群的聚类系数

    % 计算种群中个体之间的相似度矩阵
    num_individuals = size(population, 1);
    similarity_matrix = zeros(num_individuals);
    for i = 1:num_individuals
        for j = i+1:num_individuals
            similarity_matrix(i, j) = similarity_func(population(i, :), population(j, :));
            similarity_matrix(j, i) = similarity_matrix(i, j);
        end
    end

    % 计算每个个体的聚类系数
    individual_clustering_coefficients = zeros(1, num_individuals);
    for i = 1:num_individuals
        neighbors = find(similarity_matrix(i, :) > 0);  % 找到与第i个个体相连的个体
        num_neighbors = length(neighbors);
        if num_neighbors < 2
            individual_clustering_coefficients(i) = 0;
        else
            connected_neighbors = similarity_matrix(neighbors, neighbors);  % 相连个体之间的相似度
            num_connected_pairs = sum(sum(triu(connected_neighbors, 1) > 0));  % 计算相连个体对的数量
            individual_clustering_coefficients(i) = num_connected_pairs / (num_neighbors * (num_neighbors - 1) / 2);  % 计算第i个个体的聚类系数
        end
    end

    % 计算种群的聚类系数
    C = mean(individual_clustering_coefficients);
end


function similarity = similarity_func(individual1, individual2)
% 计算两个个体之间的相似度
% 输入:
%   individual1: 第一个个体,为一个向量
%   individual2: 第二个个体,为一个向量
% 输出:
%   similarity: 两个个体之间的相似度,值在[0,1]之间

    % 确保两个个体的长度相同
    len1 = length(individual1);
    len2 = length(individual2);
    if len1 ~= len2
        error('两个个体的长度不同');
    end

    % 计算两个个体的欧几里得距离
    distance = sqrt(sum((individual1 - individual2).^2));

    % 将距离转换为相似度,相似度为1减去归一化的距离
    max_distance = sqrt(len1);
    similarity = 1 - distance / max_distance;
end