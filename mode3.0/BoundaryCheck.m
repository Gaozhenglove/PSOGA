function flag=BoundaryCheck(X,ub,lb)
% 检查PSO算法里的种群是否越界，如果越界，纠正种群的位置?
    temp = sum(X > ub | X < lb);
    if temp
        flag = 1;
    else
        flag = 0;
    end
end


