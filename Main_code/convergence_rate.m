function E_t = convergence_rate(fitnessPrev, fitnessCurr)
    % fitnessPrev：前一次迭代种群的适应度向量
    % fitnessCurr：当前迭代种群的适应度向量
    
    assert(size(fitnessPrev, 1) == size(fitnessCurr, 1)); % 确保两个向量长度一致
    
    % 计算前后两次适应度值之差的绝对值之和
    diffSum = sum(abs(fitnessCurr - fitnessPrev));
    
    % 计算前后两次适应度值之和
    sumPrev = sum(fitnessPrev);

    % 计算收敛率 E_t
    E_t = diffSum / sumPrev; % 注意：根据文中的公式(18)计算收敛率
    
end