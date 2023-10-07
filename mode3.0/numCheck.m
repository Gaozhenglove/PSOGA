function p = numCheck(y,BestPos)
% 检查染色体是否满足每个土地类型数量条件

idx1 = find(y == 1);
idx2 = find(y == 2);
idx3 = find(y == 3);
idx4 = find(y == 4);
idx5 = find(y == 5);

idx = {idx1,idx2,idx3,idx4,idx5};
% 首先找到每个土地类型的数量?
n1 = length(idx1); n2 = length(idx2); n3 = length(idx3); n4 = length(idx4); n5 = length(idx5);
tempNum = [n1,n2,n3,n4,n5];
diffNum = tempNum - BestPos;

%% 如果输入的染色体里的各类土地类型数量不满足约束条件，重新纠正
p = y;
for i = 1:5
    if diffNum(i) > 0
        p(idx{i}(BestPos(i)+1:end)) = 0;
    end
end

for i = 1:5
    if diffNum(i) < 0
        idxZero = find(p == 0);
        p(idxZero(1:abs(diffNum(i)))) = i;
    end
end

