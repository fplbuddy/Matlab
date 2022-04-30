TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)
numFS = 15;
labelFS = 18;
path = '/Volumes/Samsung_T5/';
c = clock;
months = ["Jan" "Feb" "Mar" "Apr" "May" "Jun" "Jul" "Aug" "Sep" "Oct" "Nov" "Dec"];
m = c(2);
m = months(m);
y = c(1);
figpath = ['/Users/philipwinchester/Desktop/Figures/' convertStringsToChars(m) '_' num2str(y) '/'];