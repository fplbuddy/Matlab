ExE = 0;
set(0,'DefaultFigureColormap',feval('jet'));
AR_list =string(fieldnames(AllData));
for i=1:length(AR_list)
    ARS = AR_list(i);
    Pr_list = string(fieldnames(AllData.(ARS)));
    for i=1:length(Pr_list)
        PrS = Pr_list(i);
        Ra_list = string(fieldnames(AllData.(ARS).(PrS)));
        for i=1:length(Ra_list)
            RaS = Ra_list(i);
            if isfield(AllData.(ARS).(PrS).(RaS),'ICT')
                if ExE
                    run GetExEPoints.m
                else
                    run GetExPoints.m
                end
            end
        end
    end
end
% Gather and Reshape. Full takes shered if exits, nonsheared if not
RaFull = [RaShearingOwn RaShearingShared RaNonShearingOwn]; 
PrFull = [PrShearingOwn PrShearingShared PrNonShearingOwn];
ExEFull = [ExEShearingOwn ExEShearingShared ExENonShearingOwn];
RaFull = reshape(RaFull,length(RaFull),1); 
PrFull = reshape(PrFull,length(PrFull),1); 
ExEFull = reshape(ExEFull,length(ExEFull),1);

%% Model
% figure
% sf = fit([X, Y],Z,'poly23');
% plot(sf,[X,Y],Z)
% set(gca, 'yscale', 'log')
% set(gca, 'xscale', 'log')
% view(2)
% shading interp
% colorbar()
% %clearvars -except AllData

%% Using griddata

[xq,yq] = meshgrid(logspace(4,10,1000), logspace(0,3,1000));
vq = griddata(RaFull,PrFull,log10(ExEFull),xq,yq);
figure
mesh(xq,yq,vq)
%plot3(RaFull,PrFull,ExEFull,'o')
set(gca, 'yscale', 'log')
set(gca, 'xscale', 'log')
xlabel('$Ra$', 'FontSize',14)
ylabel('$Pr$', 'FontSize',14)
if ExE
    title('$\frac{E_x}{E}$', 'FontSize',20)
else
    title('$\log{E_x}$', 'FontSize',20)
    %set(gca,'ColorScale','log')
end
view(2)
shading interp
colorbar()
xlim([min(RaFull) max(RaFull)])
ylim([1 max(PrFull)])

%% Points on their own
MS = 25;
DF = 1.05;
figure('Renderer', 'painters', 'Position', [5 5 540 400])
scatter(RaNonShearingOwn, PrNonShearingOwn/DF, MS, ExENonShearingOwn, 'filled'), hold on
scatter(RaShearingOwn, PrShearingOwn*DF, MS, ExEShearingOwn, '*')
scatter(RaNonShearingShared, PrNonShearingShared/DF, MS, ExENonShearingShared, 'filled')
scatter(RaShearingShared, PrShearingShared*DF, MS, ExEShearingShared, '*'), hold off
colorbar()
set(gca, 'yscale', 'log'), set(gca, 'xscale', 'log')
xlabel('$Ra$', 'FontSize',14)
ylabel('$Pr$', 'FontSize',14)
title('$\frac{E_x}{E}$', 'FontSize',20)
xlim([min(RaFull) max(RaFull)]), ylim([min(PrFull) max(PrFull)])


clearvars -except AllData