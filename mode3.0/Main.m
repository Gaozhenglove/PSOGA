clear;
clc;

%% 参数初始化?
global unitArea optLen num1 num2 num3 num4 num5 changeAreaIdx ...
    nonChangeAreaIdx nonChangeData;

data = xlsread('D:\生态系统服务价值优化\计算数据\代码3.0\栅格数据3.xlsx');
landNum = data(:,1);
landType = data(:,2);
landGrad = data(:,3);
exchangeFlag = data(:,4);

% 首先找到坡度超过25°的单元格，把它转换为林地，它的转换系数转换为1
grad25Idx = find(data(:,3) == 2);
data(grad25Idx,2) = 3;
data(grad25Idx,4) = 1;

unitArea = 137900 / length(landType);          % 单元格面积?
changeAreaIdx = find(data(:,4) == 0);           % 找出固定参数为0的单元格索引
nonChangeAreaIdx = find(data(:,4) == 1);    % 找出固定参数为1的单元格索引
nonChangeData = data(nonChangeAreaIdx,2);
newData = data(changeAreaIdx,:);

data(changeAreaIdx,:) = [];

num1 = sum(data(:,2) == 1);
num2 = sum(data(:,2) == 2);
num3 = sum(data(:,2) == 3);
num4 = sum(data(:,2) == 4);
num5 = sum(data(:,2) == 5);

tic;
%% 开始PSO算法
% 重新定义参数变量
optLen = length(newData(:,1));  %  需要优化的单元格总数量

LB = [851-num1, 174-num2, 135-num3, 138-num4, 43-num5];  % 每个土地类型数量下限
UB = [882-num1, 205-num2, 148-num3, 159-num4, 54-num5]; % 每个土地类型数量下限
 
pop=100;   % 种群数量
dim=5;       % 种群维度

vmax=[1 3 5 7 9];    % 速度上限
vmin=-[1 3 5 7 9];   % 速度下限
maxIter=200;            % PSO算法最大迭代次数?
fobj=@(X)CalFitness(X);     % 计算适应度函数?
[Best_Pos,Best_fitness,IterCurve]=PsoFunc(pop,UB,LB,fobj,vmax,vmin,maxIter);  % 基本PSO算法函数

% 结果显示
figure(1)
plot(IterCurve,'r','linewidth',1.5);
grid on;
xlabel('迭代次数');
ylabel('适应度值');
title('PSO算法优化F1和F3的过程')

% PSO算法求解出来的实数单元格数量转换成整数?
Best_Pos = ceil(Best_Pos);
diffValue = sum(Best_Pos) - optLen;
if diffValue > 0
    Best_Pos(1) = Best_Pos(1) - diffValue;
else
    Best_Pos(5) = Best_Pos(5) - diffValue;
end

BestPos = Best_Pos + [num1,num2,num3,num4,num5];
disp(['求解得到的x1，x2，x3，x4，x5是:',num2str(BestPos(1)*unitArea),' ',num2str(BestPos(2)*unitArea)...
    ,' ',num2str(BestPos(3)*unitArea),' ',num2str(BestPos(4)*unitArea),' ',num2str(BestPos(5)*unitArea)]);

disp(['最优解对应的函数值:',num2str(fobj(Best_Pos)*unitArea)]);
F1 = 9.89*(BestPos(1)*unitArea) + 2.21*(BestPos(2)*unitArea) + 15.11*(BestPos(3)*unitArea) + 244.83*(BestPos(4)*unitArea) + 496.3*(BestPos(5)*unitArea);
F3 = 0.81*(BestPos(1)*unitArea) + 3.73*(BestPos(2)*unitArea) + 25.76*(BestPos(3)*unitArea) + 0.03*(BestPos(4)*unitArea) + 7.38*(BestPos(5)*unitArea);
fitness = 0.37 * F1 + 0.63 * F3;
disp(['F1=',num2str(F1)])
disp(['F3=',num2str(F3)])
disp(['fitness=',num2str(fitness)])
%% 根据上述求解出来的各类土地类型数量进行空间优化（空间优化的本质是使转换费用最低，这边采用遗传算法来实现）
beta = [0,0.3,0.1,0.1,0.6;
            0.4,0,0.1,0.1,0.7;
            1,1,0,1,1;
            0.7,0.7,0.6,0,0.7;
            1,1,1,0.9,0];           % 各类土地类型之间的转换费用系数
% 种群定义
UnitStruct.Code = [];   % 每个种群的土地类型数据?
UnitStruct.Cost = [];    % 每个种群的土地类型转换成本?

% 种群数量
popSize = 60;
popUnit = repmat(UnitStruct,1,popSize);

for i = 1:popSize
    popUnit(i).Code = initialGA(Best_Pos);
    popUnit(i).Cost = CalF2(popUnit(i),newData(:,2)',beta);
end

% 初始化交叉概率
Pc = 0.8;
Pm = 0.1;
maxIter = 1000;

nCrossover=2*round(Pc*popSize/2);  % 交叉次数设置
nMutation=round(Pm*popSize);         % 突变次数设置

trace = [];
for it =1:maxIter
    % 交叉
    popc=repmat(UnitStruct,nCrossover/2,2);
    for k=1:nCrossover/2
        i1=randi([1 popSize]);
        p1=popUnit(i1);    
        i2=randi([1 popSize]);
        p2=popUnit(i2);     
        [popc(k,1).Code, popc(k,2).Code]=Crossover(p1.Code,p2.Code,Best_Pos);
        popc(k,1).Cost=CalF2(popc(k,1),newData(:,2)',beta);
        popc(k,2).Cost=CalF2(popc(k,2),newData(:,2)',beta);      
    end
    popc=popc(:)';
    
    % 突变
    popm=repmat(UnitStruct,1,nMutation);
    for k=1:nMutation
        i=randi([1 popSize]);
        pp=popUnit(i);   
        popm(k).Code=Mutate(pp.Code);
        popm(k).Cost=CalF2(popm(k),newData(:,2)',beta);   
    end
    
    % 合并
    popUnit=[popUnit,popc,popm];

    % 种群排序
    popUnit=SortPopulation(popUnit);
    
    % 截取(选择)
    popUnit=popUnit(1:popSize);

    % 排序
    popUnit=SortPopulation(popUnit);
    trace(end+1) = popUnit(1).Cost;
end

% 结果显示
figure(2)
plot(trace,'linewidth',1.5);
xlabel('迭代次数');
ylabel('F2值');
title('遗传算法优化F2过程');
grid on;
disp(['F2=',num2str(trace(end))])

BestPop = zeros(1,optLen + sum([num1,num2,num3,num4,num5]));
BestPop(nonChangeAreaIdx) = nonChangeData; 
BestPop(changeAreaIdx) = popUnit(1).Code;
BestPop1 = reshape(BestPop,29,47);

figure(3)
color = ['r','g','b','y','k'];
for i = 1:29
    for j = 1:47
        col = BestPop1(i,j);
        scatter(i,j,color(col),'filled','s');
        hold on;
    end
end

writeData = [landNum,BestPop',landGrad,exchangeFlag];
xlswrite('最优数据hahaha.xlsx',writeData);
toc;
 

 

 

 

