clear
clc
close all

load spkMatrix.mat
clear ts150_3d_New

%% FOR SQ ONLY, load the raster.mat file. and go through sampleRaster1.m on how to generate the 3D test matrices
% NOTE: this one has problem plotting figure 1, use the Chinwong_Fig1_v2.m
% instead this one
%% parameters setting
width = 1; % set the window as 1ms
Event_Time = [51 100]; 

%% main calculation
[N_Trials,N_Time,N_Units] = size(ts150_3d);

N_Win = N_Time/width; % estimate the number of windows

ts150_3d_New =ts150_3d;

% the number of spikes in each window for all units and trials
for i = 1 : 1 : N_Win
    ts150_3d_New(:,i,:) = sum(ts150_3d(:,(i-1)*width+1:i*width,:),2);
end

% number of spikes in each window for each units (sum across all trials)
ts150_3d_New = squeeze(sum(ts150_3d_New,1));


% 23052020 Calculation of mean and standard error firing rate
for k=1:N_Units
    for i=1:N_Trials
        for j=1:N_Win
            count1 = ((j-1)*width)+1;
            count2 = j*width; 
            fr(i,j,k) = sum(ts150_3d(i,count1:count2,k))/(width/1000);  %#ok<SAGROW> % the firing rate for each unit in each window
        end
    end
end

mean_fr = squeeze(mean(fr,1))';
m_mean_fr = mean(mean_fr,1);
sem_fr = buzsem(mean_fr,1);


figure 
% plot(ts150_3d_New(:,1)) % figures like those in Fig 6E
% plot(sum(ts150_3d_New,2)) %PLEASE FIX THIS. THIS SHOULD REFLECT THE REAL SPIKE FREQUENCY. BECAUSE THIS IS FOR 240 CELLS, WE SHOULD HAVE SOMETHING...
%LIKE FIGURE 6C, WITH MEAN FIRING RATE AND ALSO STANDARD ERROR. YOU CAN
%CALCULATE THESE, I WILL PLOT USING SHADEDERRORBAR.M
% For mean use m_mean_fr, sem is sem_fr


% z-scores
Base_Time = [1:Event_Time(1)];

for i = 1 : 1 : N_Units
    Base_Spk_Mean(i)= mean(ts150_3d_New(Base_Time,i));
    Base_Spk_Std(i)= std(ts150_3d_New(Base_Time,i));
    % the z-scores for all time 
    Z_Scores(:,i) = (ts150_3d_New(:,i) - Base_Spk_Mean(i))/Base_Spk_Std(i);
end

% event time reponse
Event_Response = mean(Z_Scores(Event_Time(1):Event_Time(2),:),1);

% sort by the event time reponse 
% since the units from 115 to 240 displayed no spikes, so maybe you could
% check the matrix, here I use the units from 1 to 100

[~,Order_Spk] = sort(Event_Response(1:100),'descend');

Z_Score_Plus = [Z_Scores(:,1:100);Event_Response(1:100)];

figure(2)
imagesc(Z_Scores(:,Order_Spk)', [-5 6]) % figure in Fig6G
colorbar, colormap jet
xlabel('Perievent time (aligned to behavior)');
ylabel('Cell number')
hold on
plot([50 50], [1 115], ':', 'Color', [0 0 0], 'LineWidth', 1.5)

figure(3)
imagesc(Z_Score_Plus(:,Order_Spk)', [-5 6]) % figure in Fig6G
colorbar, colormap jet
xlabel('Perievent time (aligned to behavior)');
ylabel('Cell number')
hold on
plot([50 50], [1 115], ':', 'Color', [0 0 0], 'LineWidth', 1.5)


autoArrangeFigures(0, 0,2)