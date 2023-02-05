function mb = mbAnalyze(excel)
%% Uses spreadsheet of annotations to generate structure and graph with behavior data
%
% INPUT: excel = excel file to read
%
% OUTPUT: mb = structure with annotated behavioral events. Use mb +
% tag number for struct name (ex. mb2301)
%
%
%%% FOR DEBUGGING:
%%% excel = 'C:\Users\Shenfeng Qiu\Documents\MATLAB\mb2301.xlsx';
%%% mb = mbAnalyze('C:\Users\Shenfeng Qiu\Documents\MATLAB\mb2301.xlsx')

grooming = xlsread(excel, 'grooming'); % Get matrices from excel sheets
jumping = xlsread(excel, 'jumping');
digging = xlsread(excel, 'digging');

dBlue = [0 0.4470 0.7410]; % Nice colors for use in graphing
dRed = [0.7410 0 0.4470];
dGreen = [0.4470 0.7410 0];
gray = [0.75 0.75 0.75];

mb.grm = grooming(2:end,:); % cut out first line because that is just duration of the video
mb.jump = jumping(2:end,:);
mb.dig = digging(2:end,:);

mb.Duration = grooming(1,2)-grooming(1,1); % duration of video (seconds)

figure

subplot(3,1,1)
line([grooming(1,1) grooming(1,2)],[1 1],'Color','k','LineWidth',0.5)
hold on
for i=1:length(mb.grm)
    line([mb.grm(i,1) mb.grm(i,2)],[1 1],'Color',dBlue,'LineWidth',10)
end
set(gca,'YTick',[])
title('Grooming')
xlabel('Time (s)')



subplot(3,1,2)
line([grooming(1,1) grooming(1,2)],[1 1],'Color','k','LineWidth',0.5)
hold on
for i=1:length(mb.jump)
    line([mb.jump(i,1) mb.jump(i,2)],[1 1],'Color',dRed,'LineWidth',10)
end
set(gca,'YTick',[])
title('Jumping')
xlabel('Time (s)')


subplot(3,1,3)
line([grooming(1,1) grooming(1,2)],[1 1],'Color','k','LineWidth',0.5)
hold on
for i=1:length(mb.dig)
    line([mb.dig(i,1) mb.dig(i,2)],[1 1],'Color',dGreen,'LineWidth',10)
end
set(gca,'YTick',[])
title('Digging')
xlabel('Time (s)')


% Graph of all four behavior states
figure
line([grooming(1,1) grooming(1,2)],[1 1],'Color',gray,'LineWidth',10)
hold on
for i=1:length(mb.grm)
    line([mb.grm(i,1) mb.grm(i,2)],[1 1],'Color',dBlue,'LineWidth',10)
end
for i=1:length(mb.dig)
    line([mb.dig(i,1) mb.dig(i,2)],[1 1],'Color',dGreen,'LineWidth',10)
end
for i=1:length(mb.jump)
    line([mb.jump(i,1) mb.jump(i,2)],[1 1],'Color',dRed,'LineWidth',10)
end
set(gca,'YTick',[])
xlabel('Time (s)')

% calculate duration of each behavior
mb.Length(1) = abs((sum(mb.grm(:,1)-mb.grm(:,2))));
mb.Length(2) = abs((sum(mb.jump(:,1)-mb.jump(:,2))));
mb.Length(3) = abs((sum(mb.dig(:,1)-mb.dig(:,2))));
mb.Length(4) = mb.Duration-mb.Length(1)-mb.Length(2)-mb.Length(3);

% calculate percentages of each behavior
mb.Percents(1) = mb.Length(1)/mb.Duration*100;
mb.Percents(2) = mb.Length(2)/mb.Duration*100;
mb.Percents(3) = mb.Length(3)/mb.Duration*100;
mb.Percents(4) = 100-mb.Percents(1)-mb.Percents(2)-mb.Percents(3);

% make bar graphs and pie chart of different behaviors
figure

subplot(2,2,4)
labels = {'Grooming','Jumping','Digging','Other'};
bar(mb.Length)
set(gca,'XTickLabel',labels)
xlabel('Behavior')
ylabel('Duration (s)')

subplot(2,2,2)
bar(mb.Percents)
set(gca,'XTickLabel',labels)
xlabel('Behavior')
ylabel('Percent of Total Time (%)')

subplot(2,2,[1 3])
pie(mb.Percents,[1 1 1 1],{'Grooming','Jumping','Digging','Other'})
autoArrangeFigures(0, 0, 2)
