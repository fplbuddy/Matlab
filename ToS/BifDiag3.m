run SetUp.m
%% Input
figure('Renderer', 'painters', 'Position', [5 5 700 300])
h = pi;
run SetUp.m
AR = 1;
Pr = 30;
run SomeInputStuff.m
Ra_list = string(fieldnames(AllData.(ARS).(PrS)));
%hej = subplot(3,2,[3 5], 'Position', [0.1300 0.1100 0.3347 0.47]); % This syntax will not be supported in future release
RaMin = 9e3;
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
legend('Location', 'northwest', 'FontSize', lgndFS); legend('boxoff')
set(gca, 'XScale', 'log')
ylabel('$ \langle \widehat \psi_{0,1} \rangle_t/(\pi du_{rms})$','FontSize', LabelFS)
xlabel('Ra','FontSize', LabelFS)
xlim([1e4 1e7])
text(1e5,0.33,'Pr $=30$, $\Gamma =1$', 'FontSize', TitleFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS; hold off

