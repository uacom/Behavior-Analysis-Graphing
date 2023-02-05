function [] = plotAbf(filepath,baseline,signal,channels,traces)
%% Graphs data from episodic stimulation experiments
%
% INPUT ARGUMENTS:
% filepath = path to the .abf file (ex. 'C:\Users\Shenfeng Qiu\Documents\MATLAB\episodic1ch.abf')
% baseline = vector of data points to use as the baseline pre-stimulus for digital
% removal of stimulation artifact. (ex. [0,200])
% signal = vector of data points to use as the signal post-stimulation (start,duration ex. [300,330])
% channels = number of channels (ex. 1)
% traces = array of traces to plot. To select all traces, write [].

%%% FOR DEBUGGING
%%% filepath = 'C:\Users\Shenfeng Qiu\Documents\MATLAB\episodic1ch.abf';
%%% filepath = 'C:\Users\Shenfeng Qiu\Documents\MATLAB\episodic2ch.abf';
%%% baseline = [0.1,29.6];
%%% signal = [34.0,50.0];
%%% channels = 2;
%%% fs = 10000;
%%% traces = [4:18];
%%

%%% 1 channel: 
%    plotAbf('E:\Users\sqiu\Documents\MATLAB\episodic1ch.abf',[0.1,29.6],[34.0,50.0],1,[]);
%%% 2 channels: 
%    plotAbf('E:\Users\sqiu\Documents\MATLAB\episodic2ch.abf',[0.1,29.6],[31.0,50.0],2,[]);
%%% Another test: 
%    plotAbf('E:\Users\sqiu\Documents\MATLAB\06418004.abf',[0.1,19.1],[23.7,52.0],1,[3,43:55]);

[data,si,~] = abf2load(filepath); % loads data
fs = si*100;
baseline = (fs/1000).*baseline; % converts from ms to data points
signal = (fs/1000).*signal; %              ^ ditto

data1 = data(:,1,:); % data 1 for first channel
data1 = squeeze(data1);

if traces
    for i=1:size(data1,2) % mark all columns which are not part of 'traces' as 0
        if ismember(i,traces) == 0
            data1(:,i) = 0;
        end
    end
    data1 = data1(:,any(data1)); % remove columns which are not part of the selected traces    
end


% the following block of code calculates mean and sem values for first channel
BL1 = data1(baseline(1):(baseline(1)+baseline(2)),:);
sig1 = data1(signal(1):(signal(1)+signal(2)),:);
data1 = [BL1;sig1];
mBL1 = mean(BL1,2);
semBL1 = buzsem(BL1,2);
msig1 = mean(sig1,2);
semsig1 = buzsem(sig1,2);
mcat1 = ([mBL1;msig1])';
semcat1 = ([semBL1;semsig1])';
CI1 = semcat1 .* 1.96;


if channels == 2 % for 2 channels, calculate everything for the second channel
    data2 = data(:,2,:);
    data2 = squeeze(data2);
    if traces        
            for i=1:size(data2,2) % mark all columns which are not part of 'traces' as 0
                if ismember(i,traces) == 0
                    data2(:,i) = 0;
                end
            end
        data2 = data2(:,any(data2)); % remove columns which are not part of the selected traces
    end
    BL2 = data2(baseline(1):(baseline(1)+baseline(2)),:);
    sig2 = data2(signal(1):(signal(1)+signal(2)),:);
    data2 = [BL2;sig2];
    mBL2 = mean(BL2,2);
    semBL2 = buzsem(BL2,2);
    msig2 = mean(sig2,2);
    semsig2 = buzsem(sig2,2);
    mcat2 = ([mBL2;msig2])';
    semcat2 = ([semBL2;semsig2])';
    CI2 = semcat2 .* 1.96;
end

% these next 3 lines are for creating x component of graph
duration = length(BL1) + length(sig1);
df = 1000/fs;
t = -length(BL1)*df+df:df:(duration-length(BL1))*df;
figure

if channels == 2 % makes the following code a subplot instead of the whole figure for 2 ch
    subplot(3,1,3)
end
%%%% Code for graphing with shaded SEM region %%%
t2 = [t,fliplr(t)];
inBetweenPos = [mcat1, fliplr(mcat1+CI1)];
fill(t2,inBetweenPos,[1 0.7 0.7]);
hold on;
inBetweenNeg = [mcat1-CI1, fliplr(mcat1)];
fill(t2,inBetweenNeg,[1 0.7 0.7]);
hold on

plot(t,mcat1+CI1,'color',[1 0.7 0.7])
hold on
plot(t,mcat1-CI1,'color',[1 0.7 0.7])
hold on
plot(t,mcat1,'r','LineWidth',2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if channels == 2 % repeat graphing process for 2 channels
    hold on
    
    t2 = [t,fliplr(t)];
    inBetweenPos = [mcat2, fliplr(mcat2+CI2)];
    fill(t2,inBetweenPos,[0.7 0.7 1]);
    hold on;
    inBetweenNeg = [mcat2-CI2, fliplr(mcat2)];
    fill(t2,inBetweenNeg,[0.7 0.7 1]);
    hold on

    plot(t,mcat2+CI2,'color',[0.7 0.7 1])
    hold on
    plot(t,mcat2-CI2,'color',[0.7 0.7 1])
    hold on
    plot(t,mcat2,'b','LineWidth',2)
end

xlabel('Perievent time (ms)')
ylabel('Voltage (V)')
title('1-ch episodic stimulation with 95% CI')
if channels == 2 % repeat of previous code, but creates two additional subplots for each channel
    title('2-ch episodic stimulation - both channels with 95% CI')
    
    subplot(3,1,1)
    t2 = [t,fliplr(t)];
    inBetweenPos = [mcat1, fliplr(mcat1+CI1)];
    fill(t2,inBetweenPos,[1 0.7 0.7]);
    hold on;
    inBetweenNeg = [mcat1-CI1, fliplr(mcat1)];
    fill(t2,inBetweenNeg,[1 0.7 0.7]);
    hold on

    plot(t,mcat1+CI1,'color',[1 0.7 0.7])
    hold on
    plot(t,mcat1-CI1,'color',[1 0.7 0.7])
    hold on
    plot(t,mcat1,'r','LineWidth',2)
    xlabel('Perievent time (ms)')
    ylabel('Voltage (V)')
    title('2-ch episodic stimulation - channel 1 with 95% CI')
    
    subplot(3,1,2)
    t2 = [t,fliplr(t)];
    inBetweenPos = [mcat2, fliplr(mcat2+CI2)];
    fill(t2,inBetweenPos,[0.7 0.7 1]);
    hold on;
    inBetweenNeg = [mcat2-CI2, fliplr(mcat2)];
    fill(t2,inBetweenNeg,[0.7 0.7 1]);
    hold on

    plot(t,mcat2+CI2,'color',[0.7 0.7 1])
    hold on
    plot(t,mcat2-CI2,'color',[0.7 0.7 1])
    hold on
    plot(t,mcat2,'b','LineWidth',2)    
    xlabel('Perievent time (ms)')
    ylabel('Voltage (V)')
    title('2-ch episodic stimulation - channel 2 with 95% CI')
end

figure % figure of plot(s) with raw data as faint gray lines
if channels == 2
    subplot(3,1,3)
    data2 = data2';
end
plot(t,mcat1,'r','LineWidth',2)
data1 = data1';


hold on
for i=1:size(data1,1)
    plot(t,data1(i,:),'Color',[0.7 0.7 0.7],'LineStyle',':','LineWidth',.01)
    hold on
end
xlabel('Perievent time (ms)')
ylabel('Voltage (V)')
title('1-ch episodic stimulation with raw traces')
if channels == 2
    hold on
    plot(t,mcat2,'b','LineWidth',2)
    hold on
    for i=1:size(data1,1)
        plot(t,data2(i,:),'Color',[0.7 0.7 0.7],'LineStyle',':','LineWidth',.01)
        hold on
    end
    title('2-ch episodic stimulation with raw traces')
    
    subplot(3,1,1)
    plot(t,mcat1,'r','LineWidth',2)
    hold on
    for i=1:size(data1,1)
        plot(t,data1(i,:),'Color',[0.7 0.7 0.7],'LineStyle',':','LineWidth',.01)
        hold on
    end
    xlabel('Perievent time (ms)')
    ylabel('Voltage (V)')
    title('2-ch episodic stimulation - channel 1 with raw traces')
    
    subplot(3,1,2)
    
    plot(t,mcat2,'b','LineWidth',2)
    hold on
    for i=1:size(data1,1)
        plot(t,data2(i,:),'Color',[0.7 0.7 0.7],'LineStyle',':','LineWidth',.01)
        hold on
    end
    xlabel('Perievent time (ms)')
    ylabel('Voltage (V)')
    title('2-ch episodic stimulation - channel 2 with raw traces')
end