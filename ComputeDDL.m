function [ ddl_list, stop_list ] = ComputeDDL( ppath, device_list, parameter_list )
%ComputeDDL 根据路径计算二次到达每个节点时的DDL(开始接到任务-返回任务)
%   此处显示详细说明
    ddl_list = zeros(1,length(device_list));  
    stop_list = zeros(1,2*length(device_list));

    i = 1;
    while i < 2*length(device_list)
    % 计算直接停留本地的节点计算时间
        if ppath(1,i) == ppath(1,i+1)
           % 不二次卸载，直接停留原地计算。ddl=-1
            ddl_list(1,i) = -1; % 本地计算 -1
            stop_list(1,i) = device_list(1,ppath(1,i)).inputsize/parameter_list.trans;   % 上传时间
            stop_list(1,i+1) = device_list(1,ppath(1,i)).inputsize/parameter_list.compute_freq;   % 本地计算时间
        else
            % 二次卸载，ddl后续计算。更新上传时间。下载时间默认为0。            
            j = 1;
            isfirst = true;
            while j < i
                if ppath(1,j) == ppath(1,i)
                    isfirst = false;
                    break;
                end
                j = j + 1;
            end
            if isfirst
                stop_list(1,i) = device_list(1,ppath(1,i)).inputsize/parameter_list.trans; 
            end
        end
        i = i + 1;
    end

    for i = 1 : length(device_list)
    % 计算二次卸载的节点DDL
        if ddl_list(1,i) == -1
            continue;
        end
        index = find( ppath == i , 2);
        pfirst = index(1);
        psecond = index(2);
        
         
        % ddl_list(1,i) = 移动时间 + 中间节点逗留时间
        total_distance = 0;
        total_stoptime = 0;
        for j = pfirst : (psecond-1)
            total_distance = total_distance + parameter_list.distance(ppath(1,j),ppath(1,j+1));
            total_stoptime = total_stoptime + stop_list(1, j+1);            
        end
        ddl_list(1,i) = total_stoptime + total_distance/parameter_list.move_speed;
    end

end

