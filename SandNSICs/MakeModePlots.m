%% Input
Ra = 4e6;
type = 'ps';
Mode = "Re(0,1)";
%
ModeC = convertStringsToChars(Mode);
[mrow,mcolumn,ModeAndTypeC] = WhichMode(Mode, type);
run SomeInputStuff.m
IC_list = string(fieldnames(AllData));
%% Make plot
figure('Renderer', 'painters', 'Position', [1 50 540 200]);
for i=1:length(IC_list)
   IC = IC_list(i);
   kpsmodes1 = importdata([convertStringsToChars(AllData.(IC).(RaS).path) '/Checks/kpsmodes1.txt']); % Maybe not hard coded
   Signal = kpsmodes1(:,mcolumn+1);
   t = kpsmodes1(:,1);
   subplot(1,2,i)
   plot(t, Signal)
   if i == 1
     ylabel('$\hat\psi_{0,1}$', 'Fontsize', 15)
   end
   xlabel('$t$ (s)', 'Fontsize', 15)
end
sgtitle(['$' AllData.(IC).(RaS).title '$'], 'Fontsize', 15)
clearvars -except AllData


