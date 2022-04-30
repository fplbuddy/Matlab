AR = 1;
Pr = 30;
run SomeInputStuff.m
Ra_list = string(fieldnames(AllData.(ARS).(PrS)));
figure('Renderer', 'painters', 'Position', [5 5 400 400])
for i=1:length(Ra_list)
    RaS = Ra_list(i);
    if isfield(AllData.(ARS).(PrS).(RaS),'ICT')
        NuInst = AllData.(ARS).(PrS).(RaS).calcs.Nu;
        Rainst = AllData.(ARS).(PrS).(RaS).Ra;
        PosShear = not(sum(size(AllData.(ARS).(PrS).(RaS).calcs.pos{1})) == 1);
        NegShear = not(sum(size(AllData.(ARS).(PrS).(RaS).calcs.neg{1})) == 1);
        Zero = not(sum(size(AllData.(ARS).(PrS).(RaS).calcs.zero{1})) == 1);
        
        if (PosShear && NegShear)
            % We are reversing
            loglog(Rainst,NuInst,'m*'); hold on
        elseif (not(PosShear) && not(NegShear))
            % Not shearing or reversing
            loglog(Rainst,NuInst,'b*'); hold on
        elseif (NegShear && not(PosShear) && not(Zero) || PosShear && not(NegShear) && not(Zero))
            % Shearing
            loglog(Rainst,NuInst,'r*'); hold on
        else
            % ERROR or ones where it has not reversed yet
            loglog(Rainst,NuInst,'g*'); hold on
        end
    end
end