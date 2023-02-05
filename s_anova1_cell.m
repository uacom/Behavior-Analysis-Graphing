function [p, t, stats] =s_anova1_cell(C)
% use a cell array instead a matrix for anova analysis
% load myStat.mat variables
 
X = cell2mat(C); group =[]; % X is now a 1*N vector, N is all group size combined
for i=1:length(C) 
    group = [group, i*ones(1,length(C{i}))]; 
end


[p, t, stats] = anova1(X, group)
[c,m,h,nms] = multcompare(stats)



% group is in format of [1 1 1 1 1 1 1 1 2 2 2 2 2 2 3 3 3 3 3 3 3] 