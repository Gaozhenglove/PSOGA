function pop = SortPopulation(pop)
%% 把遗传算法里的种群按照种群的Cost值进行排序
[~,RSO] = sort([pop.Cost]);
pop = pop(RSO);
end

