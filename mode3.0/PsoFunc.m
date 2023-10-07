function [Best_Pos,Best_fitness,IterCurve]=PsoFunc(pop,ub,lb,fobj,vmax,vmin,maxIter)
% ���л�����pso�㷨

% ѧϰ��
c1=2.0;
c2=2.0;

% ��Ⱥ��ʼ��
X=initialization(pop,ub,lb);
fitness=zeros(1,pop); % ��Ӧ��ֵ??
for i=1:pop
    fitness(i)=fobj(X(i,:));
end
pBest=X;  % �������Ž�
pBestFitness=fitness;   
[~,index]=max(fitness);
gBestFitness=fitness(index); % ȫ�����Ž�
gBest=X(index,:);
Xnew=X;
fitnessNew=fitness;

% PSO�㷨����ѭ��
for t=1:maxIter
    for i=1:pop
        flag = 1;
        while flag
            r1 = rand(1,5) .* (vmax - vmin) + vmin;
            r2 = rand(1,5) .* (vmax - vmin) + vmin;
            V(i,:)=c1.*r1.*(pBest(i,:)-X(i,:))+c2.*r2.*(gBest-X(i,:));
            V(i,:) = V(i,:) - sum(V(i,:)) / 5;
            Xnew(i,:)=X(i,:)+V(i,:);
            flag = BoundaryCheck(Xnew(i,:),ub,lb);
        end
        fitnessNew(i)=fobj(Xnew(1,:));
        if fitnessNew(i)>pBestFitness(i)
            pBest(i,:)=Xnew(i,:);
            pBestFitness(i)=fitnessNew(i);
        end
        if fitnessNew(i)>gBestFitness
            gBestFitness=fitnessNew(i);
            gBest=Xnew(i,:);
        end
    end
    X=Xnew;
    fitness=fitnessNew;
    Best_Pos=gBest;
    Best_fitness=gBestFitness;
    IterCurve(t)=gBestFitness;
end
end
