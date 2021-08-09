% Edge-Go V.S. 对比算法1 Without Tiwce
% 对比指标：Computation Resource Utilization
% 变量：iot devices count （network scale�??




% ！！！！！！！！！！！！�?1多迭代几次算法，让曲线平滑些！！！！！！！！！！！！�?

parameter_list = struct('device_count', 10, ...,
'move_speed', 5, ...,
'storage_capacity', 100, ...,
'compute_freq', 8, ...,
'trans', 2.5, ...,
'epsilon', 0.00001, ..., 
'iteration', 100, ...,
'distance', [], ...,
'omega', 0.0001); % 接受当前解的概率收敛参数

% 下面是测试代�??

% ------------------------------------------------------------------------------------------------------------------------
max_device_count = 50;
device_num = [];
time_twice = [];
utilization_twice = [];
utilization_once = [];

for num = 2 : 2 : max_device_count
    device_num(end+1) = num;
    parameter_list.device_count = num;

    device_count = parameter_list.device_count;

    device_list = struct('num', 0, 'inputsize', 0, 'computation', 0, 'storage', 0, 'prior', -1); % 设备列表

    for i = 1:device_count
        pause(0.0001);
        device_list(1, i).num = i; % 设备编号
        device_list(1, i).inputsize = randi(20) + 10; % 输入数据大小
        device_list(1, i).computation = randi(30) + 100; % 计算负载
        device_list(1, i).storage = randi(15) + 5; % 存储大小
    end

    max_distance = 40;
    min_distance = 20;
    node_distance = zeros(device_count, device_count); % 节点之间的距�??

    for i = 1:device_count

        for j = 1:device_count
            pause(0.0001);
             d = randi(max_distance - min_distance) + min_distance;
            node_distance(i, j) = d;
            node_distance(j, i) = d;
            node_distance(i, i) = 0;
        end

    end
    parameter_list.distance = node_distance;



    ppath = [];
    schedule = [];
    stay_node_list = [];
    completionTime = [];
    [ppath, schedule, stay_node_list, completionTime, ~,computeDuring] = PSTopLayer(device_list, parameter_list);
    if completionTime == 0
        utilization_twice(end+1) = 0;
%         twice = twice + 0;
    else
        utilization_twice(end+1) = device_count/completionTime;
%         twice = twice + device_count/completionTime;
    end
    
    ppath2 = [];
    schedule2 = [];
    stay_node_list2 = [];
    completionTime2 = [];
    [ppath2, schedule2, stay_node_list2, completionTime2, ~,computeDuring2] = PSTopLayer_WithoutTwice(device_list, parameter_list);
    if completionTime2 == 0
        utilization_once(end+1) = 0;
%         once = once;
    else
        utilization_once(end+1) = device_count/completionTime2;
%         once = once + device_count/completionTime2;
    end
    
    if completionTime > completionTime2
        utilization_twice(end) = utilization_once(end);
%         twice = once;
    end
    
end

plot(device_num(1,5:end), utilization_twice(1,5:end), '-d','LineWidth', 2);
hold on;
plot(device_num(1, 5:end), utilization_once(1,5:end),'--o', 'LineWidth', 2);
hold on;
legend('Go with twice pass', 'Go without twice pass');
% title('');
xlabel('Number of IoT Device');
ylabel('Utility of Computation Resource');
