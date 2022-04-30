FS = 20;
TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)

GS_list = string(fields(WNLData));
G_list = [];
hopf_list = [];
pitch_list = [];

for i=1:length(GS_list)
   GS =  GS_list(i);
   if isfield(WNLData.(GS), "calcs")
       G = GStoG(GS);
       G_list = [G G_list];
       pitch_list = [WNLData.(GS).calcs.pitch pitch_list];
       hopf_list = [WNLData.(GS).calcs.hopf hopf_list];
   end 
end
[G_list,I] = sort(G_list);
pitch_list = pitch_list(I);
hopf_list = hopf_list(I);
figure('Renderer', 'painters', 'Position', [5 5 600 300])
plot([2.37 2.37], [-1e11 1e11], '--k'), hold on
h(1) = semilogy(G_list,pitch_list, 'LineWidth',2, 'DisplayName', 'Pitchfork', 'Color', 'b'); hold on
h(2) = plot(G_list,hopf_list, 'LineWidth',2, 'DisplayName', 'Hopf', 'Color', 'r');
ylim([-1e5 1e5])
lgnd = legend(h(1:2),'Location', 'southeast', 'FontSize', FS);
ax = gca;
ax.XAxis.FontSize = FS;
ax.YAxis.FontSize = FS;
xlabel('$\Gamma$', 'FontSize', FS)
ylabel('$r$', 'FontSize', FS)