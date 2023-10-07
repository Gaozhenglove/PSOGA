function p = Mutate(x)
% 对输入染色体进行突变操作
while 1
    idx = randi([1,length(x)-20],1,2);
    idx = sort(idx);
    idx1 = idx(1);idx2 = idx(2);
    if idx1 - idx2 ~= 0
        break;
    end
end
temp = x;
temp(idx1:idx1+20) = x(idx2:idx2+20);
temp(idx2:idx2+20) = x(idx1:idx1+20);
p = temp;
end

