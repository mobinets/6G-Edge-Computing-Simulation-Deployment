function [total_finishtime, node_finishtime, stay_node_list,computeDuring] = ComputeNodeCompleteTime(ddllist, stoplist, ppath, ranklist, node, devicelist, parameterlist)
    %ComputeNodeCompleteTime 计算节点node的完成时间,总完成时间
    %   此处显示详细说明
    
    computeDuring = 0;    

    % 模拟一遍从起始点到node完成的过程，获得node完成时间段长度
    time = 0;
    tasks = []; % 服务器队列里的任务
    % (1,x)device index; (2,x)device rank; (3,x) compute time; (4,x)is finished(1 finished, 0 otherwise)
    stay_node_list = []; % (1,x)逗留计算的节点序号；(2,x)在该点的逗留时间

    endp = find(ppath == node);
    nodep = endp(end); % ppath中第2次出现该节点的index

    p = 1;

    while p < 2 * length(devicelist)

        if p == nodep
            node_finishtime = time;
        end

        staytime = stoplist(1, p);
        movetime = parameterlist.distance(ppath(1, p), ppath(1, p + 1)) / parameterlist.move_speed;

        if ddllist(1, ppath(1,p)) ~= -1
            computetime = staytime + movetime;
        else
            computetime = movetime;
        end
        
        surplustime = 0; % 原地逗留等待计算完成的时间

        if ~isempty(tasks)
            ret = find(tasks(1, :) == ppath(1, p)); % 当前节点是否已经在服务器队列
        else
            ret = [];
        end
        
        if isempty(ret)
            % 第一次到该点，入队
            tasks(1, end + 1) = ppath(1, p);
            tasks(2, end + 1) = ranklist(1, ppath(1, p));
            tasks(3, end + 1) = devicelist(1, ppath(1, p)).computation / parameterlist.compute_freq;
            tasks(4, end + 1) = 0;

            % 按照rank从小到大对tasks矩阵排序
            temp_tasks = tasks';
            temp_tasks = sortrows(temp_tasks, 2);
            tasks = temp_tasks';
        else
            % 按照rank从小到大对tasks矩阵排序
            temp_tasks = tasks';
            temp_tasks = sortrows(temp_tasks, 2);
            tasks = temp_tasks';

            [~, col] = size(tasks);
            % 移动和数据上传的过程中，并行计算服务器内的任务
            for i = 1:col

                if computetime >= tasks(3, i)
                    computetime = computetime - tasks(3, i);
                    tasks(4, i) = 1;
                    computeDuring = computeDuring + tasks(3,i);
                else
                    computeDuring = computeDuring + computetime;
                    tasks(3, i) = tasks(3, i) - computetime;                    
                    computetime = 0;
                    break;
                end

            end

            % 第二次到该点，出队
            if tasks(4, ret) == 1
                % 计算完毕，直接出队
                tasks(:, ret) = [];
            else
                % 尚未计算完毕，需要在原地逗留计算,然后再出队列

                % 原地逗留，先将队列中优先级比该点高的节点计算完，然后计算该节点
                for i = 1:ret

                    if tasks(4, i) == 0
                        % 还未计算完
                        surplustime = surplustime + tasks(3, i);
                        computeDuring = computeDuring + tasks(3,i);
                        tasks(3, i) = 0;
                        tasks(4, i) = 1;
                    end

                end

                tasks(:, ret) = [];
                stay_node_list(1, end + 1) = ppath(1, p);
                stay_node_list(2, end) = surplustime;
            end

        end

        time = time + staytime + movetime + surplustime;
        p = p + 1;
    end % for p

    total_finishtime = time;
    if nodep == 2*length(devicelist)
        node_finishtime = time;
    end
end
 