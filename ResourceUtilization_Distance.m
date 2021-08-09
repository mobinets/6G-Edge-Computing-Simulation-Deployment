% Edge-Go V.S. 对比算法1 Without Tiwce
% 对比指标：Computation Resource Utilization
% 变量：节点稀疏程度

parameter_list = struct('device_count', 10, ...,
'move_speed', 5, ...,
'storage_capacity', 100, ...,
'compute_freq', 8, ...,
'trans', 2.5, ...,
'epsilon', 0.00001, ...,
'iteration', 30, ...,
'distance', [], ...,
'omega', 0.0001); % 接受当前解的概率收敛参数

% 下面是测试代码

% ------------------------------------------------------------------------------------------------------------------------

max_computation = 120;
distance_num = [];
utilization_twice = [];
utilization_once = [];

device_count = parameter_list.device_count;
max_distance = 250;
device_list = struct('num', 0, 'inputsize', 0, 'computation', 0, 'storage', 0, 'prior', -1); % 设备列表
for i = 1:device_count
    pause(0.0001);
    device_list(1, i).num = i; % 设备编号
    device_list(1, i).inputsize = randi(20) + 10; % 输入数据大小
    device_list(1, i).computation = randi(20) + 100; % 计算负载
    device_list(1, i).storage = randi(15) + 5; % 存储大小
end

node_distance = zeros(device_count, device_count); % 节点之间的距�????

for num = 1:5:max_distance
    distance_num(end + 1) = num;
    
    for i = 1:device_count

        for j = 1:device_count
            pause(0.0001);
            d = num;
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
    [ppath, schedule, stay_node_list, completionTime, completionTime_iter, computeDuring] = PSTopLayer(device_list, parameter_list);

    if completionTime == 0
        utilization_twice(end + 1) = 0;
    else
        utilization_twice(end + 1) = computeDuring / completionTime;
    end

    ppath2 = [];
    schedule2 = [];
    stay_node_list2 = [];
    completionTime2 = [];
    [ppath2, schedule2, stay_node_list2, completionTime2, completionTime_iter, computeDuring2] = PSTopLayer_WithoutTwice(device_list, parameter_list);

    if completionTime2 == 0
        utilization_once(end + 1) = 0;
    else
        utilization_once(end + 1) = computeDuring2 / completionTime2;
    end
    
    if completionTime2 < completionTime
        utilization_twice(end) = utilization_once(end);
    end
end

plot(distance_num, utilization_twice, '-d', 'LineWidth', 2);
hold on;
plot(distance_num, utilization_once, '--o', 'LineWidth', 2);
hold on;
legend('Go with twice pass', 'Go without twice pass');
% title('');
xlabel('Average Distance between Devices');
ylabel('Utilization of Computation Resource');
