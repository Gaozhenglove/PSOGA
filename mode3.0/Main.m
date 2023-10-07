clear;
clc;

%% ������ʼ��?
global unitArea optLen num1 num2 num3 num4 num5 changeAreaIdx ...
    nonChangeAreaIdx nonChangeData;

data = xlsread('D:\��̬ϵͳ�����ֵ�Ż�\��������\����3.0\դ������3.xlsx');
landNum = data(:,1);
landType = data(:,2);
landGrad = data(:,3);
exchangeFlag = data(:,4);

% �����ҵ��¶ȳ���25��ĵ�Ԫ�񣬰���ת��Ϊ�ֵأ�����ת��ϵ��ת��Ϊ1
grad25Idx = find(data(:,3) == 2);
data(grad25Idx,2) = 3;
data(grad25Idx,4) = 1;

unitArea = 137900 / length(landType);          % ��Ԫ�����?
changeAreaIdx = find(data(:,4) == 0);           % �ҳ��̶�����Ϊ0�ĵ�Ԫ������
nonChangeAreaIdx = find(data(:,4) == 1);    % �ҳ��̶�����Ϊ1�ĵ�Ԫ������
nonChangeData = data(nonChangeAreaIdx,2);
newData = data(changeAreaIdx,:);

data(changeAreaIdx,:) = [];

num1 = sum(data(:,2) == 1);
num2 = sum(data(:,2) == 2);
num3 = sum(data(:,2) == 3);
num4 = sum(data(:,2) == 4);
num5 = sum(data(:,2) == 5);

tic;
%% ��ʼPSO�㷨
% ���¶����������
optLen = length(newData(:,1));  %  ��Ҫ�Ż��ĵ�Ԫ��������

LB = [851-num1, 174-num2, 135-num3, 138-num4, 43-num5];  % ÿ������������������
UB = [882-num1, 205-num2, 148-num3, 159-num4, 54-num5]; % ÿ������������������
 
pop=100;   % ��Ⱥ����
dim=5;       % ��Ⱥά��

vmax=[1 3 5 7 9];    % �ٶ�����
vmin=-[1 3 5 7 9];   % �ٶ�����
maxIter=200;            % PSO�㷨����������?
fobj=@(X)CalFitness(X);     % ������Ӧ�Ⱥ���?
[Best_Pos,Best_fitness,IterCurve]=PsoFunc(pop,UB,LB,fobj,vmax,vmin,maxIter);  % ����PSO�㷨����

% �����ʾ
figure(1)
plot(IterCurve,'r','linewidth',1.5);
grid on;
xlabel('��������');
ylabel('��Ӧ��ֵ');
title('PSO�㷨�Ż�F1��F3�Ĺ���')

% PSO�㷨��������ʵ����Ԫ������ת��������?
Best_Pos = ceil(Best_Pos);
diffValue = sum(Best_Pos) - optLen;
if diffValue > 0
    Best_Pos(1) = Best_Pos(1) - diffValue;
else
    Best_Pos(5) = Best_Pos(5) - diffValue;
end

BestPos = Best_Pos + [num1,num2,num3,num4,num5];
disp(['���õ���x1��x2��x3��x4��x5��:',num2str(BestPos(1)*unitArea),' ',num2str(BestPos(2)*unitArea)...
    ,' ',num2str(BestPos(3)*unitArea),' ',num2str(BestPos(4)*unitArea),' ',num2str(BestPos(5)*unitArea)]);

disp(['���Ž��Ӧ�ĺ���ֵ:',num2str(fobj(Best_Pos)*unitArea)]);
F1 = 9.89*(BestPos(1)*unitArea) + 2.21*(BestPos(2)*unitArea) + 15.11*(BestPos(3)*unitArea) + 244.83*(BestPos(4)*unitArea) + 496.3*(BestPos(5)*unitArea);
F3 = 0.81*(BestPos(1)*unitArea) + 3.73*(BestPos(2)*unitArea) + 25.76*(BestPos(3)*unitArea) + 0.03*(BestPos(4)*unitArea) + 7.38*(BestPos(5)*unitArea);
fitness = 0.37 * F1 + 0.63 * F3;
disp(['F1=',num2str(F1)])
disp(['F3=',num2str(F3)])
disp(['fitness=',num2str(fitness)])
%% ���������������ĸ������������������пռ��Ż����ռ��Ż��ı�����ʹת��������ͣ���߲����Ŵ��㷨��ʵ�֣�
beta = [0,0.3,0.1,0.1,0.6;
            0.4,0,0.1,0.1,0.7;
            1,1,0,1,1;
            0.7,0.7,0.6,0,0.7;
            1,1,1,0.9,0];           % ������������֮���ת������ϵ��
% ��Ⱥ����
UnitStruct.Code = [];   % ÿ����Ⱥ��������������?
UnitStruct.Cost = [];    % ÿ����Ⱥ����������ת���ɱ�?

% ��Ⱥ����
popSize = 60;
popUnit = repmat(UnitStruct,1,popSize);

for i = 1:popSize
    popUnit(i).Code = initialGA(Best_Pos);
    popUnit(i).Cost = CalF2(popUnit(i),newData(:,2)',beta);
end

% ��ʼ���������
Pc = 0.8;
Pm = 0.1;
maxIter = 1000;

nCrossover=2*round(Pc*popSize/2);  % �����������
nMutation=round(Pm*popSize);         % ͻ���������

trace = [];
for it =1:maxIter
    % ����
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
    
    % ͻ��
    popm=repmat(UnitStruct,1,nMutation);
    for k=1:nMutation
        i=randi([1 popSize]);
        pp=popUnit(i);   
        popm(k).Code=Mutate(pp.Code);
        popm(k).Cost=CalF2(popm(k),newData(:,2)',beta);   
    end
    
    % �ϲ�
    popUnit=[popUnit,popc,popm];

    % ��Ⱥ����
    popUnit=SortPopulation(popUnit);
    
    % ��ȡ(ѡ��)
    popUnit=popUnit(1:popSize);

    % ����
    popUnit=SortPopulation(popUnit);
    trace(end+1) = popUnit(1).Cost;
end

% �����ʾ
figure(2)
plot(trace,'linewidth',1.5);
xlabel('��������');
ylabel('F2ֵ');
title('�Ŵ��㷨�Ż�F2����');
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
xlswrite('��������hahaha.xlsx',writeData);
toc;
 

 

 

 

