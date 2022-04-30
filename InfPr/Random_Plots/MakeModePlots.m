%% Input
AR = 2;
Pr = 30;
type = 'ps';
Mode = "Re(0,1)";

ModeC = convertStringsToChars(Mode);
[mrow,mcolumn,ModeAndTypeC] = WhichMode(Mode, type);
run SomeInputStuff.m
%% Order stuff
RaS_list = string(fieldnames(AllData.(ARS).(PrS)));
Ra_list = zeros(1,length(RaS_list));
for i=1:length(RaS_list)
    Ra_list(i) = AllData.(ARS).(PrS).(RaS_list(i)).Ra;
end
Ra_list = sort(Ra_list);
for i=1:length(RaS_list)
    RaS_list(i) = RatoRaS(Ra_list(i));
end
%% Make plots 
% Can maybe play around with the position argument, but will not bother now
dim = [1 2];
tdim = dim(1)*dim(2);
HMf = max([floor(length(Ra_list)/(tdim))*tdim 1]);
diml = [ceil(rem(length(Ra_list),HMf)/2)  2];
NOP = 8;
fignum = 0;
for i = 1:length(Ra_list) % Running through the plots
    p = rem(i,tdim); % Where we put the plot
    if p == 0
        p = tdim;
    end
    if p == 1 % start a new plot  
        if fignum > 0
            saveas(fig,['/Users/philipwinchester/Desktop/Work/Matlab/Images/' name], 'epsc')
        end     
        fignum = fignum + 1;
        if i > HMf
            dim = diml;
        end
        tdim = dim(1)*dim(2);
        depth = dim(1)*200;
        fig = figure('Renderer', 'painters', 'Position', [1 50 540 depth]);
        name = ['Pr' num2str(Pr) type 'Mode' ModeC(1:2) ModeC(4) ModeC(6) 'PlotNum' num2str(fignum) '.eps'];
    end
    subplot(dim(1),dim(2),p)
    RaS = RaS_list(i);
    modes = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/k' type 'modes' num2str(mrow) '.txt']);
    xlower = AllData.(ARS).(PrS).(RaS).ICT;
    s = modes(:,mcolumn+1);
    t = modes(:,1);
    s = s(xlower:end);
    t = t(xlower:end);
    hold on
    % Plotting Shearing
    shearing = [AllData.(ARS).(PrS).(RaS).calcs.pos AllData.(ARS).(PrS).(RaS).calcs.neg];
    for j=1:length(shearing)
       section = shearing{j};
       section(section > length(t)) = [];
       plot(t(section), s(section), 'r-')
    end    
    
    % Plottinh non shearing
    nonshearing = AllData.(ARS).(PrS).(RaS).calcs.zero;
    for j=1:length(nonshearing)       
       section = nonshearing{j};
       section(section > length(t)) = [];
       plot(t(section), s(section), 'b-')
    end
    if rem(p,2) % Checking if odd, if it is, we want the ylabel
        ylabel(['$' ModeAndTypeC '$'], 'FontSize',13)
    end
    q = rem(i,NOP);
    if i > (length(Ra_list)-2) || q == 0 || q == (NOP-1)
        xlabel('$t (s)$', 'FontSize',13)
    end
    hold off
    RaT = RatoRaT(Ra_list(i));
    title(['$Ra = ' RaT '$'], 'FontSize',14)
end
saveas(fig,['/Users/philipwinchester/Desktop/Work/Matlab/Images/' name], 'epsc')
clearvars -except AllData
