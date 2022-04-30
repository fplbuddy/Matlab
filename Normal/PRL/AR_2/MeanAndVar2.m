run SetUp.m
%% Input
AR = 2;
Pr = 30;
run SomeInputStuff.m
Ra_list = string(fieldnames(AllData.(ARS).(PrS)));
figure('Renderer', 'painters', 'Position', [5 5 600 400*2/3])
RaMin = 9e4;
Rem = [6.3e6 6.8e6 3e6];
RaNonShearing = []; RaShearing = []; RaReversals = [];
MeanNonShearing = []; MeanShearing = []; MeanReversals = [];
errNonShearing = []; errShearing = []; errReversals = [];
for i=1:length(Ra_list)
    RaS = Ra_list(i);
    if isfield(AllData.(ARS).(PrS).(RaS),'ICT') && AllData.(ARS).(PrS).(RaS).Ra >= RaMin && ~ismember(AllData.(ARS).(PrS).(RaS).Ra, Rem)
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
h1 = errorbar(RaShearing,abs(MeanShearing),errShearing,'r^', 'Displayname', 'Shearing');
set(h1, 'markerfacecolor', get(h1, 'color')); % Use same color to fill in markers
h1 = errorbar(RaReversals,abs(MeanReversals),errReversals,'m*', 'Displayname', 'Reversals');
set(h1, 'markerfacecolor', get(h1, 'color')); % Use same color to fill in markers
legend('Location', 'northwest'); legend('boxoff')
set(gca, 'XScale', 'log')
ylabel('$\mid \langle \hat \psi_{0,1} \rangle \mid$','FontSize', 14)
xlabel('$Ra$','FontSize', 14)
xlim([7e5 1e7])
title('$\Gamma =2$', 'Fontsize', FS1)
hp4 = get(gca,'title').Position
set(get(gca,'title'),'Position', [hp4(1)/3 hp4(2) 0]), hold off
