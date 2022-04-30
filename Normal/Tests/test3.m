AR = 2;
Pr = 30;
run SomeInputStuff.m

RaS_list = string(fields(AllData.(ARS).(PrS)));

for i=1:length(RaS_list)
   RaS = RaS_list(i);
   Ra = RaStoRa(RaS);
   if Ra > 1e6 && Ra < 1e7 % Check that is in ranfe
        PosShear = not(sum(size(AllData.(ARS).(PrS).(RaS).calcs.pos{1})) == 1);
        NegShear = not(sum(size(AllData.(ARS).(PrS).(RaS).calcs.neg{1})) == 1);
        Zero = not(sum(size(AllData.(ARS).(PrS).(RaS).calcs.zero{1})) == 1);
        if PosShear && Zero || NegShear && Zero % Checking that we have at least one shearing and zero
            kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes1.txt']);
            xlower = AllData.(ARS).(PrS).(RaS).ICT;
            t = kpsmodes1(:,1); t = t(xlower:end);
            s = kpsmodes1(:,2); s = s(xlower:end);
            figure('Renderer', 'painters', 'Position', [5 5 540 200])
            plot(t,s)
            ylabel('$\hat \psi_{0,1}$', 'FontSize', 14)
            xlabel('$t$ $(s)$', 'FontSize', 14)
            tit = AllData.(ARS).(PrS).(RaS).title;
            title(['$' tit '$'], 'FontSize', 15)
            RaS = convertStringsToChars(RaS);
            saveas(gcf,[pwd '/Reversing_Figures/' RaS '.png'])
        end
   end
end
