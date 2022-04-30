run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
Pr = 0; 
%PrS = normaltoS(Pr,'Pr',1); PrT = RatoRaT(Pr);
PrS = 'Pr_inf'; PrT = '\infty';
Ra = 1e7; RaS = normaltoS(Ra,'Ra',1); RaT = RatoRaT(Ra);
path = ['/Volumes/Samsung_T5/Periodic/n_512/o1_1e0/o2_1e0/f_0e1/Rhnu_2e6/' PrS '/' RaS '/Spectra/'];
Spectrum = 'PEspec';


%% Average
nodes = 62:62;
for i = 1:length(nodes)
    node = num2str(nodes(i));
    while length(node) < 4
        node = ['0' node];
    end
    data = importdata([path Spectrum node '.txt']);
    %data = data(:,2);
    if i == i
        datatot = data;
    else
        datatot = datatot + data;
    end
end
figure('Renderer', 'painters', 'Position', [5 5 600 250])
datatot = datatot/length(nodes);
loglog(1:length(datatot), datatot)
ylim([1e-10 1e5])
xlabel('$K = \sqrt{k_x^2 + k_y^2}$','FontSize',labelFS);
ylabel('$\widehat \theta_{k_x,k_y}^2$','FontSize',labelFS);
ax = gca;
ax.FontSize = numFS;
title(['$Ra = ' RaT ',\, Pr = ' PrT '$'],'FontSize',labelFS)


%% A few
% datatot = datatot/length(nodes);
% nodes = 70:20:201;
% for i = 1:length(nodes)
%     node = num2str(nodes(i));
%     while length(node) < 4
%         node = ['0' node];
%     end
%     data = importdata([path Spectrum node '.txt']);
%     loglog(1:length(data), data), hold on
% end
