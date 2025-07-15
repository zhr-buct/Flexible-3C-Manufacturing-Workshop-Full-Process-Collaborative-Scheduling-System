clear
clc

load P_data_LEA.mat

P = zeros(5, 32);
for Algorithm = 3 : 3
    Algorithm_all = {'ILS', 'IILS', 'GA', 'LGWO', 'SACS'};
    Algorithm_name = Algorithm_all(Algorithm);
    Algorithm_name = cell2mat(Algorithm_name);
    
    temp1 = ['load ','P_data_',Algorithm_name,'.mat'];
    eval (temp1)


    for Algorithm_mode = 1 : 2
        for scale_num = 1 : 16
            if Algorithm_mode == 1
                Problem_scale = ['FFT', num2str(scale_num)];
                Algorithm_fit = GA_data(scale_num,:);
                LEA_fit = LEA_data(scale_num,:);
            else
                Problem_scale = ['GS', num2str(scale_num)];
                Algorithm_fit = GA_data(16 + scale_num,:);
                LEA_fit = LEA_data(16 + scale_num,:);
            end
            
            p = signrank(Algorithm_fit,LEA_fit);
            temp = ['P_Values_', Algorithm_name, '_', Problem_scale];

            % 指定要保存的文件夹路径
            folder_path = 'D:\matlab文件夹\LEEA2.0\DRL\P_Save\';
            % 创建完整的文件路径
            file_path = fullfile(folder_path, temp);
            save(file_path, 'Algorithm_name', 'Problem_scale' ,'p', 'Algorithm_fit', 'LEA_fit');
            if Algorithm_mode == 1
                P(Algorithm, scale_num) = p;
            else
                P(Algorithm, 16 + scale_num) = p;
            end
        end
    end
end