function pop = SortPopulation(pop)
%% ���Ŵ��㷨�����Ⱥ������Ⱥ��Costֵ��������
[~,RSO] = sort([pop.Cost]);
pop = pop(RSO);
end

