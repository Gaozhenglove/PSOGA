function flag = ConstraintCheck(mat)
% ����������������Ƿ�����ռ�Լ������?
[M,N] = size(mat);
flag = 1;
for i = 2:M-1
    for j = 2:N-1
        if SearchClass(mat,[i,j])
            flag = 0;
            break;
        end
    end
end
end

