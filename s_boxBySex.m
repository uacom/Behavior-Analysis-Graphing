function [rData] = s_boxBySex(xlspath, numGroups)
%% S_BOXBYSEX(xlspath, numGroups) takes an excel file and plots box plots with raw data points, separated by sex
%
% INPUTS
% xlspath = path to excel file
% numGroups = number of boxplots/groups

%%% VARS FOR TESTING
%%% xlspath = 'columnDataBySex.xlsx';
%%% numGroups = 4;

%%%% TEST FUNCTION %%%%
%%%% s_boxBySex('C:\Users\Shenfeng Qiu\Documents\Current Projects\Chu Chen\layer_inputs_exc.xlsx',2);

%%%% s_boxBySex('C:\Users\Shenfeng Qiu\Documents\Grants\Jason Newbern\MPI R01\OF_totalDistance.xlsx',2);
%%%% s_boxBySex('C:\Users\Shenfeng Qiu\Documents\Grants\Jason Newbern\MPI R01\OF_centerPercent.xlsx',2);
%%%% s_boxBySex('C:\Users\Shenfeng Qiu\Documents\Grants\Jason Newbern\MPI R01\EPM_timeinOpenArm.xlsx',2);
%%%% s_boxBySex('columnDataBySex.xlsx',4);
%%%% s_boxBySex('columnDataBySex.xlsx',2);
%%%% s_boxBySex('columnDataBySex_5groups.xlsx',5);
%%%% s_boxBySex('C:\Users\Shenfeng Qiu\Documents\Current Projects\Met behavior paper\R2\MWM probe young.xlsx',2);
%%%% s_boxBySex('C:\Users\Shenfeng Qiu\Documents\Current Projects\Met behavior paper\R2\EPM young.xlsx',2);
%%%% s_boxBySex('C:\Users\Shenfeng Qiu\Documents\Current Projects\Met behavior paper\R2\MWM avg speed day1-8 young.xlsx',2);
%%%% s_boxBySex('C:\Users\Shenfeng Qiu\Documents\Current Projects\Met behavior paper\R2\MWM avg speed day1-8 old.xlsx',2);
%%%% s_boxBySex('C:\Users\Shenfeng Qiu\Documents\Current Projects\Chang Chen paper\LTP last 10min_P23PFC.xlsx',2);
%%%% s_boxBySex('C:\Users\Shenfeng Qiu\Documents\Current Projects\Chang Chen paper\Behavior\MWM probe REAL.xlsx',2);
%%%% s_boxBySex('C:\Users\Shenfeng Qiu\Documents\Current Projects\Chang Chen paper\Behavior\FC contextual recall REAL.xlsx',2);
%%%% s_boxBySex('C:\Users\Shenfeng Qiu\Documents\Current Projects\Chang Chen paper\LTP last 10min_P23PFC.xlsx',2);
%%%% s_boxBySex('C:\Users\Shenfeng Qiu\Documents\Current Projects\Chang Chen paper\lspsMapExc.xlsx',2);
%%%% s_boxBySex('C:\Users\Shenfeng Qiu\Documents\Current Projects\Chang Chen paper\lspsMapInh.xlsx',2);
%%%% s_boxBySex('C:\Users\Shenfeng Qiu\Documents\Current Projects\MET JN paper\mEPSC freq.xlsx',2);
%%%% s_boxBySex('C:\Users\Shenfeng Qiu\Documents\Current Projects\MET JN paper\lsps_inhi_combined.xlsx',2);
%%%% s_boxBySex('C:\Users\Shenfeng Qiu\Documents\Current Projects\MET JN paper\marble bury.xlsx',2);
%%%% s_boxBySex('C:\Users\Shenfeng Qiu\Documents\Current Projects\MET JN paper\EPM_no_entry.xlsx',2);
%% Extract data from Excel
L=1;
for i=1:numGroups
    rData{i} = xlsread(xlspath,i); %#ok<AGROW>
    tempL = length(rData{i});
    if tempL >= L
        L = tempL; % determine length of longest array
    end
end


%% Fig. 1 - Box Plots

% Create box plots
for i=1:numGroups % combine male and female data into one matrix for box plotting
    tempL = length(rData{i});
    if tempL < L
        rData{i}(tempL+1:L,1) = NaN;
        rData{i}(tempL+1:L,2) = NaN;
    end
    combData(:,i) = [rData{i}(:,1);rData{i}(:,2)]; %#ok<AGROW>
end

bplot(combData,'nomean','nodots'); % plot the boxplots
xticks(1:numGroups)
%ylim([0 3000])

% Plot the data points over box plot
hold on
for i=1:numGroups
    tempMax = max(max(rData{i}));
    tempMin = min(min(rData{i}));
    
    % For male
    tempArray = rData{i}(:,1);
    tempArray = tempArray(~isnan(tempArray));
    tempArray = sort(tempArray);
    if max(tempArray) == tempMax
        scatter(i,tempMax,'o','MarkerEdgeColor',[1 1 1],'MarkerFaceColor',[0.5 0.5 0.5],'MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',1)
        tempArray = tempArray(1:end-1);
    end
    if min(tempArray) == tempMin
        scatter(i,tempMin,'o','MarkerEdgeColor',[1 1 1],'MarkerFaceColor',[0.5 0.5 0.5],'MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',1)
        tempArray = tempArray(2:end);
    end
    randPos = linspace(i-0.25,i+0.25,5);
    for ii=1:length(tempArray)
        scatter(randPos(mod(ii,5)+1),tempArray(ii),'o','MarkerEdgeColor',[1 1 1],'MarkerFaceColor',[0.5 0.5 0.5],'MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',1)
    end
    
    % For female
    tempArray = rData{i}(:,2);
    tempArray = tempArray(~isnan(tempArray));
    tempArray = sort(tempArray);
    if max(tempArray) == tempMax
        scatter(i,tempMax,'ko')
        tempArray = tempArray(1:end-1);
    end
    if min(tempArray) == tempMin
        scatter(i,tempMin,'ko')
        tempArray = tempArray(2:end);
    end
    randPos = linspace(i-0.25,i+0.25,5);
    for ii=1:length(tempArray)
        scatter(randPos(mod(ii,5)+1),tempArray(ii),'ko')
    end
end
box off
xlabel('Group')


%% Fig. 2 - Mean + errorbar
combCells{numGroups} = [];
combMeans = zeros(1,numGroups);
combSems = zeros(1,numGroups);
for i=1:numGroups
    combCells{i} = combData(:,i);  % get data from table into cell to remove NaNs, thus allowing for arrays of different sizes for each group
    combCells{i} = combCells{i}(~isnan(combCells{i}));
    combMeans(i) = mean(combCells{i});
    combSems(i) = buzsem(combCells{i});
end

figure(2)

bar(combMeans, 'FaceColor', 'none', 'EdgeColor', 'k', 'LineWidth', 1.5)
hold on
xlim([0 numGroups+3])
xticks(1:numGroups)

for i=1:numGroups
    errorbar(i, combMeans(i), 0, combSems(i), 'k','LineWidth',1.5, 'CapSize',15)
end
xlabel('Group')
box off

%%%%%% The following code copied from above

for i=1:numGroups
    tempMax = max(max(rData{i}));
    tempMin = min(min(rData{i}));
    
    % For male
    tempArray = rData{i}(:,1);
    tempArray = tempArray(~isnan(tempArray));
    tempArray = sort(tempArray);
    if max(tempArray) == tempMax
        scatter(i,tempMax,35,'o','MarkerEdgeColor',[1 1 1],'MarkerFaceColor',[0.7 0.7 0.7],'MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',1)
        tempArray = tempArray(1:end-1);
    end
    if min(tempArray) == tempMin
        scatter(i,tempMin,35,'o','MarkerEdgeColor',[1 1 1],'MarkerFaceColor',[0.7 0.7 0.7],'MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',1)
        tempArray = tempArray(2:end);
    end
    randPos = linspace(i-0.25,i+0.25,5);
    for ii=1:length(tempArray)
        scatter(randPos(mod(ii,5)+1),tempArray(ii),35,'o','MarkerEdgeColor',[1 1 1],'MarkerFaceColor',[0.7 0.7 0.7],'MarkerFaceAlpha',0.7,'MarkerEdgeAlpha',1)
    end
    
    % For female
    tempArray = rData{i}(:,2);
    tempArray = tempArray(~isnan(tempArray));
    tempArray = sort(tempArray);
    if max(tempArray) == tempMax
        scatter(i,tempMax,25,'ko','MarkerEdgeAlpha',0.7)
        tempArray = tempArray(1:end-1);
    end
    if min(tempArray) == tempMin
        scatter(i,tempMin, 25, 'ko', 'MarkerEdgeAlpha',0.7)
        tempArray = tempArray(2:end);
    end
    randPos = linspace(i-0.25,i+0.25,5);
    for ii=1:length(tempArray)
        scatter(randPos(mod(ii,5)+1),tempArray(ii),25,'ko','MarkerEdgeAlpha',0.7)
    end
    autoArrangeFigures(0,0,2)
end

%%%%%