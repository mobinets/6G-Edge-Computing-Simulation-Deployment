function [ ranklist ] = RankInsert( ranklist, node )
%RankInsert 将node rank提高一位，和前一位节点rank互换顺序
%   此处显示详细说明
    node_rank = ranklist(1,node);
    q_index = find(ranklist==(node_rank-1));
    ranklist(1,node) = node_rank-1;
    ranklist(1,q_index) = node_rank;

end

