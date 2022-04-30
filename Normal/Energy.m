run Params.m
run SomeInputStuff.m
run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m

kenergy = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kenergy.txt']);
penergy = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/penergy.txt']);

t = kenergy(:,1); 
Ek = kenergy(:,2);
Ep = penergy(:,2);

if not(exist('xlower','var'))
    h = figure;
    semilogy(Ek, 'DisplayName', 'E_k'), hold on
    plot(Ep, 'DisplayName', 'E_p'), hold off
    legend show
    legend('Location', 'best')
    xlower = input('x lower bound: ');
    close(h)
end

t = t(xlower:end);
Ek = Ek(xlower:end);
Ep = Ep(xlower:end);

% Making sure everything is the same length
top = min([length(t) length(Ek) length(Ep)]);
t = t(1:top);
Ek = Ek(1:top);
Ep = Ep(1:top);

% Non-dimesionalise
% if NDT
%     t = t*AllData.(ARS).(PrS).(RaS).kappa/pi^2;
% end
% Ek = Ek*pi^2/AllData.(ARS).(PrS).(RaS).kappa^2;
 
figure('Renderer', 'painters', 'Position', [5 5 540 200])
semilogy(t, Ek, 'DisplayName', '$E_k$'), hold on
plot(t, Ep, 'DisplayName', '$E_p$'), hold off
%if NDT
%    xlabel('time (d^2/\kappa)')
%else
xlabel('time (s)','FontSize',labelFS)
%end
%ylabel('Energy (non-dim)')
ylabel('Energy')
legend show
legend('Location', 'best','FontSize',labelFS)
title(['$' AllData.(ARS).(PrS).(RaS).title '$'],'FontSize',labelFS)
ax = gca;
ax.FontSize = numFS;

%clearvars -except AllData
 
 
 

 
 