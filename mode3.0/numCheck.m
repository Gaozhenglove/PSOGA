function p = numCheck(y,BestPos)
% ���Ⱦɫ���Ƿ�����ÿ������������������

idx1 = find(y == 1);
idx2 = find(y == 2);
idx3 = find(y == 3);
idx4 = find(y == 4);
idx5 = find(y == 5);

idx = {idx1,idx2,idx3,idx4,idx5};
% �����ҵ�ÿ���������͵�����?
n1 = length(idx1); n2 = length(idx2); n3 = length(idx3); n4 = length(idx4); n5 = length(idx5);
tempNum = [n1,n2,n3,n4,n5];
diffNum = tempNum - BestPos;

%% ��������Ⱦɫ����ĸ���������������������Լ�����������¾���
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

