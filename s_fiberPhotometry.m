function [] = s_fiberPhotometry(path,behavPath,tba,varargin)
%% S_FIBERPHOTOMETRY(path,behav,tba) opens a tank, then creates figures of dF/F both for the whole trace and for perievent trace
% path = path to tank
% behav = path to spreadsheet of list of events (both start and end times, two columns)
% tba = padding before event (seconds, e.g. 0.25)

%%% behavPath = 's_fiberPhotometry.xlsx';
%%% tba = 0.25;
%%% path = 'E:\Users\sqiu\Documents\DATA\fiber photometry\Mouse1-200210-111329';
%%% path = 'C:\Users\Shenfeng Qiu\Documents\DATA\Mouse1-200210-111329';

%%% s_fiberPhotometry('E:\Users\sqiu\Documents\DATA\fiber photometry\Mouse1-200210-111329','s_fiberphotometry.xlsx',0.25);
%%% s_fiberPhotometry('C:\Users\Shenfeng Qiu\Documents\DATA\Mouse1-200210-111329','s_fiberphotometry.xlsx',0.25);

%% Calculate and plot dF/F
behav = xlsread(behavPath);
corder = get(gca,'colororder');
data = TDTbin2mat(path);
bluRaw = data.streams.x465A.data;
bkgRaw = data.streams.x405A.data;
fs = data.streams.x465A.fs;
dt = 1/fs;
L = length(bluRaw)/fs;
t = dt:dt:L;

mdBlu = median(bluRaw);
dffBlu = (bluRaw - mdBlu)./mdBlu;
mdBkg = median(bkgRaw);
dffBkg = (bkgRaw - mdBkg)./mdBkg;
dffTru = dffBlu - dffBkg;
figure(1)
plot(t,dffTru)
title('Bkg subtracted dF/F')
ylabel('dF/F')
xlabel('Time (sec)')

%% Separate data into perievent chunks
ts = behav(:,1);
durs = behav(:,2)-behav(:,1);
tba(2) = max(durs);

if nargin == 4
    grouping = varargin{1};
else
    grouping = ones(length(ts),1);
end
numGroups = max(grouping);
tsGrouped{numGroups} = [];

for i=1:numGroups
    tsGrouped{i} = ts(grouping == i);
end

realtba = round(tba .* fs);
groupedEvents{numGroups} = [];
for i=1:numGroups
    temp = tsGrouped{i}*fs;
    for j=1:length(temp)
        if (round(temp(j))+realtba(2)) <= length(dffTru)
            groupedEvents{i}(j,:) = dffTru(round(temp(j))-realtba(1) : round(temp(j))+realtba(2));
        else
            groupedEvents{i}(j,:) = 0;
        end
    end
    groupedEvents{i} = groupedEvents{i}(any(groupedEvents{i},2),:);
end
tGrouped = realtba./fs;
tGrouped = -tGrouped(1):dt:tGrouped(2);
lGray = [0.8 0.8 0.8];

for i=1:numGroups
    figure(i+1)
    hold on
    plot(tGrouped,groupedEvents{i},'Color',lGray)
    axis tight
    ylabel('dF/F')
    xlabel('Perievent time (sec)')
    y = ylim;
    line([0 0],[y(1) y(2)],'Color','k')
    tempMean = mean(groupedEvents{i},1);
    plot(tGrouped,tempMean,'Color',corder(i,:),'LineWidth',1.5)
    hold off
end
figureCount = i+2;
% Plot imagesc of perievent dF/F
figure(figureCount)
events = zeros(length(ts),length(tGrouped));
for j=1:length(ts)
    temp = tsGrouped{i}*fs;
    if (round(temp(j))+realtba(2)) <= length(dffTru)
        events(j,:) = dffTru(round(temp(j))-realtba(1) : round(temp(j))+realtba(2));
    else
        events(j,:) = [];
    end
end
events = events(any(events,2),:);
cplot = imagesc(events);
colormap jet
cbar = colorbar;
title('Perievent dF/F')
ylabel('Trial')
xlabel('Perievent time (sec)')
ylabel(cbar, 'dF/F')
cplot.XData = tGrouped;
axis tight
hold on
for i=1:size(events,1)
    plot(0,i,'ko','markerfacecolor','g')
    plot(durs(i),i,'ko','markerfacecolor','k')
end