function [ppath, stay_node_list, completionTime,computeDuring] = PathPlanning_WithoutTwice(last_completionTime, last_path, schedule, stay_node_list, devicelist, parameterlist)
    %PathPlanningWithoutTwice - 对比算法1：无二次卸载策略，只能等待本地任务计算完毕再移动到一个节�?
    %
    % Syntax: [ppath, stay_node_list, completionTime] = PathPlanningWithoutTwice(input)
    %

    % 原地卸载的策略不会同时装载多个任务，故不用�?�虑存储大小限制
    temp_path = last_path;
    temp_completionTime = last_completionTime;
    temp_stay_node_list = stay_node_list;
    temp_computeDuring = 0;
    min_completionTime = temp_completionTime;
    min_path = temp_path;
    min_stay_node_list = stay_node_list;
    
    % 2-opt找到path使�?�体完成时间�?�?
    % 注意，无二次卸载，故都是1,1; 3,3这种成对出现的形�?
    opt = randperm(length(devicelist), 2);
    opt_i = opt(1);
    opt_j = opt(2);
    temp_list = [];
    for i = 1 : length(devicelist)
        temp_list(end+1) = temp_path(1,2*i);
    end

    for iter = 1:parameterlist.iteration
        opt_n = max(opt_i, opt_j) - min(opt_i, opt_j) + 1;
        k = 1;
        left = min(opt_i, opt_j);
        right = max(opt_j, opt_i);

        while k < floor(opt_n / 2)

            temp = temp_list(1, left);
            temp_list(1,left) = temp_list(1,right);
            temp_list(1,right) = temp;

            left = left + 1;
            right = right - 1;
            k = k + 1;
        end

        i = 1; j = 1;
        while i <= length(temp_list)
            temp_path(1,j) = temp_list(1,i);
            temp_path(1,j+1) = temp_list(1,i);
            j = j + 2;
            i = i + 1;
        end

        % [temp_ddllist, temp_stoplist] = ComputeDDL(temp_path, devicelist, parameterlist);
        % [temp_completionTime, ~, temp_stay_node_list] = ComputeNodeCompleteTime ...,
        % (temp_ddllist, temp_stoplist, temp_path, schedule, 1, devicelist, parameterlist);

        temp_completionTime = 0;
        temp_computeDuring = 0;
        for p = 1 : length(temp_path)
            if mod(p,2) == 0
                % 计算 + 移动
                computetime = devicelist(temp_path(1,p)).computation / parameterlist.compute_freq; 
                
                if p ~= length(temp_path)
                    movetime = parameterlist.distance(temp_path(1,p),temp_path(1,p+1)) / parameterlist.move_speed;
                else
                    movetime = 0;
                end
                temp_completionTime = temp_completionTime + computetime + movetime;
                temp_computeDuring = temp_computeDuring + computetime;
            else
                % 上传
                uptime = devicelist(temp_path(1,p)).inputsize / parameterlist.trans;
                temp_completionTime = temp_completionTime + uptime;
            end
        end 
        
        if (temp_completionTime < min_completionTime) && ...,
            abs(temp_completionTime - min_completionTime) > parameterlist.epsilon
            min_completionTime = temp_completionTime;
            min_path = temp_path;
            min_stay_node_list = temp_stay_node_list;
            computeDuring = temp_computeDuring;
        end

    end

    ppath = min_path;
    stay_node_list = min_stay_node_list;
    completionTime = min_completionTime;
    computeDuring = temp_computeDuring;
end
