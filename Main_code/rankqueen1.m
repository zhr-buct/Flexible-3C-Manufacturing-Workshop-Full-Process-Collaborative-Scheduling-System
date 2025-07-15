% rankqueen1�����������Ǹ��������Ȩ�غ�������ϵ�������������
% �����ذ�������������������������
% ��������ں����Ĵ����п�������������Ȼ��Ż��㷨�С�
% data.aft��dataheft.aft = dataheft.hx;
% data.w��dataheft.w = dataheft.ct;
% data.c��dataheft.c = dataheft.st;

function  indexS = rankqueen1(data,info) % ����һ��������������������indexS


% ��δ����Ŀ���ǹ���һ�������޻�ͼ��DAG�����ڽӾ����ʾ�����ں������������������
DAG_Matrix = zeros(info.n, info.n);
% ͨ������Ƕ�׵�forѭ������data.aft�����ÿ��Ԫ�ء�
% �ⲿѭ��iRow�����еĵ������ڲ�ѭ��iColumn�����еĵ�����
for iRow = 1:size(data.aft, 1)
    for iColumn = 1:size(data.aft, 2)
        if ~eq(data.aft(iRow, iColumn), 0) % ���data.aft(iRow, iColumn)��������
            DAG_Matrix(iRow, data.aft(iRow, iColumn)) = 100;
        end
    end
end
% �������һ��ֻ��100��0�ľ������磨3��4��λ����100�����ʾ�ڵ�3ָ��ڵ�4



% ���������������rank��
rank=zeros(1,info.n);

for i=info.n:-1:1   % ����ѭ��
    w=0;    % ���� w ���ڼ��㵱ǰ�����Ȩ���ܺ͡�
    for j=1:info.m
        w=w+data.w(i,j);   % �����i��������5�����������еļ���ʱ��֮��
    end

    if i==info.n
        rank(i)=w/info.m;
    else 
        temp=0;
        for k=1:info.n
             if data.c(i,k)~=-1 
                 temp=max(temp,rank(k)+data.c(i,k));% �����i���͵�k������֮�������ʱ�䲻Ϊ-1
                                                    % ����������ʱ��Ļ�������temp�������ʱ��
             end
        end
        rank(i)=w/info.m+temp;
    end
end


[rank, indexS]=sort(rank,'descend');