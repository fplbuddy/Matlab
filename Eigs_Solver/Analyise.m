%% Set up
TE = 'latex';
home = '/Users/philipwinchester/Dropbox/Matlab/Normal';
Functions = [home '/Functions'];
addpath(Functions);
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)
path = '/Volumes/Samsung_T5/EigComp/SmallAmp/';
RaS_list = dir(path);
RaS_list = string(extractfield(RaS_list,'name')); RaS_list = RaS_list(3:end);

%% Inport data
for i=1:length(RaS_list)
    RaS = convertStringsToChars(RaS_list(i));
    kpsmodes1 = importdata([path RaS '/Checks/kpsmodes1.txt']);
    kpsmodes2 = importdata([path RaS '/Checks/kpsmodes2.txt']);
    t = kpsmodes1(:,1);
    TwoOne = 2*kpsmodes1(:,4);
    OneTwo = 2*kpsmodes2(:,3);
    % Fig 1
    figure('Renderer', 'painters', 'Position', [5 5 540 200])
    subplot(1,2,1)
    semilogy(t(1:end*2/10), abs(TwoOne(1:end*2/10)))
    xlabel('$t$', 'FontSize',14)
    ylabel('$|\hat \psi_{2,1}|$', 'FontSize',14)
    xlim([t(1) t(round(length(t)*2/10))])
    subplot(1,2,2)
    plot(t(end*19/20:end), TwoOne(end*19/20:end))
    xlabel('$t$', 'FontSize',14)
    ylabel('$\hat \psi_{2,1}$', 'FontSize',14)
    xlim([t(round(length(t)*19/20)) t(length(t))])
    Ra = RaStoRa(RaS); RaT = RatoRaT(Ra);
    sgtitle(['$Ra = ' RaT '$'], 'FontSize', 15 )
    saveas(gcf,['/Users/philipwinchester/Desktop/Figs/' RaS 'TwoOne.eps'])

    % Fig 2
    figure('Renderer', 'painters', 'Position', [5 5 540 200])
    subplot(1,2,1)
    semilogy(t(1:end*2/10), abs(OneTwo(1:end*2/10)))
    xlabel('$t$', 'FontSize',14)
    ylabel('$|\hat \psi_{1,2}|$', 'FontSize',14)
    xlim([t(1) t(round(length(t)*2/10))])
    subplot(1,2,2)
    plot(t(end*19/20:end), OneTwo(end*19/20:end))
    xlim([t(round(length(t)*19/20)) t(length(t))])
    xlabel('$t$', 'FontSize',14)
    ylabel('$\hat \psi_{1,2}$', 'FontSize',14) 
    sgtitle(['$Ra = ' RaT '$'], 'FontSize', 15 )
    saveas(gcf,['/Users/philipwinchester/Desktop/Figs/' RaS 'OneTwo.eps'])
end


