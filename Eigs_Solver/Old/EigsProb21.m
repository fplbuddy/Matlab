%% Set up
TE = 'latex';
home = '/Users/philipwinchester/Dropbox/Matlab';
RB = [home '/redblue'];
Functions = [home '/Functions'];
addpath(Functions)
addpath(home);
addpath(RB);
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)

%% Input
clearvars -except AllData
ARS = "AR_2";
N = 32;
a = 1;
g = 1;
DT = 1;
Pr_list = [1 3 10 30 100 300];
RaMin = 8*pi^4;
%%
for Pr=1:length(Pr_list)
    Pr = Pr_list(Pr);
    PrS = ['Pr_' num2str(Pr)];
    Ra_list = string(fieldnames(AllData.(ARS).(PrS)));
    for RaS=1:length(Ra_list)
        RaS = Ra_list(RaS);
        Ra = RaStoRa(RaS);
        if Ra > RaMin
            RaS = RatoRaS(Ra);
            nu = sqrt(pi^3*Pr/Ra); kappa = sqrt((pi^3/(Ra*Pr)));
            kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes1.txt']);
            kthetamodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes1.txt']);
            BR = kpsmodes1(:,3); BR = BR(end);
            BI = kpsmodes1(:,5); BI = BI(end);
            CR = kthetamodes1(:,3); CR = CR(end);
            CI = kthetamodes1(:,5); CI = CI(end);
            % Check convergance
            BRCheck = kpsmodes1(:,3); BRCheck = BRCheck(end-1);
            if BRCheck == BR
                B = sqrt(BR^2 + BI^2);
                C = sqrt(CR^2 + CI^2);
                run EigsProb212.m
                sigma = diag(sigma);
                Locations = [];
                for i=1:(2*N^2)
                    if W(N/2+1,i) ~= 0; Locations = [Locations i]; end
                end
                data.(PrS).(RaS).eigvals = sigma(Locations);
            end
        end
    end
end

%% Plot eigenvalues
PrS = 'Pr_100';
Ra_list = string(fieldnames(data.(PrS)));
Ra = [];
% sort Ra_list
for i=1:length(Ra_list)
    Ra = [Ra RaStoRa(Ra_list(i))];
end
[Ra, I] = sort(Ra);
Ra_list = Ra_list(I);

cmap = colormap(winter(length(Ra_list)));
figure
for i=1:length(Ra_list)
    x = []; y = [];
    RaS = Ra_list(i);
    RaT = RatoRaT(RaStoRa(RaS));
    eigvals = data.(PrS).(RaS).eigvals;
    for eig=1:length(eigvals)
        eig = eigvals(eig);
       x = [real(eig) x]; y = [imag(eig) y];
    end
    plot(x, y, '*','Color',cmap((length(Ra_list)-i+1),:), 'DisplayName', ['$Ra = ' RaT '$']); hold on
end
legend('Location', 'bestoutside')
xlabel('$Real(\sigma)$', 'FontSize', 14)
ylabel('$Imag(\sigma)$', 'FontSize', 14)
title(['$Pr = ' num2str(str2double(erase(strrep(PrS,"_","."),"Pr."))) '$'], 'FontSize', 14)
hold off


%% Plotting an Eigenfunction
% Vinst = V(:,344); % Picking an eigenfunction
% Vinst = Vinst(1:length(Vinst)/2); % Only taking psi part
% x = linspace(2*pi/(2*N), 2*pi-2*pi/(2*N), N); % Evaluate inside squares
% y = linspace(pi/(2*N), pi-pi/(2*N), N);
% [xx, yy] = meshgrid(x,y);
% % Getting the wavenumbers we have
% kxL = -N/2:(N/2-1); kxL = repmat(kxL, N); kxL = kxL(1,:);
% kyL = 1:N; kyL = repelem(kyL, N);
% % Setting up function data matrix
% FDM = zeros(N,N, N^2);
% for i=1:N^2
%     kx = kxL(i);
%     ky = kyL(i);
%     FDM(:,:,i) = sin(ky*yy)*exp(1i*xx*kx);
% end
%
% Eigenfuntion = zeros(N, N);
%
% % Calculating the eigenfunction
% for i=1:N^2 % Looping round eigenfunctions
%     amp = Vinst(i);
%     Eigenfuntion = amp*FDM(:,:,i) + Eigenfuntion;
% end
%
% figure
% pcolor(real(Eigenfuntion));
% shading flat
% colormap('jet')
% colorbar