function flag=BoundaryCheck(X,ub,lb)
% ���PSO�㷨�����Ⱥ�Ƿ�Խ�磬���Խ�磬������Ⱥ��λ��?
    temp = sum(X > ub | X < lb);
    if temp
        flag = 1;
    else
        flag = 0;
    end
end


