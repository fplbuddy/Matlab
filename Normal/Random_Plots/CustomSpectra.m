run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
Pr = 0.6; Ra = 2e9;
%PrS = normaltoS(Pr, 'Pr',1); RaS = normaltoS(Ra, 'Ra',1);
PrT = RatoRaT(Pr); RaT = RatoRaT(Ra); 
path = '/Volumes/Samsung_T5/AR_2/1024x512/Pr_0_6/Ra_2e9/Spectra/';
Spectrum = 'Epspectrum';
figure('Renderer', 'painters', 'Position', [5 5 540 200])
nodes = 115:115;
%%
for i = 1:length(nodes)
    node = num2str(nodes(i));
    while length(node) < 4
        node = ['0' node];
    end
    data = importdata([path Spectrum '.' node '.txt']);
    data = data(:,2);
    if i == 1
        datatot = data;
    else
        datatot = datatot + data;
    end
end
datatot = datatot/length(nodes);
%loglog(1:length(datatot), datatot'.*(1:length(datatot)).^2)
loglog(1:length(datatot), datatot)
xlabel('$K = \sqrt{k_x^2 + k_y^2}$','FontSize',labelFS);
%ylabel('$K^2 \times \widehat \theta_{k_x,k_y}^2$','FontSize',labelFS);
ylabel('$\widehat \theta_{k_x,k_y}^2$','FontSize',labelFS);
ax = gca;
ax.FontSize = numFS;
%ylim([1e-4 1e-2])
yticks([1e-20 1e-18 1e-16 1e-14 1e-12 1e-10 1e-8 1e-6 1e-4 1e-2 1e0])
title(['$Ra = ' RaT ',\, Pr = ' PrT '$'],'FontSize',labelFS)