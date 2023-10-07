function [X]=initialization(pop,ub,lb)
% ��ʼ��PSO�㷨�������Ⱥ
global optLen;
for i=1:pop
    flag = 1;
    while flag
        for j =1:length(ub)
            X(i,j) = rand() * (ub(j)-lb(j)) + lb(j);
        end
        X(i,:) = ceil(optLen / sum(X(i,:)) * X(i,:));
        X(i,end) = optLen - sum(X(i,1:end-1));
        flag = BoundaryCheck(X(i,:),ub,lb);
    end
end
end