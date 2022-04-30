%% Getting data
addpath('/Users/philipwinchester/Dropbox/Matlab/Normal/Functions')
% run Params.m
% run SomeInputStuff.m
% path = convertStringsToChars(AllData.(ARS).(PrS).(RaS).path);
Ra = 6e4;
Pr = 6.2;
path = '/Volumes/Samsung_T5/EigComp/Pr_6_2/Ra_6e4';
kpsmodes1 = importdata([path '/Checks/kpsmodes1.txt']);
%% Setting limits
semilogy(abs(kpsmodes1(:,2)), '-o')

xlower = 30;
xupper = length(kpsmodes1(:,2)); %4500; %2e4;
sall = kpsmodes1(:,2); s=sall(xlower:xupper);
tall = kpsmodes1(:,1); t=tall(xlower:xupper);
%% getting peaks
[~,locs] = findpeaks(abs(s));
s = s(locs);
t = t(locs);

%% non-dim
kappa = sqrt((pi^3/(Ra*Pr)));
t = t*kappa/pi^2;
tall = tall*kappa/pi^2;
%%
[alpha, A, xFitted, yFitted, Rval] = Fitslogy(t,abs(s));
stop
%% Plot
figure('Renderer', 'painters', 'Position', [5 5 540 200])
subplot(1,2,1)
semilogy(tall,abs(sall)), hold on
%plot(xFitted, yFitted, 'black--')
xlabel('$t/(\kappa/(\pi d))$', 'FontSize', 14)
ylabel('$|\widehat \psi_{0,1}|$', 'FontSize', 14)
xlim([0 110]), hold off
subplot(1,2,2)
plot(t,s), hold on
plot(xFitted, yFitted, 'black--')
xlabel('$t/(\kappa/(\pi d))$', 'FontSize', 14)
ylabel('$\widehat \psi_{0,1}$', 'FontSize', 14)
xlim([0 2]), hold off
sgtitle(['$' AllData.(ARS).(PrS).(RaS).title '$'], 'FontSize', 15)


