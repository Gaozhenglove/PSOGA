function [p1, p2]=Crossover(x1,x2,Best_Pos)
%%  ���������������Ľ������
idx = randi([1,length(x1)],1,1);
y1 = [x1(1:idx),x2(idx+1:end)];
y2 = [x2(1:idx),x1(idx+1:end)];    
p1 = numCheck(y1,Best_Pos);  % ����������Ⱦɫ����ĸ���������������?
p2 = numCheck(y2,Best_Pos);  % ����������Ⱦɫ����ĸ���������������?
end