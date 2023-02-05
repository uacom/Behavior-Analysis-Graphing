function [] = s_tracking_position_MWM_4arenas(filename,interval_num,maxi,varargin) 
%% This function is used to track mouse postion and calculate the
% instaneous speed from ethovision output excel file. 
% You need to navigate and make the excile files in the current Matlab
% folder. 
% Filename: rawdata recording by ethovision software to track mouse's
% position; 
% for instance 'Raw data-3 Chamber SI test 10222017-Trial     1' file
% should be in current working folder

% Note: for 4 arenas, add an extra argument. e.g. s_tracking_position_2arenas('filepath', 15, 0.15, 4);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% THIS WORKS:
% SQ water maze data trial 4 arenas
% filepath = 'F:\dDrive_HP_Feb 2017on\DATA\By Person\Jing Wei\Morris Water Maze\10-24-2018 MWM 1st training\Export Files\Raw data-10-24-2018 MWM-2-Trial    16';
% s_tracking_position_MWM_4arenas(filepath, 15, 0.15,4);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
% interval_num: maybe we need to indicate the instanneous speed every
% 'interval_num'; otherwise data points maybe too dense in the plot. if we
% need plot one data point every 5 frame, then this is '5'.
% max: max number of the colorbar. this is for calculated speed. A lot of
% time mouse cannot exceed 0.5m/sec, thus you can set as '0.5'.
% the first row of result is time information; the second and third row is
% 'x' and 'y' postion; the last row is instaneous speed.


%%
aa=xlsread(filename,'Track-Arena 1-Subject 1');
a=aa(:,2:4);
% delete the row including 'NAN'  
a = a(all(a==a,2),:); 
a(any(a~=a,2),:) = []; 
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
scatter(p(1:num:dim,2),p(1:num:dim,3),25,p(1:num:dim,4),'filled'); colormap(flipud(jet));
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
scatter(p(1:num:dim,2),p(1:num:dim,3),35,p(1:num:dim,4),'filled');
% scatter(p(1:num:dim,2),p(1:num:dim,3),30,p(1:num:dim,4),'square','filled');
%
%
xlabel('X Position (cm)');ylabel('Y Position (cm)');
colorbar;
colormap(flipud(jet))
caxis([0,maxi]);


if nargin == 4 %if for 4 arenas, then do the same for the remaining two
    cc=xlsread(filename,'Track-Arena 3-Subject 1');
    c=cc(:,2:4);
    % delete the row including 'NAN'  
    c = c(all(c==c,2),:);
    c(any(c~=c,2),:) = []; 
    
    num = interval_num;
    plot(c(:,2),c(:,3),'k');
    hold on;
    dim=length(c(:,1))-1;
    veloc=zeros(dim,1);
    for i=1:dim
        veloc(i)=sqrt((c(i+1,2)-c(i,2)).^2+(c(i+1,3)-c(i,3)).^2)/((c(i+1,1)-c(i,1))*100);
    end
    p=[c(1:dim,:),veloc];
    scatter(p(1:num:dim,2),p(1:num:dim,3),35,p(1:num:dim,4),'filled');
    xlabel('X Position (cm)');ylabel('Y Position (cm)');
    colorbar;
    colormap(flipud(jet))
    caxis([0,maxi]);
   
    
    
    dd=xlsread(filename,'Track-Arena 4-Subject 1');
    d=dd(:,2:4);
    % delete the row including 'NAN'  
    d = d(all(d==d,2),:); 
    d(any(d~=d,2),:) = []; 
    
    num = interval_num;
    plot(d(:,2),d(:,3),'k');
    hold on;
    dim=length(d(:,1))-1;
    veloc=zeros(dim,1);
    for i=1:dim
        veloc(i)=sqrt((d(i+1,2)-d(i,2)).^2+(d(i+1,3)-d(i,3)).^2)/((d(i+1,1)-d(i,1))*100);
    end
    p=[d(1:dim,:),veloc];
    scatter(p(1:num:dim,2),p(1:num:dim,3),35,p(1:num:dim,4),'filled');
    xlabel('X Position (cm)');ylabel('Y Position (cm)');
    colorbar;
    colormap(flipud(jet))
    caxis([0,maxi]);
    
end
%%

aavgx = (min(a(:,2)) + max(a(:,2)))/2;
aavgy = (min(a(:,3)) + max(a(:,3)))/2;
bavgx = (min(b(:,2)) + max(b(:,2)))/2;
bavgy = (min(b(:,3)) + max(b(:,3)))/2;

if nargin == 4
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

figure
plot(anorm(:,2),anorm(:,3),'k');
title('Arena 1');xlabel('X Position (cm)');ylabel('Y Position (cm)');

hold on;
dim=length(anorm(:,1))-1;
veloc=zeros(dim,1);
for i=1:dim
    veloc(i)=sqrt((anorm(i+1,2)-anorm(i,2)).^2+(anorm(i+1,3)-anorm(i,3)).^2)/((anorm(i+1,1)-anorm(i,1))*100);
end
p=[anorm(1:dim,:),veloc];
scatter(p(1:num:dim,2),p(1:num:dim,3),35,p(1:num:dim,4),'filled');
colorbar;
colormap(flipud(jet));
caxis([0,maxi]);
xlim([-30 30]); ylim([-30 30]);


figure
plot(bnorm(:,2),bnorm(:,3),'k');
title('Arena 2');xlabel('X Position (cm)');ylabel('Y Position (cm)');
hold on;
dim=length(bnorm(:,1))-1;
veloc=zeros(dim,1);
for i=1:dim
    veloc(i)=sqrt((bnorm(i+1,2)-bnorm(i,2)).^2+(bnorm(i+1,3)-bnorm(i,3)).^2)/((bnorm(i+1,1)-bnorm(i,1))*100);
end
p=[bnorm(1:dim,:),veloc];
scatter(p(1:num:dim,2),p(1:num:dim,3),35,p(1:num:dim,4),'filled');
colorbar;
colormap(flipud(jet));
caxis([0,maxi]);
xlim([-30 30]); ylim([-30 30]);

if nargin == 4
    figure
    plot(cnorm(:,2),cnorm(:,3),'k');
    title('Arena 3');xlabel('X Position (cm)');ylabel('Y Position (cm)');

    hold on;
    dim=length(cnorm(:,1))-1;
    veloc=zeros(dim,1);
    for i=1:dim
        veloc(i)=sqrt((cnorm(i+1,2)-cnorm(i,2)).^2+(cnorm(i+1,3)-cnorm(i,3)).^2)/((cnorm(i+1,1)-cnorm(i,1))*100);
    end
    p=[cnorm(1:dim,:),veloc];
    scatter(p(1:num:dim,2),p(1:num:dim,3),35,p(1:num:dim,4),'filled');
    colorbar;
    colormap(flipud(jet));
    caxis([0,maxi]); 
    xlim([-30 30]); ylim([-30 30]);


    figure
    plot(dnorm(:,2),dnorm(:,3),'k');
    title('Arena 4');xlabel('X Position (cm)');ylabel('Y Position (cm)');
    hold on;
    dim=length(dnorm(:,1))-1;
    veloc=zeros(dim,1);
    for i=1:dim
        veloc(i)=sqrt((dnorm(i+1,2)-dnorm(i,2)).^2+(dnorm(i+1,3)-dnorm(i,3)).^2)/((dnorm(i+1,1)-dnorm(i,1))*100);
    end
    p=[dnorm(1:dim,:),veloc];
    scatter(p(1:num:dim,2),p(1:num:dim,3),35,p(1:num:dim,4),'filled');
    colorbar;
    colormap(flipud(jet));
    caxis([0,maxi])
    xlim([-30 30]); ylim([-30 30]);
end