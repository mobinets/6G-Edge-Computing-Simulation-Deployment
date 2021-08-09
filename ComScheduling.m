function [schedule, stay_node_list, completionTime] = ComScheduling(last_time, last_schedule, ppath, device_list, parameter_list)
    %ComScheduling :固定ppath，决策computation scheduling
    %   last_total_time 上次策略的完成时间

    % 根据路径计算二次到达每个节点时的DDL(开始接到任务-第二次返回节点)。路径规划非二次卸载的ddl记为-1
    [ddl_list, temp_stop] = ComputeDDL(ppath, device_list, parameter_list);

    schedule = last_schedule;
    % 遍历每个设备，对每个无法在DDL前完成的节点调高rank
    for i = 1:length(device_list)

        if ddl_list(1, i) == -1
            % 非二次卸载，节点rank不变
            continue;
        end

        [total_comptime, node_comptime, stay_node_list] = ComputeNodeCompleteTime(ddl_list,temp_stop, ppath, schedule, i, device_list, parameter_list);
        % 根据当前优先级及路径，预测完成该节点需要的时间,整体完成时间
        while node_comptime > ddl_list(1, i) && schedule(1, i) > 1
            % 当前优先级会超出ddl，提高任务优先级
            [schedule] = RankInsert(schedule, i);
            % 将该节点的优先级提高一位，后续节点优先级递减
            [total_comptime, node_comptime, stay_node_list] = ComputeNodeCompleteTime(ddl_list, temp_stop, ppath, schedule, i, device_list, parameter_list);
        end

        
    end

    completionTime = total_comptime;
    % 如果比原先的策略整体完成时间还长，则random调度结果
    if last_time < total_comptime
        % 本地调度整体结果不如原结果，随机生成Schedule (1,n)不重复的随机数
%         schedule = randperm(length(device_list), length(device_list));
        schedule = last_schedule;
        completionTime = last_time;
%         [total_comptime, node_comptime, stay_node_list] = ComputeNodeCompleteTime(ddl_list, temp_stop, ppath, schedule, i, device_list, parameter_list);
    else
        % 算法结束
        completionTime = total_comptime;        
    end

end
