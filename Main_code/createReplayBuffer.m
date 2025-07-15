function replay_buffer = createReplayBuffer(buffer_size)
    % 创建经验回放缓冲区的数据结构
    replay_buffer.Data = zeros(buffer_size, 5); % 经验数据矩阵
    replay_buffer.Index = 1; % 当前存储索引
    replay_buffer.Size = buffer_size; % 缓冲区大小
    replay_buffer.Count = 0; % 当前存储的经验数量
end