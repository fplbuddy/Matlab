addpath('/Users/philipwinchester/Dropbox/Matlab/GeneralFuncs') % loading general functions
% some constants
numFS = 15;
labelFS = 18;
lw = 1;
MS = 30;
TE = 'latex';
%% Setting up font and figure sizes sizes in groot
reset(groot);
set(groot,'DefaultTextHorizontalAlignment','center'); 
set(groot,'DefaultTextVerticalAlignment','middle'); 
set(groot,'DefaultTextFontSize',numFS); 
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)
set(groot,'DefaultaxesFontSize',numFS)
set(groot,'DefaultAxesLabelFontSizeMultiplier',labelFS/numFS)
set(groot,'DefaultAxesTitleFontSizeMultiplier',labelFS/numFS)
set(groot,'DefaultColorbarFontSize',numFS)
set(groot,'DefaultLineLineWidth',lw)
set(groot,'DefaultFigurePosition',[5 5 600 300])
set(groot,'DefaultLegendlocation','best')
set(groot,'DefaultLineMarkerSize',MS)
set(groot,'DefaultErrorbarCapSize',15) 
set(groot, 'DefaultfigureRenderer', 'Painters'); % makes sure eps are exported properely

%% make fig save path
c = clock;
months = ["Jan" "Feb" "Mar" "Apr" "May" "Jun" "Jul" "Aug" "Sep" "Oct" "Nov" "Dec"];
m = c(2);
m = months(m);
y = c(1);
figpath = ['/Users/philipwinchester/Desktop/Figures/' convertStringsToChars(m) '_' num2str(y) '/'];