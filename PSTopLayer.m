function [ppath, schedule, stay_node_list, completionTime, completionTime_iter,computeDuring] = PSTopLayer(device_list, parameter_list)
    %PSTopLayer :path planning and computation scheduling--Top Layer
    %   此处显示详细说明

    device_count = length(device_list);
    schedule = [];
    ppath = [];
    % 初始化: path, schedule
    % 随机生成path，第一次出现节点a表示在该点获取任务，第二次出现节点a表示在该点卸载任务的计算结果
    % 初始化设置path为每个节点都在本地逗留计算(1,1,2,2,...,n,n)
    for i = 1:device_count
        ppath(end + 1) = i;
        ppath(end + 1) = i;
    end

    for i = 1:device_count
        schedule(end + 1) = i; % (i,j) node i's rank is j
    end

    stopDevice_list = []; % 必须停留计算（超出DDL）的设备序号
    completionTime = Inf;
    computeDuring = 0;
    stay_node_list = []; % (1,x)逗留计算的节点序号；(2,x)在该点的逗留时间
    last_ppath = ppath;
    last_schedule = schedule;
    last_stay_node_list = stay_node_list;
    last_completionTime = completionTime;
    last_computeDuring = 0;
    
    completionTime_iter = [];

    for iter = 1:parameter_list.iteration
        % 固定path，确定schedule
        [schedule, stay_node_list, completionTime] = ComScheduling(last_completionTime, last_schedule, last_ppath, device_list, parameter_list);
        % 固定schedule，确定path
        [ppath, stay_node_list, completionTime,computeDuring] = PathPlanning(last_completionTime, last_ppath, schedule, stay_node_list, device_list, parameter_list);

        %         last_ppath = ppath;
        %         last_schedule = schedule;
        %         last_stay_node_list = stay_node_list;
        %         last_completionTime = completionTime;

        %         completionTime_iter(end+1) = completionTime;

        prob = 1 / (1 + exp((completionTime - last_completionTime) / parameter_list.omega));
        dice = rand(1);

        if dice <= prob
            last_ppath = ppath;
            last_schedule = schedule;
            last_stay_node_list = stay_node_list;
            last_completionTime = completionTime;
            last_computeDuring = computeDuring;
            completionTime_iter(end + 1) = completionTime;
            
        else
            completionTime_iter(end + 1) = last_completionTime;
%             computeDuring = last_computeDuring;
        end

        ppath = last_ppath;
        schedule = last_schedule;
        stay_node_list = last_stay_node_list;
        completionTime = last_completionTime;
        computeDuring = last_computeDuring;
    end
