% Input
AR = 2;
Pr = 3;
EBF = 1.5;
run SomeInputStuff.m
Ra_list = string(fieldnames(AllData.(ARS).(PrS)));
figure('Renderer', 'painters', 'Position', [5 5 540 200])
for i=1:length(Ra_list)
    RaS = Ra_list(i);
    if isfield(AllData.(ARS).(PrS).(RaS),'ICT')
        meaninst = AllData.(ARS).(PrS).(RaS).calcs.mean;
        Rainst = AllData.(ARS).(PrS).(RaS).Ra;
        errinst = AllData.(ARS).(PrS).(RaS).calcs.sd;
        if (isnan(AllData.(ARS).(PrS).(RaS).calcs.sExEmean) && not(isnan(AllData.(ARS).(PrS).(RaS).calcs.zExEmean)))
            % We are in non-shearing
            errorbar(Rainst,meaninst,errinst*EBF,'b*'); hold on
        elseif (isnan(AllData.(ARS).(PrS).(RaS).calcs.zExEmean) && not(isnan(AllData.(ARS).(PrS).(RaS).calcs.sExEmean)))
            % We are in shearing
            errorbar(Rainst,meaninst,errinst*EBF,'r*'); hold on
        else
            % Tristable
            errorbar(Rainst,meaninst,errinst*EBF,'m*'); hold on
        end
    end
end
set(gca, 'XScale', 'log'); hold off
title(['$Pr = ' num2str(Pr) '$'], 'FontSize', 15)
ylabel('$\hat \psi_{0,1}$','FontSize', 14)
xlabel('$Ra$','FontSize', 14)
clearvars -except AllData

%% Some other stuff
hold on
Ralist = ["Ra_2e4" "Ra_3e4" "Ra_6e4"];
EBF = 1.5;
xlowerlist = [5000 1000 5000];
% Do for 64x64 res
for i=1:length(Ralist)
    Ra = convertStringsToChars(Ralist(i));
    xlower = xlowerlist(i); 
    kpsmodes1 = importdata(['/Volumes/Samsung_T5/Residue/64x64/Pr_1/' Ra '/Checks/kpsmodes1.txt' ]);
    RaV = RaStoRa(Ra);
    Signal = kpsmodes1(:,2); t = kpsmodes1(:,1);
    Signal = Signal(xlower:end); t = t(xlower:end);
    Y = MyMeanEasy(Signal, t);
    err = std(Signal);
    errorbar(RaV,Y,err*EBF,'b*'); hold on
end

Ralist = ["Ra_1_5e4" "Ra_1_6e4" "Ra_1_7e4" "Ra_1_74e4" "Ra_1_743e4"];
% Do for 128x128 res
for i=1:length(Ralist)
    Ra = convertStringsToChars(Ralist(i));
    xlower = 1; % Think all should be 1 for these 
    kpsmodes1 = importdata(['/Volumes/Samsung_T5/Residue/128x128/Pr_1/' Ra '/Checks/kpsmodes1.txt' ]);
    RaV = RaStoRa(Ra);
    Signal = kpsmodes1(:,2); t = kpsmodes1(:,1);
    Signal = Signal(xlower:end); t = t(xlower:end);
    Y = MyMeanEasy(Signal, t);
    err = std(Signal);
    errorbar(RaV,Y,err*EBF,'r*'); hold on
end