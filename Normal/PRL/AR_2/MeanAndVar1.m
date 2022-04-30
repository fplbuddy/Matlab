run SetUp.m
%% Input
h = pi;
AR = 1;
Pr = 30;
run SomeInputStuff.m
Ra_list = string(fieldnames(AllData.(ARS).(PrS)));
figure('Renderer', 'painters', 'Position', [5 5 600 400])
hej = subplot(3,2,[4, 6], 'position', [0.5703 0.1100 0.3347 0.47]); % This syntax will not be supported in future release
RaMin = 6e3;
RaNonShearing = []; RaShearing = []; RaReversals = [];
MeanNonShearing = []; MeanShearing = []; MeanReversals = [];
errNonShearing = []; errShearing = []; errReversals = [];
for i=1:length(Ra_list)
    RaS = Ra_list(i);
    if isfield(AllData.(ARS).(PrS).(RaS),'ICT') && AllData.(ARS).(PrS).(RaS).Ra >= RaMin
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
            RaShearing = [RaShearing Rainst Rainst]; % Double as we want both branches
            errShearing = [errShearing errinst errinst];
            MeanShearing = [MeanShearing meaninst -meaninst];
        end
    end
end
h1 = errorbar(RaNonShearing,abs(MeanNonShearing),errNonShearing,'bo', 'Displayname', 'Non-Shearing'); hold on
set(h1, 'markerfacecolor', get(h1, 'color')); % Use same color to fill in markers
h1 = errorbar(RaReversals,abs(MeanReversals),errReversals,'Color', [0 0.5 0] , 'LineStyle', 'none', 'Marker', '*', 'Displayname', 'Reversals');
set(h1, 'markerfacecolor', get(h1, 'color')); % Use same color to fill in markers
h1 = errorbar(RaShearing,MeanShearing,errShearing,'r^', 'Displayname', 'Shearing');
set(h1, 'markerfacecolor', get(h1, 'color')); % Use same color to fill in markers
hej = legend('Location', 'northwest', 'Position', [0.5799 - 0.025 0.4132 0.2193 0.1502], 'FontSize', lgndFS); legend('boxoff')
set(gca, 'XScale', 'log')
%ylabel('$\mid \langle \hat \psi_{0,1} \rangle \mid$','FontSize', 14)
xlabel('Ra','FontSize', LabelFS)
title('$\Gamma =1$, (c)', 'Fontsize', TitleFS)
hp4 = get(gca,'title').Position;
set(get(gca,'title'),'Position', [9e4 -0.4  hp4(3)])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
hold off

%% Make box
% axes('Position', [0.63 0.3 0.15 0.15])
% box on
% h1 = errorbar(RaNonShearing,abs(MeanNonShearing),errNonShearing,'bo', 'Displayname', 'Non-Shearing'); hold on
% set(h1, 'markerfacecolor', get(h1, 'color')); % Use same color to fill in markers
% h1 = errorbar(RaShearing,abs(MeanShearing),errShearing,'r^', 'Displayname', 'Shearing');
% set(h1, 'markerfacecolor', get(h1, 'color')); % Use same color to fill in markers
% h1 = errorbar(RaReversals,abs(MeanReversals),errReversals,'m*', 'Displayname', 'Reversals');
% set(h1, 'markerfacecolor', get(h1, 'color')); % Use same color to fill in markers
% set(gca, 'XScale', 'log'), hold off
% xlim([0.9e5 5.5e5]); 
% set(gca, 'XScale', 'log')
%ylabel('$\mid \langle \hat \psi_{0,1} \rangle \mid$','FontSize', 12)
%xlabel('$Ra$','FontSize', 12), hold off

%% Make top plot
Ra = 6e5;
run SomeInputStuff.m
kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes1.txt']);
xlower = AllData.(ARS).(PrS).(RaS).ICT;
urms = AllData.(ARS).(PrS).(RaS).urms;
Signal =  kpsmodes1(:,2); Signal = Signal(xlower:end)/(h*urms); % Also include non-dim here
Time =  kpsmodes1(:,1); Time = Time(xlower:end)/(h/urms); % Also include non-dim here
subplot(3,2,[1 2])
plot(Time, 2*Signal, 'Color', [0 0.5 0])
xlim([1e4 2e4])
title('Ra $= 6 \times 10^5$, $\Gamma =1$, (a)', 'Fontsize', TitleFS)
label_y = ylabel('$\widehat \psi_{0,1}$/$(\pi du_{rms})$', 'Fontsize', LabelFS);
label_y.Position(1) = label_y.Position(1) - 3e2;
label_x = xlabel('$t/(\pi d/u_{rms})$', 'Fontsize', LabelFS)
label_x.Position(2) = label_x.Position(2) - 0.05
hp4 = get(gca,'xlabel').Position;
set(get(gca,'xlabel'),'Position', [hp4(1)-0.25 hp4(2) hp4(3)])
hp4 = get(gca,'ylabel').Position;
set(get(gca,'ylabel'),'Position', [hp4(1)-0.30 hp4(2) hp4(3)])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
clearvars -except AllData h hej

%% Input
run SetUp.m
AR = 2;
Pr = 30;
run SomeInputStuff.m
Ra_list = string(fieldnames(AllData.(ARS).(PrS)));
hej = subplot(3,2,[3 5], 'Position', [0.1300 0.1100 0.3347 0.47]); % This syntax will not be supported in future release
RaMin = 9e4;
%Rem = [6.3e6 6.8e6 3e6 5e6 5.5e6];
%Rem = [3e6];
Rem = [3.5e6 7.9e6 3.6e6 4.1e6 6.3e6 6.8e6 5.6e6];
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
legend('Location', 'northwest', 'Position', [0.1399 - 0.025 0.4132 0.2193 0.1502], 'FontSize', lgndFS); legend('boxoff')
set(gca, 'XScale', 'log')
ylabel('$ \langle \widehat \psi_{0,1} \rangle$/$(\pi du_{rms})$','FontSize', LabelFS)
xlabel('Ra','FontSize', LabelFS)
xlim([7e5 1e7])
title('$\Gamma =2$, (b)', 'Fontsize', TitleFS)
hp4 = get(gca,'title').Position;
set(get(gca,'title'),'Position', [1.65e6 -0.4  hp4(3)])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS; hold off

