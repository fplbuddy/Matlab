ARS = "AR_2";
Pr_list2 = [3 5 10 50 30 100 150 200 250 300];
RaRange = logspace(3, 10, 200);
for i=1:length(Pr_list2)
    Pr = Pr_list2(i);
    PrS = ['Pr_' num2str(Pr)];
    Ra_list2 = string(fields(AllData.(ARS).(PrS)));
    Ra_list2 = OrderRaS_list(Ra_list2);
    Data.(PrS).Ra = [];
    Data.(PrS).ExE = [];
    ns = 1;
    for i=1:length(Ra_list2)
        Ra = AllData.(ARS).(PrS).(Ra_list2(i)).Ra;
        PosShear = not(sum(size(AllData.(ARS).(PrS).(Ra_list2(i)).calcs.pos{1})) == 1);
        NegShear = not(sum(size(AllData.(ARS).(PrS).(Ra_list2(i)).calcs.neg{1})) == 1);
        Zero = not(sum(size(AllData.(ARS).(PrS).(Ra_list2(i)).calcs.zero{1})) == 1);
        
        if PosShear || NegShear
            ExE = AllData.(ARS).(PrS).(Ra_list2(i)).calcs.sExEmean;
            ns = 0;
        elseif Zero && ns
            if AllData.(ARS).(PrS).(Ra_list2(i)).calcs.zExEmean > 0.3
                ExE = AllData.(ARS).(PrS).(Ra_list2(i)).calcs.zExEmean;
            end
        end
        
        Data.(PrS).ExE = [ExE Data.(PrS).ExE];
        Data.(PrS).Ra = [Ra Data.(PrS).Ra];
    end
    % Getting spline for each Pr
    Data.(PrS).Ra = reshape(Data.(PrS).Ra, length(Data.(PrS).Ra), 1); Data.(PrS).ExE = reshape(Data.(PrS).ExE, length(Data.(PrS).ExE), 1);
    Data.(PrS).PrFit = feval(fit(Data.(PrS).Ra, Data.(PrS).ExE,'pchipinterp'), RaRange);
    semilogx(RaRange, Data.(PrS).PrFit), hold on
    plot(Data.(PrS).Ra, Data.(PrS).ExE, '*'), hold off
    title(PrS)
    pause
end
clearvars -except AllData Data