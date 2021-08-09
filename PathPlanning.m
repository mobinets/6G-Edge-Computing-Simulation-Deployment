function [ppath, stay_node_list, completionTime, computeDuring] = PathPlanning(last_completionTime, last_path, schedule, stay_node_list, devicelist, parameterlist)
    %PathPlanning :固定schedule，确定path
    % 改变路径，处理二次经过时必须要在原地计算的节点
    % 利用2-OPT优化path (要考虑存储空间限制)

    temp_path = last_path;
    temp_completionTime = last_completionTime;
    temp_stay_node_list = stay_node_list;
    temp_computeTime = 0;
    min_completionTime = temp_completionTime;
    min_path = temp_path;
    min_stay_node_list = stay_node_list;
   
    % 在当前schedule下，使用2-opt找到path使完成时间减小
    % 限制: 存储空间
    opt = randperm(length(last_path), 2);
    opt_i = opt(1);
    opt_j = opt(2);

    computeDuring = 0;    
    
    for iter = 1:parameterlist.iteration
        % 2-opt: 翻转i-j的元素
        opt_n = max(opt_i, opt_j) - min(opt_i, opt_j) + 1;
        k = 1;
        left = min(opt_i, opt_j);
        right = max(opt_i, opt_j);

        while k < floor(opt_n / 2)

            temp = temp_path(1, left);
            temp_path(1, left) = temp_path(1, right);
            temp_path(1, right) = temp;

            left = left + 1;
            right = right - 1;
            k = k + 1;
        end

        flag_storage = true;
        % 判断新生成的path是否满足storage限制条件
        taskqueen = [];
        
        
        for i = 1:length(temp_path)

            if isempty(find(temp_path(i) == temp_path, 1))
                % 入队
                taskqueen(end + 1) = temp_path(i);
                % 当前队列是否满足storage限制
                cur_storage = 0;

                for j = 1:length(taskqueen)
                    cur_storage = cur_storage + devicelist(1, taskqueen(j)).storage;
                end

                if cur_storage > parameterlist.storage_capacity
                    flag_storage = false;
                    break;
                end

            else
                % 出队
                taskqueen(find(taskqueen == temp_path(i), 1)) = [];
            end

        end % 迭代结束

        if flag_storage
            % 满足存储限制条件
            [temp_ddllist, temp_stoplist] = ComputeDDL(temp_path, devicelist, parameterlist);
            [temp_completionTime, ~, temp_stay_node_list,temp_computeTime] = ComputeNodeCompleteTime ...,
            (temp_ddllist, temp_stoplist, temp_path, schedule, 1, devicelist, parameterlist);

            if (temp_completionTime < min_completionTime) && ...,
                abs(temp_completionTime - min_completionTime) > parameterlist.epsilon
                min_completionTime = temp_completionTime;
                min_path = temp_path;
                min_stay_node_list = temp_stay_node_list;
                computeDuring = temp_computeTime;
            end

        end

    end

    ppath = min_path;
    stay_node_list = min_stay_node_list;
    completionTime = min_completionTime;
    computeDuring = temp_computeTime;
end
