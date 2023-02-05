function Results = s_fearConditioning(xlspath)
%% Generates figures for fear conditioning experiment from excel spreadsheet
%
% INPUT = path to excel file
%

%%% xlspath = 'fearConditioning.xlsx';
%%% Results = s_fearConditioning('fearConditioning.xlsx');

%%% autoArrangeFigures(0, 0, 2)

%%

for i=1:5
    rsheets{i} = xlsread(xlspath,i); %#ok<AGROW>
end

rDay1{1} = rsheets{1}(:,1:5);
rDay1{2} = rsheets{1}(:,7:11);

rDay2 = rsheets{2};

rDay3{1} = rsheets{3}(:,1:5);
rDay3{2} = rsheets{3}(:,7:11);

% Day 4 Raw Data
reporter = 0;
i=1;
while(isnan(reporter) == 0)
    reporter = rsheets{4}(i,1);
    i=i+1;
end
split1 = i-2;

reporter = NaN;
while(isnan(reporter) == 1)
    reporter = rsheets{4}(i,1);
    i=i+1;
end
split2 = i-1;

rDay4{1} = rsheets{4}(1:split1,:);
rDay4{2} = rsheets{4}(split2:end,:);


% Day 5 Raw Data
reporter = 0;
i=1;
while(isnan(reporter) == 0)
    reporter = rsheets{5}(i,1);
    i=i+1;
end
split1 = i-2;

reporter = NaN;
while(isnan(reporter) == 1)
    reporter = rsheets{5}(i,1);
    i=i+1;
end
split2 = i-1;

rDay5{1} = rsheets{5}(1:split1,:);
rDay5{2} = rsheets{5}(split2:end,:);


% Start graphing
figure(1)

subplot(3,1,1)
hold on
lgd(1) = plot(NaN,'Color','k');
lgd(2) = plot(NaN,'Color','r');
legend(lgd,{'ctrl','exp'},'Location','southeast')

for i=1:size(rDay1{1},1)
    palpha = plot(1:size(rDay1{1},2),rDay1{1}(i,:),'k');
    palpha.Color(4) = 0.1;
end
avgDay1C = mean(rDay1{1});
semDay1C = buzsem(rDay1{1});
errorbar(1:size(rDay1{1},2),avgDay1C,semDay1C,'-ok','MarkerFaceColor','k','MarkerSize',3.5)

for i=1:size(rDay1{2},1)
    palpha = plot(1:size(rDay1{2},2),rDay1{2}(i,:),'r');
    palpha.Color(4) = 0.1;
end
avgDay1E = mean(rDay1{2});
semDay1E = buzsem(rDay1{2});
errorbar(1:size(rDay1{2},2),avgDay1E,semDay1E,'-or','MarkerFaceColor','r','MarkerSize',3.5)

xlim([0 6])
ylim([0 100])
xlabel('Tone')
ylabel('Freezing (%)')
xticks(0:1:size(rDay1{1},2))
title('Day 1 training')

Results.Day1.ctrl = rDay1{1};
Results.Day1.exp = rDay1{2};
hold off

subplot(3,1,2)
hold on

for i=1:size(rDay1{1},1)
    palpha = plot(1:size(rDay1{1},2),rDay1{1}(i,:),'k');
    palpha.Color(4) = 0.1;
end
for i=1:size(rDay1{2},1)
    palpha = plot(1:size(rDay1{2},2),rDay1{2}(i,:),'r');
    palpha.Color(4) = 0.1;
end

xlim([0 6])
ylim([0 100])
xlabel('Tone')
ylabel('Freezing (%)')
xticks(0:1:size(rDay1{1},2))
hold off

subplot(3,1,3)
errorbar(1:size(rDay1{1},2),avgDay1C,semDay1C,'-ok','MarkerFaceColor','k','MarkerSize',3.5)
hold on
errorbar(1:size(rDay1{2},2),avgDay1E,semDay1E,'-or','MarkerFaceColor','r','MarkerSize',3.5)
xlim([0 6])
ylim([0 100])
xlabel('Tone')
ylabel('Freezing (%)')
xticks(0:1:size(rDay1{1},2))
hold off




figure(2)
subplot(1,2,1)
avgrDay2_1 = mean(rDay2(:,1));
avgrDay2_2 = mean(rDay2(:,2));

semrDay2_1 = buzsem(rDay2(:,1));
semrDay2_2 = buzsem(rDay2(:,2));
hold on
bar(1,avgrDay2_1,'FaceColor','w','EdgeColor','k','LineWidth',1.5,'BarWidth',0.6)
bar(2,avgrDay2_2,'FaceColor','w','EdgeColor','r','LineWidth',1.5,'BarWidth',0.6)
xlim([0 5])

errorbar(1,avgrDay2_1,semrDay2_1,'Color','k','LineStyle','none');
errorbar(2,avgrDay2_2,semrDay2_2,'Color','r','LineStyle','none');
xticks([1 2])
xticklabels({'ctrl','exp'})
ylabel('Freezing (%)')
ylim([0 100])
title('Day 2, contextual recall')

subplot(1,2,2)
dataCBI{1} = rDay2(:,1);
dataCBI{2} = rDay2(:,2);
groupedBarFear(dataCBI);
ylim([0 100])
xticks([1 1.3])
xticklabels({'ctrl','exp'})
ylabel('Freezing (%)')
title('Day 2, contextual recall')

Results.Day2.ctrl = dataCBI{1};
Results.Day2.exp = dataCBI{2};
hold off


figure(3)
hold on

lgd(1) = plot(NaN,'Color','k');
lgd(2) = plot(NaN,'Color','r');
legend(lgd,{'ctrl','exp'},'Location','southeast')

for i=1:size(rDay3{1},1)
    palpha = plot(1:size(rDay3{1},2),rDay3{1}(i,:),'k');
    palpha.Color(4) = 0.1;
end
avgDay1C = mean(rDay3{1});
semDay1C = buzsem(rDay3{1});
errorbar(1:size(rDay3{1},2),avgDay1C,semDay1C,'-ok','MarkerFaceColor','k','MarkerSize',3.5)

for i=1:size(rDay3{2},1)
    palpha = plot(1:size(rDay3{2},2),rDay3{2}(i,:),'r');
    palpha.Color(4) = 0.1;
end
avgDay1E = mean(rDay3{2});
semDay1E = buzsem(rDay3{2});
errorbar(1:size(rDay3{2},2),avgDay1E,semDay1E,'-or','MarkerFaceColor','r','MarkerSize',3.5)

xlim([0 6])
ylim([0 100])
xlabel('Tone')
ylabel('Freezing (%)')
xticks(0:1:size(rDay3{1},2))
title('Day 3, cued fear conditioning response')

Results.Day3.ctrl = rDay3{1};
Results.Day3.exp = rDay3{2};



figure(4)

subplot(3,1,1)
hold on

lgd(1) = plot(NaN,'Color','k');
lgd(2) = plot(NaN,'Color','r');
legend(lgd,{'ctrl','exp'},'Location','southeast')

for i=1:size(rDay4{1},1)
    palpha = plot(1:size(rDay4{1},2),rDay4{1}(i,:),'k');
    palpha.Color(4) = 0.1;
end
avgDay1C = mean(rDay4{1});
semDay1C = buzsem(rDay4{1});
errorbar(1:size(rDay4{1},2),avgDay1C,semDay1C,'-ok','MarkerFaceColor','k','MarkerSize',3.5)

for i=1:size(rDay4{2},1)
    palpha = plot(1:size(rDay4{2},2),rDay4{2}(i,:),'r');
    palpha.Color(4) = 0.1;
end
avgDay1E = mean(rDay4{2});
semDay1E = buzsem(rDay4{2});
errorbar(1:size(rDay4{2},2),avgDay1E,semDay1E,'-or','MarkerFaceColor','r','MarkerSize',3.5)

xlim([0 41])
ylim([0 100])
xlabel('Tone')
ylabel('Freezing (%)')
title('Day 4, extinction training')

Results.Day4.ctrl = rDay4{1};
Results.Day4.exp = rDay4{2};
hold off

subplot(3,1,2)
hold on
for i=1:size(rDay4{1},1)
    palpha = plot(1:size(rDay4{1},2),rDay4{1}(i,:),'k');
    palpha.Color(4) = 0.1;
end
for i=1:size(rDay4{2},1)
    palpha = plot(1:size(rDay4{2},2),rDay4{2}(i,:),'r');
    palpha.Color(4) = 0.1;
end
xlim([0 41])
ylim([0 100])
xlabel('Tone')
ylabel('Freezing (%)')
hold off

subplot(3,1,3)
hold on
errorbar(1:size(rDay4{1},2),avgDay1C,semDay1C,'-ok','MarkerFaceColor','k','MarkerSize',3.5)
errorbar(1:size(rDay4{2},2),avgDay1E,semDay1E,'-or','MarkerFaceColor','r','MarkerSize',3.5)
xlim([0 41])
ylim([0 100])
xlabel('Tone')
ylabel('Freezing (%)')

hold off

figure(5)
hold on

lgd(1) = plot(NaN,'Color','k');
lgd(2) = plot(NaN,'Color','r');
legend(lgd,{'ctrl','exp'},'Location','southeast')

for i=1:size(rDay5{1},1)
    palpha = plot(1:size(rDay5{1},2),rDay5{1}(i,:),'k');
    palpha.Color(4) = 0.1;
end
avgDay1C = mean(rDay5{1});
semDay1C = buzsem(rDay5{1});
errorbar(1:size(rDay5{1},2),avgDay1C,semDay1C,'-ok','MarkerFaceColor','k','MarkerSize',3.5)

for i=1:size(rDay5{2},1)
    palpha = plot(1:size(rDay5{2},2),rDay5{2}(i,:),'r');
    palpha.Color(4) = 0.1;
end
avgDay1E = mean(rDay5{2});
semDay1E = buzsem(rDay5{2});
errorbar(1:size(rDay5{2},2),avgDay1E,semDay1E,'-or','MarkerFaceColor','r','MarkerSize',3.5)

xlim([0 9])
xlabel('Tone')
ylabel('Freezing (%)')
title('Day 5, extinction recall')

Results.Day5.ctrl = rDay5{1};
Results.Day5.exp = rDay5{2};


end