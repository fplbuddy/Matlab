%% Set up
TE = 'latex';
addpath('/Users/philipwinchester/Dropbox/Matlab/Normal/Functions');
addpath('/Users/philipwinchester/Dropbox/Matlab/Normal')
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions/';
addpath(fpath)
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/PrZero/Functions/';
addpath('/Users/philipwinchester/Dropbox/Matlab/JFM/Functions/')
addpath('/Users/philipwinchester/Dropbox/Matlab/WNL/Functions')
addpath(fpath)
addpath('/Users/philipwinchester/Dropbox/Matlab/NewSteadyState/Functions')
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)
%set(0,'defaultaxesfontsize',19,'defaultaxeslinewidth',.7, 'defaultlinelinewidth',.8,'defaultpatchlinewidth',.7, 'defaultlegendfontsize', 16)
TitleFS = 22;
LabelFS = 21;
lgndFS = 16;
numFS = 17;
MarkerS = 15;
figpath = '/Users/philipwinchester/Desktop/APS/';
addpath('/Users/philipwinchester/Dropbox/Matlab/ForFigs')