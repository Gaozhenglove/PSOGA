function F2 = CalF2(pop,oldType,beta)
% 计算种群的类型转换费用
newType = pop.Code;
% oldType = reshape(oldType,29,47);

F2 = 0;
for i = 1:length(newType)
    F2 = F2 + beta(newType(i),oldType(i));
end

end

