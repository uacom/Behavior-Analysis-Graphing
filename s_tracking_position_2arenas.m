function [] = s_tracking_position_2arenas(filename,timeframe,interval_num,maxi,four) 
%% This function is used to track mouse postion and calculate the
% instaneous speed from ethovision output excel file. 
% Filename: rawdata recording by ethovision software to track mouse's
% position; 
% timeframe = vector, timeframe in minutes for analysis, e.g. [1,3]. write blank [] if
% whole interval used

% four: write 1 if four arenas, 0 if two arenas

% e.g. s_tracking_position_2arenas('filepath', [], 15, 0.15, 1);
% ^ this will use the whole trace and calculate based on four arenas, the
% last argument '1' means 4 arena, such as 4 open field data
%% If the behavior file is coupled with in vivo recording timestamps, use the mea-behv_rec.m 
%% USE this for one, two, or four arenas. 
% 04/2020 comment: e.g. 
%% 09072020 this works:
% s_tracking_position_2arenas('Raw data-three chamber SI 01262019-Trial     1', [1,3], 15, 0.15, 0);
% s_tracking_position_2arenas('Raw data-Handong12192018-Trial     1.xlsx', [3, 5], 15, 0.15, 0);
% s_tracking_position_2arenas('Raw data-Handong12192018-Trial     1.xlsx', [], 15, 0.15, 0);
% s_tracking_position_2arenas('G:\dDrive_HP_Feb 2017on\DATA\By Person\X Ma\Ethovision behavior\One area OF SI\Raw data-QIULAB 3 chamber SI 12 mins.xlsx', [], 15, 0.15, 0);
% s_tracking_position_2arenas('open field one arena 12 min.xlsx', [], 15, 0.15,4);
% s_tracking_position_2arenas('open field one arena 12 min.xlsx', [1-3], 15, 0.15,4);

% can use this one for only one arena test, just ignore the error that
% cannot read 'Track-Areana 2-Subject 1' not found. 

% autoArrangeFigures(0, 0, 2)

% ^ this will calculate based on the interval 1 to 3 (or 3 to 5) minutes, and for two
% arenas, the last argument '0' means 2 arena, such as 2 arean three
% chamber SI tests

%% 09072020 this works:
% s_tracking_position_2arenas('Raw data-three chamber SI 01262019-Trial     1', [1,3], 15, 0.15, 0);
% use this for 2 arena three chamber SI tests, with data block (e.g. from
% 1-3 min) selection. use [] instead [1 3] to analyse full length data
%% 09072020 this works:
% filepath = 'Raw data-three chamber SI 01262019-Trial     1';
% s_tracking_position_2arenas(filepath, [], 15, 0.15, 0);


% e.g. s_tracking_position_2arenas_tf('filepath', [2,5], 15, 0.15, 0);
% first argument filepath, second argument is timeframe in minutes, [] if whole trace.
% Third argument is density of 'meatballs' (15 means every 15 seconds has
% one meatball. 4th argument, maxi, is the max velocity displayed in the
% colorbar, and last argument, four, is 1 if 4 arenas, and 0 if two arenas

%% use this one for three chamber social interaction (15), T maze (30), Y maze (30), marlbe burrying (15),
% for EPM, use the one s_tracking_position_EPM_2areans.m
 
% for 2 arenas, 
% s_tracking_position_2arenas('G:\dDrive_HP_Feb 2017on\DATA\By Person\S Qiu\Ethiovision\SQ behav trials\T maze 01262019\Export Files\Raw data-T maze 01262019-Trial     1.xlsx', 30, 0.15);

%%
% for GH three chamber interaction
%  
% s_tracking_position_2arenas('G:\Qiu lab\data\behaviour\02092019 3 chamber -GH\Export Files\Raw data-02092019 3 chamber -GH-Trial     1.xlsx', 15, 0.15);

%%

% interval_num: maybe we need to indicate the instanneous speed every
% 'interval_num'; otherwise data points maybe too dense in the plot. if we
% need plot one data point every 5 frame, then this is '5'.
% max: max number of the colorbar. this is for calculated speed. A lot of
% time mouse cannot exceed 0.5m/sec, thus you can set as '0.5'.
% the first row of result is time information; the second and third row is
% 'x' and 'y' postion; the last row is instaneous speed.
%SQ note 11092017: you need to list the excel file under current folder for
%the 3 chamber SI file collected on 10222017.

%SQ note 11092017: This also applies to T maze data collected on 10222017. 
%just list the file under current matlab folder.

%%% 
%%% s_tracking_position_2arenas('Raw data-Handong12192018-Trial     1.xlsx', [], 15, 0.15, 0);

%%% for T maze run this (for T maze acquisition it is 15 fps, as compared with 3 chamber SI at 25 fps): 
% 
% s_tracking_position_2arenas('G:\Ethiovision\SQ behav trials\T maze 01262019\Export Files\Raw data-T maze 01262019-Trial     1.xlsx', 30, 0.15);


%%% For Y maze, run this:
%%% s_tracking_position_2arenas('G:\Ethiovision\SQ behav trials\Y Maze alternation 01262019\Export Files\Raw data-Y Maze alternation 01262019-Trial     1.xlsx', 30, 0.15);



%%% For three chamber, run this:
%%% s_tracking_position_2arenas('G:\Ethiovision\SQ behav trials\three chamber SI 01262019\Export Files\Raw data-three chamber SI 01262019-Trial     3.xlsx', 15, 0.15);

%%% For open field, run this:
%%% s_tracking_position_2arenas('G:\Ethiovision\SQ behav trials\open field 4 arena 01242019\Export Files\Raw data-open field 4 arena 01242019-Trial     1.xlsx', 15, 0.15,4);
%% To debug

% filename = 'Raw data-Handong12192018-Trial     1.xlsx';
% timeframe = [1,3];
% interval_num = 15; maxi = 0.15, four = 0;
%%
aa=xlsread(filename,'Track-Arena 1-Subject 1');
a=aa(:,2:4);
% delete the row including 'NAN'  
a = a(all(a==a,2),:); 
a(any(a~=a,2),:) = []; 

if length(timeframe) == 2 % if timeframe specified, then only use values within that timeframe
    index = find(a(:,1) >= timeframe(1)*60);
    index = index(a(index,1)<=timeframe(2)*60);
    a = a(index,:);
end

num = interval_num;
plot(a(:,2),a(:,3),'k');
hold on;
dim=length(a(:,1))-1;
veloc=zeros(dim,1);
for i=1:dim
    veloc(i)=sqrt((a(i+1,2)-a(i,2)).^2+(a(i+1,3)-a(i,3)).^2)/((a(i+1,1)-a(i,1))*100);
end
p=[a(1:dim,:),veloc];
%result=p;
%scatter(p(:,1),p(:,2),30,p(:,3),'square','filled');
figure(1)
scatter(p(1:num:dim,2),p(1:num:dim,3),25,p(1:num:dim,4),'filled'); colormap(flipud(jet)); caxis([0,maxi])
% scatter(p(1:num:dim,2),p(1:num:dim,3),30,p(1:num:dim,4),'square','filled');
%
%
title('All Arenas');xlabel('X Position (cm)');ylabel('Y Position (cm)');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


bb=xlsread(filename,'Track-Arena 2-Subject 1');
b=bb(:,2:4);
% delete the row including 'NAN'  
b = b(all(b==b,2),:); 
b(any(b~=b,2),:) = []; 

if length(timeframe) == 2 % if timeframe specified, then only use values within that timeframe
    index = find(b(:,1) >= timeframe(1)*60);
    index = index(b(index,1)<=timeframe(2)*60);
    b = b(index,:);
end

num = interval_num;
plot(b(:,2),b(:,3),'k');
hold on;
dim=length(b(:,1))-1;
veloc=zeros(dim,1);
for i=1:dim
    veloc(i)=sqrt((b(i+1,2)-b(i,2)).^2+(b(i+1,3)-b(i,3)).^2)/((b(i+1,1)-b(i,1))*100);
end
p=[b(1:dim,:),veloc];
%result=p;
%scatter(p(:,1),p(:,2),30,p(:,3),'square','filled');
scatter(p(1:num:dim,2),p(1:num:dim,3),25,p(1:num:dim,4),'filled');
% scatter(p(1:num:dim,2),p(1:num:dim,3),30,p(1:num:dim,4),'square','filled');
%
%
xlabel('X Position (cm)');ylabel('Y Position (cm)');
colorbar;
colormap(flipud(jet))
caxis([0,maxi])

if four == 1 %if for 4 arenas, then do the same for the remaining two
    cc=xlsread(filename,'Track-Arena 3-Subject 1');
    c=cc(:,2:4);
    % delete the row including 'NAN'  
    c = c(all(c==c,2),:);
    c(any(c~=c,2),:) = []; 
    
    if length(timeframe) == 2 % if timeframe specified, then only use values within that timeframe
        index = find(c(:,1) >= timeframe(1)*60);
        index = index(c(index,1)<=timeframe(2)*60);
        c = c(index,:);
    end
    
    num = interval_num;
    plot(c(:,2),c(:,3),'k');
    hold on;
    dim=length(c(:,1))-1;
    veloc=zeros(dim,1);
    for i=1:dim
        veloc(i)=sqrt((c(i+1,2)-c(i,2)).^2+(c(i+1,3)-c(i,3)).^2)/((c(i+1,1)-c(i,1))*100);
    end
    p=[c(1:dim,:),veloc];
    scatter(p(1:num:dim,2),p(1:num:dim,3),25,p(1:num:dim,4),'filled');
    xlabel('X Position (cm)');ylabel('Y Position (cm)');
    colorbar;
    colormap(flipud(jet))
    caxis([0,maxi])
    
    
    dd=xlsread(filename,'Track-Arena 4-Subject 1');
    d=dd(:,2:4);
    % delete the row including 'NAN'  
    d = d(all(d==d,2),:); 
    d(any(d~=d,2),:) = []; 
    
    if length(timeframe) == 2 % if timeframe specified, then only use values within that timeframe
        index = find(d(:,1) >= timeframe(1)*60);
        index = index(d(index,1)<=timeframe(2)*60);
        d = d(index,:);
    end
    
    num = interval_num;
    plot(d(:,2),d(:,3),'k');
    hold on;
    dim=length(d(:,1))-1;
    veloc=zeros(dim,1);
    for i=1:dim
        veloc(i)=sqrt((d(i+1,2)-d(i,2)).^2+(d(i+1,3)-d(i,3)).^2)/((d(i+1,1)-d(i,1))*100);
    end
    p=[d(1:dim,:),veloc];
    scatter(p(1:num:dim,2),p(1:num:dim,3),25,p(1:num:dim,4),'filled');
    xlabel('X Position (cm)');ylabel('Y Position (cm)');
    colorbar;
    colormap(flipud(jet))
    caxis([0,maxi])
end
%%

aavgx = (min(a(:,2)) + max(a(:,2)))/2;
aavgy = (min(a(:,3)) + max(a(:,3)))/2;
bavgx = (min(b(:,2)) + max(b(:,2)))/2;
bavgy = (min(b(:,3)) + max(b(:,3)))/2;

if four == 1
    cavgx = (min(c(:,2)) + max(c(:,2)))/2;
    cavgy = (min(c(:,3)) + max(c(:,3)))/2;
    davgx = (min(d(:,2)) + max(d(:,2)))/2;
    davgy = (min(d(:,3)) + max(d(:,3)))/2;
    
    cnorm = zeros(length(c),3);
    cnorm(:,1) = c(:,1);
    cnorm(:,2) = (c(:,2)-cavgx);
    cnorm(:,3) = (c(:,3)-cavgy);

    dnorm = zeros(length(d),3);
    dnorm(:,1) = d(:,1);
    dnorm(:,2) = (d(:,2)-davgx);
    dnorm(:,3) = (d(:,3)-davgy);
end
anorm = zeros(length(a),3);
anorm(:,1) = a(:,1);
anorm(:,2) = (a(:,2)-aavgx);
anorm(:,3) = (a(:,3)-aavgy);

bnorm = zeros(length(b),3);
bnorm(:,1) = b(:,1);
bnorm(:,2) = (b(:,2)-bavgx);
bnorm(:,3) = (b(:,3)-bavgy);

figure(2)
% plot(anorm(:,2),anorm(:,3),'k');
plot(a(:,2),a(:,3),'k');
title('Arena 1');xlabel('X Position (cm)');ylabel('Y Position (cm)');

hold on;
dim=length(anorm(:,1))-1;
veloc=zeros(dim,1);
for i=1:dim
%     veloc(i)=sqrt((anorm(i+1,2)-anorm(i,2)).^2+(anorm(i+1,3)-anorm(i,3)).^2)/((anorm(i+1,1)-anorm(i,1))*100);
    veloc(i)=sqrt((a(i+1,2)-a(i,2)).^2+(a(i+1,3)-a(i,3)).^2)/((a(i+1,1)-a(i,1))*100);
end
% p=[anorm(1:dim,:),veloc];
p=[a(1:dim,:),veloc];
scatter(p(1:num:dim,2),p(1:num:dim,3),25,p(1:num:dim,4),'filled');
colorbar;
colormap(flipud(jet));
caxis([0,maxi])
% xlim([-35 35])% uncomment for the EPM data


figure(3)
% plot(bnorm(:,2),bnorm(:,3),'k');
plot(b(:,2),b(:,3),'k');
title('Arena 2');xlabel('X Position (cm)');ylabel('Y Position (cm)');
hold on;
dim=length(bnorm(:,1))-1;
veloc=zeros(dim,1);
for i=1:dim
%     veloc(i)=sqrt((bnorm(i+1,2)-bnorm(i,2)).^2+(bnorm(i+1,3)-bnorm(i,3)).^2)/((bnorm(i+1,1)-bnorm(i,1))*100);
    veloc(i)=sqrt((b(i+1,2)-b(i,2)).^2+(b(i+1,3)-b(i,3)).^2)/((b(i+1,1)-b(i,1))*100);
end
%p=[bnorm(1:dim,:),veloc];
p=[b(1:dim,:),veloc];
scatter(p(1:num:dim,2),p(1:num:dim,3),25,p(1:num:dim,4),'filled');
colorbar;
colormap(flipud(jet));
caxis([0,maxi]);
% xlim([-35 35]);
% uncomment for the EPM data: % xlim([-40 40])
 autoArrangeFigures(0, 0, 2);
if four == 1
    figure
    %plot(cnorm(:,2),cnorm(:,3),'k');
    plot(c(:,2),c(:,3),'k');
    title('Arena 3');xlabel('X Position (cm)');ylabel('Y Position (cm)');

    hold on;
    dim=length(cnorm(:,1))-1;
    veloc=zeros(dim,1);
    for i=1:dim
        % veloc(i)=sqrt((cnorm(i+1,2)-cnorm(i,2)).^2+(cnorm(i+1,3)-cnorm(i,3)).^2)/((cnorm(i+1,1)-cnorm(i,1))*100);
        veloc(i)=sqrt((c(i+1,2)-c(i,2)).^2+(c(i+1,3)-c(i,3)).^2)/((c(i+1,1)-c(i,1))*100);
    end
    %p=[cnorm(1:dim,:),veloc];
    p=[c(1:dim,:),veloc];
    scatter(p(1:num:dim,2),p(1:num:dim,3),25,p(1:num:dim,4),'filled');
    colorbar;
    colormap(flipud(jet));
    caxis([0,maxi])


    figure
    % plot(dnorm(:,2),dnorm(:,3),'k');
    plot(d(:,2),d(:,3),'k');
    title('Arena 4');xlabel('X Position (cm)');ylabel('Y Position (cm)');
    hold on;
    dim=length(dnorm(:,1))-1;
    veloc=zeros(dim,1);
    for i=1:dim
        % veloc(i)=sqrt((dnorm(i+1,2)-dnorm(i,2)).^2+(dnorm(i+1,3)-dnorm(i,3)).^2)/((dnorm(i+1,1)-dnorm(i,1))*100);
        veloc(i)=sqrt((d(i+1,2)-d(i,2)).^2+(d(i+1,3)-d(i,3)).^2)/((d(i+1,1)-d(i,1))*100);
    end
    %p=[dnorm(1:dim,:),veloc];
    p=[d(1:dim,:),veloc];
    scatter(p(1:num:dim,2),p(1:num:dim,3),25,p(1:num:dim,4),'filled');
    colorbar;
    colormap(flipud(jet));
    caxis([0,maxi])
    autoArrangeFigures(0, 0, 2);
end