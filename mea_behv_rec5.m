
function [] = mea_behv_rec5(f_behav, f_ts, timeframe, interval_num, maxi, spkThinner, zscoreThinner, z_multiplier) 

% consider to use s_processTs.m to remove short isi and thin the spike vector.
% SQ NOTE: USE THIS ONE FOR  OPEN FIELD only, for three chamber, use the 
% mea_behv_rec.m file
% for ver 4, implemented a spike and zscore thinner, to plot one spik/z
% score in every XX data points, this reduces crowding.

% for trial run, load the mea_behav_rec5.mat file

%%
% mea_behv_rec5('open chamber SI with recording.xlsx', 'open chamber SI with recording timestamps.xlsx', [1 3], 15, 0.15, [2 15], [1 3]); 
% mea_behv_rec5('open chamber SI with recording.xlsx', 'open chamber SI with recording timestamps.xlsx', [1 5], 15, 0.15, [1 8], [1 5], [2 0.75]); 
% mea_behv_rec5('open chamber SI with recording.xlsx', 'open chamber SI with recording timestamps.xlsx', [6 10], 15, 0.10, [1 8], [1 5], [2 0.75]); 
% f_behav = 'open chamber SI with recording.xlsx';
% f_ts = 'open chamber SI with recording timestamps.xlsx';
%%
% timeframe = [1 11];
% interval_num = 5; % for fig.1. plot 1 in every 15 frame locations on
% movement track
% z_multiplier = [4 1], % for display only. Z score in IZ multiply by 4,
% not in IZ by 1 (no change)

% maxi = 0.15; % maximum moving speed displayed

% spkThinner = [2 15]; % for spike ts in IZ, thin it by a factor of 2, for
% spike ts not in IZ, thin it by a factor of 15. For plotting only


aa_behav=xlsread(f_behav,'Track-Arena 1-Subject 1');

%% extract more columns to a_behav2 variable, to get the time spent on left interaction zone and right interaction zone
a_behav2=aa_behav(:,[2:4, 11]);
% delete the row including 'NAN'  
a_behav2 = a_behav2(all(a_behav2==a_behav2,2),:); 
a_behav2(any(a_behav2~=a_behav2,2),:) = []; 

ts_iz = a_behav2(a_behav2(:,4) ==1,:); % all video frame timestamps in interaction zone

ts_niz = a_behav2(a_behav2(:,4) ~=1,:);

figure(1) % plot one single scatter to denote time in social interaction zone

scatter(ts_iz(:,1), ones(length(ts_iz(:,1)), 1), 5, 'filled'); xlim([0 max(a_behav2(:,1))]); ylim([0 2]); % for 600 sec behavior data

title('time spent in social interaction zone');xlabel('time (sec)');ylabel('interaction');
legend('in social interaction zone')
axis square
%%
% a_behav=aa_behav(:,2:4);
% % delete the row including 'NAN'  
% a_behav = a_behav(all(a_behav==a_behav,2),:); 
% a_behav(any(a_behav~=a_behav,2),:) = []; 

if length(timeframe) == 2 % if timeframe specified, then only use values within that timeframe
    index = find(a_behav2(:,1) >= timeframe(1)*60);
    index = index(a_behav2(index,1)<=timeframe(2)*60);
    a_behav3 = a_behav2(index,:);
end

num = interval_num;

figure(2) % moving track with scattered colored marker denote moving speed

plot(a_behav3(:,2),a_behav3(:,3),'k');
hold on;
dim=length(a_behav3(:,1))-1;
veloc=zeros(dim,1);
for i=1:dim
    veloc(i)=sqrt((a_behav3(i+1,2)-a_behav3(i,2)).^2+(a_behav3(i+1,3)-a_behav3(i,3)).^2)/((a_behav3(i+1,1)-a_behav3(i,1))*100);
end
p=[a_behav3(1:dim,:),veloc];
%result=p;
%scatter(p(:,1),p(:,2),30,p(:,3),'square','filled');
scatter(p(1:num:dim,2),p(1:num:dim,3),25,p(1:num:dim,5),'filled'); colormap(flipud(jet)); caxis([0,maxi])
% scatter(p(1:num:dim,2),p(1:num:dim,3),30,p(1:num:dim,4),'square','filled');
title('moving track with speed');xlabel('x position (cm)');ylabel('y position (cm)'); axis square


%% read all the spike timestamps
aa_ts=xlsread(f_ts,'Sheet1');
% a_ts=aa_ts(:,1:2);
% 
% a_ts = a_ts(all(a_ts==a_ts,2),:); 
% a_ts(any(a_ts~=a_ts,2),:) = []; 
a_ts = aa_ts(:,2);
a_ts = s_processTs(a_ts, 50, 6); % remove frequency > 50Hz, and remove/thin 1/6 ts randomly, this will affect Z score of course

if length(timeframe) == 2 % if timeframe specified, then only use values within that timeframe
    index = find(a_ts(:,1) >= timeframe(1)*60);
    index = index(a_ts(index,1)<=timeframe(2)*60);
    a_ts2 = a_ts(index,:);  % select all spike Ts within timeframe
end

ind = zeros(1, length(a_ts2));

for ii = 1:length(a_ts2)
    ind(ii) = s_sort(a_ts2(ii), a_behav3(:,1));
end

a_behav4 = zeros(length(a_ts2), size(a_behav3, 2));
for jj = 1:length(a_ts2)
    a_behav4(jj,:) = a_behav3(ind(jj), :);
end

a_behav5 = unique(a_behav4, 'rows');


% 
% t = zeros(length(a_ts2),3); % holder for extracted behav file triplets based on the timestamps happening during the selected time.
% k = zeros(length(a_ts2),length(a_behav3)); % a_behav3: all the video Ts within timeframe
% kk = zeros(1,length(a_ts2));
% 
% for counter = 1:length(a_ts2)
%     k(counter,:) = a_ts2(counter) > a_behav3(:,1)';
% kk(counter) = strfind(k(counter,:),[1 0]);
% % t(counter,:) = a_behav3(kk(counter),:);
% end
% 
% for ii = 1:506-1
%     t(ii) = a_behav3(kk(ii),:)
%     t = [t;t
% counter = 100


%% plot timestamps


figure(3)
plot(a_behav3(:,2),a_behav3(:,3),'k');
hold on;
tx = a_behav5(:,2); ty = a_behav5(:,3);
% scatter(tx(1:spkThinner(1):end), ty(1:spkThinner(1):end),15,'filled', 'r');  % thin all the spike ts by a factor of spkThinner(1)
scatter(tx, ty,15,'filled', 'r');  % scatter all spikes during timeframe!!.

title('all spk alg mov track w/ timeframe'); axis square

figure(4)
plot(a_behav3(:,2),a_behav3(:,3),'Color', [.75 .75 .75]);
hold on;

a_behav6 = sortrows(a_behav5, [4 1]);

select_ts_iz = a_behav6(a_behav6(:, 4) == 1,:);
select_ts_niz = a_behav6(a_behav6(:, 4) == 0,:);

% iz_ts = ts_iz(:,1);
% niz_ts = ts_niz(:,1);
% 
% t2 = zeros(length(iz_ts),3); % holder for extracted behav file triplets based on the timestamps happening during the selected time.
% k2 = zeros(length(iz_ts),length(a_behav));
% kk2 = zeros(1,length(iz_ts));
% 
% for ii = 1:length(iz_ts)
%     k2(ii,:) = iz_ts(ii) > a_behav(:,1)';
%     kk2(ii) = strfind(k2(ii,:),[1 0]);
%     t2(ii,:) = a_behav(kk2(ii),:);
% end

txiz = select_ts_iz(:,2); tyiz = select_ts_iz(:,3);

% t3 = zeros(length(niz_ts),3); % holder for extracted behav file triplets based on the timestamps happening during the selected time.
% k3 = zeros(length(niz_ts),length(a_behav));
% kk3 = zeros(1,length(niz_ts));
% 
% for ii = 1:length(niz_ts)
%     k3(ii,:) = niz_ts(ii) > a_behav(:,1)';
%     kk3(ii) = strfind(k3(ii,:),[1 0]);
%     t3(ii,:) = a_behav(kk3(ii),:);
% end

txniz = select_ts_niz(:,2); tyniz = select_ts_niz(:,3);

% txniz = ts_niz(:,2); tyniz = ts_niz(:,3);
scatter(txiz(1:spkThinner(1):end), tyiz(1:spkThinner(1):end),15,'filled', 'r'); 
% scatter(txiz, tyiz,15,'filled', 'r'); 
hold on
scatter(txniz(1:spkThinner(2):end), tyniz(1:spkThinner(2):end),10,'filled', 'k');
title('spk classification according to IZ'); axis square
legend('', 'spk in IZ')
    
% 
% if length(timeframe) == 2 % if timeframe specified, then only use values within that timeframe
%     index = find(a_ts(:,1) >= timeframe(1)*60);
%     index = index(a_ts(index,1)<=timeframe(2)*60);
%     a_ts = a_ts(index,:);
% end
% 
% if length(timeframe) == 2 % if timeframe specified, then only use values within that timeframe
%     index = find(ts_niz(:,1) >= timeframe(1)*60);
%     index = index(ts_niz(index,1)<=timeframe(2)*60);
%     ts_niz = ts_niz(index,:);
% end




figure(5)
[N,Xbins,Ybins]=hist2d(a_behav6(:,2), a_behav6(:,3),20,'tile'); colormap jet; % use x y bins of 20 each.
title('hist2d count of spikes during timeframe with spike locs'); axis square
figure(6)
imagesc(flipud(N)); colormap(redblue)
title('hist2d count of spikes during timeframe'); axis square

%% z score calculation
zdata=xlsread(f_ts,'Sheet1'); % timestamps of firing
bs_zdata = zdata(:,1); bs_zdata = bs_zdata(~isnan(bs_zdata)); % baseline firing is column one, used to calculate Z score
bs_zdata = sort(bs_zdata);
bs_duration = 300; % number of minutes for the baseline; always used 5 min baseline in experiments
bs_freq = length(bs_zdata)/(bs_duration); % baseline firing frequency

bs_binsize = 1; % use a baseline binsize to calculate overall sd of frequency, this has 300 data points
N_bs = hist(bs_zdata, 1:bs_binsize:bs_duration);
N_bs_z = N_bs*1/bs_binsize;
bs_mn_z = mean(N_bs_z);
bs_std_z = std(N_bs_z);


trial_zdata = zdata(:,2); % timestamps during the entire duration of trial
trial_zdata = sort(trial_zdata);

if length(timeframe) == 2 % if timeframe specified, then only use values within that timeframe
    index = find(trial_zdata>= timeframe(1)*60);
    index = index(trial_zdata(index,1)<=timeframe(2)*60);
    trial_zdata = trial_zdata(index,:);
end
% now trial_zdata is transformed and only contain the timeframe values
% the following will operate on this segment of timestamp

%% remove very short isi. Because ts can be very short, that is inaccurate

isi = zeros(1, length(trial_zdata)-1);
trial_freq = zeros(1, length(trial_zdata)-1);
for k = 1:length(trial_zdata)-1
    isi(k) = trial_zdata(k+1)-trial_zdata(k);
    trial_freq(k) = 1/isi(k);
end

trial_zdata2= trial_zdata(isi>0.02); % remove firing freq more than 50Hz, still the timestamps

trial_freq2 = zeros(1, length(trial_zdata2)-1); % now operate on the trial_zdata2
for k = 1:length(trial_zdata2)-1
    isi(k) = trial_zdata2(k+1)-trial_zdata2(k);
    trial_freq2(k) = 1/isi(k);
end

trial_freq2(length(trial_zdata2)) = mean(trial_freq2); % pad the last value to     
 
trial_zdata3 = [trial_zdata2 trial_freq2'];

zscore = (trial_zdata3(:,2)-bs_mn_z)./bs_std_z;
trial_zdata4 = [trial_zdata3 zscore]; % this now contains the Z score in last column, first column is ts

%% map to behavior file
% b_ts = trial_zdata4(:,1);
% 
% t2 = zeros(length(b_ts),3); % holder for extracted behav file triplets based on the timestamps happening during the selected time.
% k2 = zeros(length(b_ts),length(a_behav3));
% kk2 = zeros(1,length(b_ts));
% 
% for ii = 1:length(b_ts)
%     k2(ii,:) = b_ts(ii) > a_behav3(:,1)';
%     kk2(ii) = strfind(k2(ii,:),[1 0]);
%     t2(ii,:) = a_behav3(kk2(ii),:);
% end
sel_z = trial_zdata4(:,1);

ind = zeros(1, length(sel_z));

for ii = 1:length(sel_z)
    ind(ii) = s_sort(sel_z(ii), a_behav3(:,1));
end

a_behav7 = zeros(length(sel_z), size(a_behav3, 2));
for jj = 1:length(sel_z)
    a_behav7(jj,:) = a_behav3(ind(jj), :);
end


a_behav8 = [a_behav7 trial_zdata4(:,3)];

unique(a_behav7, 'rows');


% t3 = [t2, trial_zdata4(:,3)];


figure(7)
plot(a_behav3(:,2),a_behav3(:,3),'k');
hold on;
tx3 = a_behav8(:,2); ty3 = a_behav8(:,3); tz3 = a_behav8(:,5);
scatter(tx3(1:zscoreThinner:end), ty3(1:zscoreThinner:end),25, tz3(1:zscoreThinner:end), 'filled', 's'); colormap jet; caxis([-1 4]); %colormap(flipud(jet)); %caxis([-1 4]);

% scatter(tx3, ty3, 25, tz3, 'filled', 's'); colormap jet; caxis([-1 3]);
title('Z score distribution along moving track'); axis square

a_behav9 = sortrows(a_behav8, [4 1]); 
zmat_iz = a_behav9(a_behav9(:,4) ==1, :);
zmat_niz = a_behav9(a_behav9(:,4) ==0, :);

%%
figure(8)
plot(a_behav3(:,2),a_behav3(:,3),'Color', [.75 .75 .75]);
hold on;
% zscoreThinner = [1 3];
z_elevate = 1.1; %%%%%%%%%ADJUST Z-ELEVATE, OR ELSE TOO MUCH DEEPER NEGATIVE ZSCORES.
zx_iz = zmat_iz(:,2); zy_iz = zmat_iz(:,3); zz_iz = (zmat_iz(:,5)+z_elevate)*z_multiplier(1);
% zz_iz = zmat_iz(:,5)*5;  IF you want to have a zs outside IZ zone look
% larger
scatter(zx_iz(1:zscoreThinner(1):end), zy_iz(1:zscoreThinner(1):end),25, zz_iz(1:zscoreThinner(1):end), 'filled'); %colormap(flipud(jet)); %caxis([-1 4]);

zx_niz = zmat_niz(:,2); zy_niz = zmat_niz(:,3); zz_niz = zmat_niz(:,5)*z_multiplier(2);
% zz_niz = zmat_niz(:,5)/5; % IF you want to have a zs outside IZ zone look
% small
scatter(zx_niz(1:zscoreThinner(2):end), zy_niz(1:zscoreThinner(2):end),25, zz_niz(1:zscoreThinner(2):end), 'MarkerFaceColor', [1 1 1]); colormap jet; caxis([-1 5]);
% scatter(tx3, ty3, 25, tz3, 'filled', 's'); colormap jet; caxis([-1 3]);

title('Z score distribution along moving track'); axis square

%%
figure(9)
plot(a_behav3(:,2),a_behav3(:,3),'Color', [.75 .75 .75]);
hold on;
% zscoreThinner = [1 3];
z_elevate = 1.1; %%%%%%%%% @@@@@ ADJUST Z-ELEVATE, OR ELSE TOO MUCH DEEPER NEGATIVE ZSCORES.@@@@@
zx_iz = zmat_iz(:,2); zy_iz = zmat_iz(:,3); zz_iz = (zmat_iz(:,5)+z_elevate)*z_multiplier(1);
% zz_iz = zmat_iz(:,5)*5;  IF you want to have a zs outside IZ zone look
% larger
scatter(zx_iz(1:zscoreThinner(1):end), zy_iz(1:zscoreThinner(1):end),25, zz_iz(1:zscoreThinner(1):end), 'filled'); %colormap(flipud(jet)); %caxis([-1 4]);

zx_niz = zmat_niz(:,2); zy_niz = zmat_niz(:,3); zz_niz = zmat_niz(:,5)*z_multiplier(2);
% zz_niz = zmat_niz(:,5)/5; % IF you want to have a zs outside IZ zone look
% small
scatter(zx_niz(1:zscoreThinner(2):end), zy_niz(1:zscoreThinner(2):end),15, zz_niz(1:zscoreThinner(2):end), 'filled', 'MarkerFaceColor', [.5 .5 .5]); 
colormap jet; caxis([-1 5]);
% scatter(tx3, ty3, 25, tz3, 'filled', 's'); colormap jet; caxis([-1 3]);

title('Z score distribution along moving track'); axis square

autoArrangeFigures(0,0,2)
% scatter(p(1:num:dim,2),p(1:num:dim,3),25,p(1:num:dim,4),'filled'); colormap(flipud(jet)); caxis([0,maxi])
    

