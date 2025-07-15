function population_entropy = calculate_population_entropy(fit)

% population_entropy - 种群熵



% 计算每个个体的适应度概率
p = fit / sum(fit);

% 计算种群熵
population_entropy = -sum(p .* log(p));


population_entropy = 1 / (1 + exp(-population_entropy));

end