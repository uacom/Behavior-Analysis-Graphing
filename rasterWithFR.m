%%%%% rasterWithFR %%%%%

%% SQ NOTE: THE RESULTING FIGURE IS VERY COMPLICATED OBJECTS. TO COPY TO ILLUSTRATOR AS A VECTOR
% NEED TO COPY OPTIONS>SLIPBOARD FORMAT AS METAFILE. SIMPLY SAVE AS EPS
% OR PDF WON'T WORK.
%%
% load spkMatrix

fs = 1000;
binWidth = 50; %adjust this if necessary

%%%%%%%% RUN THIS FOR BIG MATRIX WITH GROUP VECTOR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% SKIP FOR THREE SEPARATE MATRICES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
j = 1;
jj = 1;
jjj = 1;
for i=1:size(mat123,1) %#ok<SUSENS>
    switch groupVector(i)
        case 1
            mat1(j,:) = mat123(i,:); %#ok<SAGROW>
            j = j+1;
        case 2
            mat2(jj,:) = mat123(i,:); %#ok<SAGROW>
            jj = jj+1;
        case 3
            mat3(jjj,:) = mat123(i,:); %#ok<SAGROW>
            jjj = jjj+1;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Generate firing rate and spike rasters
for i=1:size(mat1,1)
    for j=1:size(mat1,2)/binWidth
        count1 = ((j-1)*binWidth)+1;
        count2 = j*binWidth; 
        FiringRate1(i,j) = sum(mat1(i,count1:count2))/(binWidth/fs);  %#ok<SAGROW> % the firing rate for each unit in each window
    end
end

for i=1:size(mat2,1)
    for j=1:size(mat2,2)/binWidth
        count1 = ((j-1)*binWidth)+1;
        count2 = j*binWidth; 
        FiringRate2(i,j) = sum(mat2(i,count1:count2))/(binWidth/fs);  %#ok<SAGROW> % the firing rate for each unit in each window
    end
end

for i=1:size(mat3,1)
    for j=1:size(mat3,2)/binWidth
        count1 = ((j-1)*binWidth)+1;
        count2 = j*binWidth; 
        FiringRate3(i,j) = sum(mat3(i,count1:count2))/(binWidth/fs);  %#ok<SAGROW> % the firing rate for each unit in each window
    end
end

meanFR1 = mean(FiringRate1,1);
meanFR2 = mean(FiringRate2,1);
meanFR3 = mean(FiringRate3,1);
semFR1 = buzsem(FiringRate1,1);
semFR2 = buzsem(FiringRate2,1);
semFR3 = buzsem(FiringRate3,1);

bt1 = [meanFR1-semFR1; meanFR1+semFR1];
bt2 = [meanFR2-semFR2; meanFR2+semFR2];
bt3 = [meanFR3-semFR3; meanFR3+semFR3];

figure
lgd(1)=area(NaN,'FaceColor',[0 0.5470 0.8410]);
hold on
lgd(2)=area(NaN,'FaceColor',[0.4990, 0.7740, 0.2880]);
lgd(3)=area(NaN,'FaceColor',[0.7350, 0.1280, 0.2840]);
set(lgd, 'LineStyle', 'none')

legend(lgd,'Location','southeast')

shadeDt = binWidth/fs;
xShade = shadeDt:shadeDt:length(mat1)/fs;
shadedplot(xShade,bt1(1,:),bt1(2,:),[0 0.5470 0.8410],'none');
hold on
shadedplot(xShade,bt2(1,:),bt2(2,:),[0.4990, 0.7740, 0.2880],'none');
hold on
shadedplot(xShade,bt3(1,:),bt3(2,:),[0.7350, 0.1280, 0.2840],'none');
hold on
y = ylim;
ylim([0 y(2)])

dt=1/fs;
t=dt:dt:size(mat1,2)/fs;
vertCount = size(mat1,1)+size(mat2,1)+size(mat3,1);
dRast = y(2)/vertCount;
yRast = dRast:dRast:y(2);
rastCount = 1;

% first group
for i=1:size(mat1,1)
    for j=1:size(mat1,2)
        if mat1(i,j) == 1
            line([t(j) t(j)],[yRast(rastCount)-dRast/2 yRast(rastCount)+dRast/2],'Color',[0 0.4470 0.7410])
        end
    end
    rastCount=rastCount+1;
end
hold on

% second group
for i=1:size(mat2,1)
    for j=1:size(mat2,2)
        if mat2(i,j) == 1
            line([t(j) t(j)],[yRast(rastCount)-dRast/2 yRast(rastCount)+dRast/2],'Color',[0.4660, 0.6740, 0.1880])
        end
    end
    rastCount=rastCount+1;
end
hold on

% third group
for i=1:size(mat3,1)
    for j=1:size(mat3,2)
        if mat3(i,j) == 1
            line([t(j) t(j)],[yRast(rastCount)-dRast/2 yRast(rastCount)+dRast/2],'Color',[0.6350, 0.0780, 0.1840])
        end
    end
    rastCount=rastCount+1;
end
hold on
xlabel('Time (s)')
ylabel('Firing rate (spk/s)')
