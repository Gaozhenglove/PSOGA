function chrom = initialGA(bestPos)
% ����Լ���������Կռ���������ʼ����Ⱥ
code = [ones(1,bestPos(1)),ones(1,bestPos(2))*2,ones(1,bestPos(3))*3,...
    ones(1,bestPos(4))*4,ones(1,bestPos(5))*5];

idx = randperm(length(code));
code = code(idx);
chrom = code;
end

