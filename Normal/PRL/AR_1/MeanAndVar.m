run SetUp.m
%% Input
AR = 1;
Pr = 30;
run SomeInputStuff.m
Ra_list = string(fieldnames(AllData.(ARS).(PrS)));
figure('Renderer', 'painters', 'Position', [5 5 400 400])
RaMin = 6e4;
RaNonShearing = []; RaShearing = []; RaReversals = [];
MeanNonShearing = []; MeanShearing = []; MeanReversals = [];
errNonShearing = []; errShearing = []; errReversals = [];
for i=1:length(Ra_list)
    RaS = Ra_list(i);
    if isfield(AllData.(ARS).(PrS).(RaS),'ICT') && AllData.(ARS).(PrS).(RaS).Ra >= RaMin
        kappa = AllData.(ARS).(PrS).(RaS).kappa;
        meaninst = AllData.(ARS).(PrS).(RaS).calcs.mean/kappa;
        Rainst = AllData.(ARS).(PrS).(RaS).Ra;
        errinst = AllData.(ARS).(PrS).(RaS).calcs.sd/kappa;
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
            RaShearing = [RaShearing Rainst];
            errShearing = [errShearing errinst];
            MeanShearing = [MeanShearing meaninst];
        end
    end
end
h1 = errorbar(RaNonShearing,abs(MeanNonShearing),errNonShearing,'bo', 'Displayname', 'Non-Shearing'); hold on
set(h1, 'markerfacecolor', get(h1, 'color')); % Use same color to fill in markers
h1 = errorbar(RaShearing,abs(MeanShearing),errShearing,'r^', 'Displayname', 'Shearing')
set(h1, 'markerfacecolor', get(h1, 'color')); % Use same color to fill in markers
h1 = errorbar(RaReversals,abs(MeanReversals),errReversals,'m*', 'Displayname', 'Reversals')
set(h1, 'markerfacecolor', get(h1, 'color')); % Use same color to fill in markers
legend('Location', 'northwest'); legend('boxoff')
set(gca, 'XScale', 'log'), hold off
ylabel('$\mid \langle \hat \psi_{0,1} \rangle \mid$','FontSize', 14)
xlabel('$Ra$','FontSize', 14)
%% Make box
axes('Position',[.25 .5 .2 .2])
box on
h1 = errorbar(RaNonShearing,abs(MeanNonShearing),errNonShearing,'bo', 'Displayname', 'Non-Shearing'); hold on
set(h1, 'markerfacecolor', get(h1, 'color')); % Use same color to fill in markers
h1 = errorbar(RaShearing,abs(MeanShearing),errShearing,'r^', 'Displayname', 'Shearing')
set(h1, 'markerfacecolor', get(h1, 'color')); % Use same color to fill in markers
h1 = errorbar(RaReversals,abs(MeanReversals),errReversals,'m*', 'Displayname', 'Reversals')
set(h1, 'markerfacecolor', get(h1, 'color')); % Use same color to fill in markers
set(gca, 'XScale', 'log'), hold off
xlim([0.9e5 5.5e5]); 
set(gca, 'XScale', 'log')
ylabel('$\mid \langle \hat \psi_{0,1} \rangle \mid$','FontSize', 12)
xlabel('$Ra$','FontSize', 12), hold off

%clearvars -except AllData

