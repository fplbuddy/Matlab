fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions/';
addpath(fpath)
addpath('/Users/philipwinchester/Dropbox/Matlab/Normal/Functions')
TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)
FS = 20;
% Loading in the old data
dpath = '/Volumes/Samsung_T5/OldData/masternew.mat';
load(dpath);
%%
AR = "AR_2";
type_list = ["OneOne400" "OneOne320" "OneOne256" "OneOne152" "OneOne128" "OneOne200" "OneOne172" "OneOne100" "OneOne88" "OneOne64"];
PrS_list = [];
for i = 1:length(type_list)
    type = type_list(i);
    try
    PrS_list_inst = string(fields(Data.(AR).(type)));
    PrS_list = [PrS_list; PrS_list_inst];
    catch
    end
end
PrS_list = RemoveStringDuplicates(PrS_list);
[PrS_list, ~]= OrderPrS_list(PrS_list); % Now we have all of our PrS;

rem = [];
for i=1:length(PrS_list)
   PrS =  PrS_list(i);
   Pr = PrStoPr(PrS);
   if Pr < 100
       rem = [i rem];
   end   
end
PrS_list(rem) = [];

BL_list = [];
Pr_list = [];
for i=1:length(PrS_list)
    i
    PrS = PrS_list(i);
    Pr = PrStoPr(PrS);
    for j=1:length(type_list)
        type = type_list(j);
        Ra = 0;
        try
            A = GetFullM(Data, PrS, AR,type);
            sigmas = A(2,:);
            Ra_list =  A(1,:);
            I = find(sigmas > 0, 1);
            Ra = Ra_list(I);
        catch
        end
        if Ra ~= 0
            break
        end       
    end
    RaS = RatoRaS(Ra);
    N = convertStringsToChars(type); N = N(7:end); N = str2num(N);
    Zonal = MakeZonalTT(Data, AR, type,Pr,Ra,2,N);
    [~,locs] = findpeaks(abs(Zonal));
    m = mean([min(locs) length(Zonal)-max(locs)+1]);
    LOOS = 1/length(Zonal);   % length of one square
    BL = LOOS/2 + (m-1)*LOOS;
    BL_list = [BL BL_list];
    Pr_list = [Pr Pr_list];
end

figure('Renderer', 'painters', 'Position', [5 5 540 200])
loglog(Pr_list, BL_list,'*'), hold on
ax = gca;
ax.XAxis.FontSize = FS;
ax.YAxis.FontSize = FS;
x0 = 3e2;
y0 = 0.07;
x1 = 1e5;
A = y0*x0^(1/5);
y1 = A*x1^(-1/5);
plot([x0 x1], [y0 y1], 'red--')
xlabel('Pr', 'Fontsize', FS)
ylabel('BL/$(\pi d)$', 'Fontsize', FS)
text(3e2,0.04,'$BL \propto Pr^{-1/5}$', 'FontSize', FS, 'Color', 'red')

%% example plot

Zonal = MakeZonalTT(Data, AR, "OneOne400",1e5,1e7,2,400);
y = linspace(1/(2*400*2), 1-1/(2*400*2), 2*400);
plot(Zonal,y)
ax = gca;
ax.XAxis.FontSize = FS;
ax.YAxis.FontSize = FS;
title('$\theta, Pr = 10^5, Ra = 10^7$','FontSize',FS)
ylabel('$y/(\pi d)$','FontSize',FS)
