run SetUp.m
%% Input
figure('Renderer', 'painters', 'Position', [5 5 600 400])
h = pi;
run SetUp.m
AR = 2;
Pr = 1;
run SomeInputStuff.m
Ra_list = string(fieldnames(AllData.(ARS).(PrS)));
%hej = subplot(3,2,[3 5], 'Position', [0.1300 0.1100 0.3347 0.47]); % This syntax will not be supported in future release
RaMin = 9e3;
%Rem = [6.3e6 6.8e6 3e6 5e6 5.5e6];
%Rem = [3e6];
%Rem = [3.5e6 7.9e6 3.6e6 4.1e6 6.3e6 6.8e6 5.6e6];
Rem = [];
RaNonShearing = []; RaShearing = []; RaReversals = [];
MeanNonShearing = []; MeanShearing = []; MeanReversals = [];
errNonShearing = []; errShearing = []; errReversals = [];
for i=1:length(Ra_list)
    RaS = Ra_list(i);
    if isfield(AllData.(ARS).(PrS).(RaS),'ICT') && AllData.(ARS).(PrS).(RaS).Ra >= RaMin && ~ismember(AllData.(ARS).(PrS).(RaS).Ra, Rem)
        urms = AllData.(ARS).(PrS).(RaS).urms;
        meaninst = 2*AllData.(ARS).(PrS).(RaS).calcs.mean/(h*urms);
        Rainst = AllData.(ARS).(PrS).(RaS).Ra;
        errinst = 2*AllData.(ARS).(PrS).(RaS).calcs.sd/(h*urms);
        %errinst = AllData.(ARS).(PrS).(RaS).maxval/(h*urms) - abs(meaninst);
        PosShear = not(sum(size(AllData.(ARS).(PrS).(RaS).calcs.pos{1})) == 1);
        NegShear = not(sum(size(AllData.(ARS).(PrS).(RaS).calcs.neg{1})) == 1);
        Zero = not(sum(size(AllData.(ARS).(PrS).(RaS).calcs.zero{1})) == 1);
        
        if (PosShear && NegShear)
            % We are reversing
            RaReversals = [RaReversals Rainst];
            errReversals = [errReversals errinst];
            MeanReversals = [MeanReversals meaninst];
        elseif (not(PosShear) && not(NegShear))
            % Not shearing or reversing
            RaNonShearing = [RaNonShearing Rainst];
            errNonShearing = [errNonShearing errinst];
            MeanNonShearing = [MeanNonShearing meaninst];
        elseif (NegShear && not(PosShear) && not(Zero) || PosShear && not(NegShear) && not(Zero))
            % Shearing
            RaShearing = [RaShearing Rainst Rainst];
            errShearing = [errShearing errinst errinst];
            MeanShearing = [MeanShearing meaninst -meaninst];
        end
    end
end
h1 = errorbar(RaNonShearing,abs(MeanNonShearing),errNonShearing,'bo', 'Displayname', 'Non-Shearing'); hold on
set(h1, 'markerfacecolor', get(h1, 'color')); % Use same color to fill in markers
h1 = errorbar(RaReversals,abs(MeanReversals),errReversals, 'Color', [0 0.5 0] , 'LineStyle', 'none', 'Marker', '*', 'Displayname', 'Reversals');
set(h1, 'markerfacecolor', get(h1, 'color')); % Use same color to fill in markers
h1 = errorbar(RaShearing,MeanShearing,errShearing,'r^', 'Displayname', 'Shearing');
set(h1, 'markerfacecolor', get(h1, 'color')); % Use same color to fill in markers
%legend('Location', 'northwest', 'FontSize', lgndFS); legend('boxoff')
set(gca, 'XScale', 'log')
ylabel('$ \langle \widehat \psi_{0,1} \rangle_t/(\pi du_{rms})$','FontSize', LabelFS)
xlabel('Ra','FontSize', LabelFS)
xlim([1e4 1e8])
%text(1e6,0.05,'Pr $=1$', 'FontSize', TitleFS)
%text(1.23e6,-0.05,'$\Gamma =2$', 'FontSize', TitleFS)
title('Pr $=1$, $\Gamma =2$','FontSize',TitleFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;

%% Add the resue
Ralist = ["Ra_2e4" "Ra_3e4" "Ra_6e4"];
EBF = 1;
xlowerlist = [5000 1000 5000];
% Do for 64x64 res
for i=1:length(Ralist)
    Ra = convertStringsToChars(Ralist(i));
    % get urms
    kenergy = importdata(['/Volumes/Samsung_T5/Residue/64x64/Pr_1/' Ra  '/Checks/kenergy.txt']);
    Ex = kenergy(:,6);
    Ey = kenergy(:,5);
    t = kenergy(:,1);
    xlower = xlowerlist(i); 
    Ex = Ex(xlower:end);
    t = t(xlower:end);
    Ey = Ey(xlower:end);   
    urms = 2*Ex+2*Ey;
    urms = MyMeanEasy(urms,t); urms = urms^(1/2);
    % get rest
    kpsmodes1 = importdata(['/Volumes/Samsung_T5/Residue/64x64/Pr_1/' Ra '/Checks/kpsmodes1.txt' ]);
    RaV = RaStoRa(Ra);
    Signal = kpsmodes1(:,2); t = kpsmodes1(:,1);
    Signal = Signal(xlower:end); t = t(xlower:end);
    Y = 2*MyMeanEasy(Signal, t)/(h*urms);
    err = 2*std(Signal)/(h*urms);
    h1 = errorbar(RaV,abs(Y),err*EBF,'bo'); hold on
    set(h1, 'markerfacecolor', get(h1, 'color'))
end

%Ralist = ["Ra_1_5e4" "Ra_1_6e4" "Ra_1_7e4" "Ra_1_74e4" "Ra_1_743e4"];
Ralist = ["Ra_1_5e4"];
% Do for 128x128 res
for i=1:length(Ralist)
    Ra = convertStringsToChars(Ralist(i));
    % get urms
    kenergy = importdata(['/Volumes/Samsung_T5/Residue/128x128/Pr_1/' Ra  '/Checks/kenergy.txt']);
    Ex = kenergy(:,6);
    Ey = kenergy(:,5);
    t = kenergy(:,1);
    xlower = 1; % is 1 for all of these
    Ex = Ex(xlower:end);
    t = t(xlower:end);
    Ey = Ey(xlower:end);   
    urms = 2*Ex+2*Ey;
    urms = MyMeanEasy(urms,t); urms = urms^(1/2);
    % get rest
    kpsmodes1 = importdata(['/Volumes/Samsung_T5/Residue/128x128/Pr_1/' Ra '/Checks/kpsmodes1.txt' ]);
    RaV = RaStoRa(Ra);
    Signal = kpsmodes1(:,2); t = kpsmodes1(:,1);
    Signal = Signal(xlower:end); t = t(xlower:end);
    Y = 2*MyMeanEasy(Signal, t)/(h*urms);
    err = 2*std(Signal)/(h*urms);
    h1 = errorbar(RaV,abs(Y),err*EBF,'r^'); hold on
    set(h1, 'markerfacecolor', get(h1, 'color'))
    h1 = errorbar(RaV,-abs(Y),err*EBF,'r^'); hold on
    set(h1, 'markerfacecolor', get(h1, 'color'))
end
text(1.5e4, 0.28, '($1$)', 'FontSize', numFS, 'HorizontalAlignment', 'center');
text(1.33e5, 0.28, '($2$)', 'FontSize', numFS, 'HorizontalAlignment', 'center');
text(8e5, 0, '($3$)', 'FontSize', numFS,'HorizontalAlignment', 'center');
clearvars -except AllData Signal t urms

%% Time series
run SetUp.m
figure('Renderer', 'painters', 'Position', [5 5 600 400])

Signal = abs(Signal);
ExtraUpp = 0.01;
HA = -0.01;
TC = 0.01;
LR = 0.01;
hej = subplot(3,1,1);
hej.Position(4) = hej.Position(4) + HA;
hej.Position(2) = hej.Position(2) + ExtraUpp;
hej.Position(1) = hej.Position(1) + LR;
plot(t/(pi/urms),2*Signal/(pi*urms), 'red-')
m = 2*MyMeanEasy(Signal, t)/(pi*urms);
ylim([m-0.05, m+0.05])
xlim([1e4 1.02e4])
xticks([1e4 1.005e4 1.010e4 1.015e4 1.020e4])
xticklabels({'' '' '' '' '' '' '' ''})
title('Ra $= 1.5 \times 10^4$', 'Fontsize', TitleFS, 'FontWeight', 'bold')
ylabel({'$\widehat \psi_{0,1}$','$/(\pi du_{rms})$'}, 'Fontsize', LabelFS, 'FontWeight', 'bold')
%xlim([Signals.Ra_2e6.Time(1), Signals.Ra_2e6.Time(end)])
%hp4 = get(gca,'title').Position;
%set(get(gca,'title'),'Position', [hp4(1)-0.7 hp4(2) hp4(3)])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ax.Title.Position(2) = ax.Title.Position(2) - TC;
text(1e4+(200)/50, 0.43, '($1$)', 'FontSize', numFS);

hej = subplot(3,1,2);
hej.Position(4) = hej.Position(4) + HA;
hej.Position(2) = hej.Position(2) + 0.025 + ExtraUpp;;
hej.Position(1) = hej.Position(1) + LR;
Ra = 1.33e5;
Pr = 1;
AR = 2;
run SomeInputStuff.m
kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes1.txt']);
urms = AllData.(ARS).(PrS).(RaS).urms;
Signal = kpsmodes1(:,2)*2/(pi*urms);
t = kpsmodes1(:,1)/(pi/urms);
plot(t,-Signal, 'Color', 'r')
xlim([1e4 1.02e4])
%ylim([-0.5 0.5])
xticks([1e4 1.005e4 1.010e4 1.015e4 1.020e4])
xticklabels({'10000' '10050' '10100' '10150' '10200'})
title('Ra $= 1.33 \times 10^5$', 'Fontsize', TitleFS, 'FontWeight', 'bold')
ylabel({'$\widehat \psi_{0,1}$','$/(\pi du_{rms})$'}, 'Fontsize', LabelFS, 'FontWeight', 'bold')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ax.Title.Position(2) = ax.Title.Position(2) - TC*2;
text(1e4+(200)/50, 0.465, '($2$)', 'FontSize', numFS);

hej = subplot(3,1,3);
hej.Position(4) = hej.Position(4) + HA;
hej.Position(2) = hej.Position(2) + ExtraUpp;
hej.Position(1) = hej.Position(1) + LR;
Ra = 6e5;
Pr = 1;
AR = 2;
run SomeInputStuff.m
kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes1.txt']);
urms = AllData.(ARS).(PrS).(RaS).urms;
Signal = kpsmodes1(:,2)*2/(pi*urms);
t = kpsmodes1(:,1)/(pi/urms);
plot(t,Signal,  'Color', [0 0.5 0])
xlim([2000 10000])
%ylim([-10 10])
xticks([2e3 4e3 6e3 8e3 1e4])
xticklabels({'10000' '12000' '14000' '16000' '18000'})
%xticklabels({'' '' '' '' ''})
title('Ra $= 6 \times 10^5$', 'Fontsize', TitleFS, 'FontWeight', 'bold')
ylabel({'$\widehat \psi_{0,1}$','$/(\pi du_{rms})$'}, 'Fontsize', LabelFS, 'FontWeight', 'bold')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ax.Title.Position(2) = ax.Title.Position(2) - TC*20;
xlabel({'$t/(\pi d/u_{rms})$'},'Fontsize', LabelFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ax.Title.Position(2) = ax.Title.Position(2) - TC*(2/10);
ax.XLabel.Position(2) = ax.XLabel.Position(2) + 0.01;
text(2000+(10000-2000)/50, 0.7, '($3$)', 'FontSize', numFS);

