function [p1, p2]=Crossover(x1,x2,Best_Pos)
%%  这里进行两个编码的交叉操作
idx = randi([1,length(x1)],1,1);
y1 = [x1(1:idx),x2(idx+1:end)];
y2 = [x2(1:idx),x1(idx+1:end)];    
p1 = numCheck(y1,Best_Pos);  % 纠正交叉后的染色体里的各类土地类型数量?
p2 = numCheck(y2,Best_Pos);  % 纠正交叉后的染色体里的各类土地类型数量?
end