G = 2;
GS = GtoGS(G);
eps = 0.1;
epsS = epstoepsS(eps);
Period_list = [];
rlower = 239;
rS_list = string(fields(WNLData.(GS).(epsS)));
% Checking that we have tlower for all the ones we need it for
for i=1:length(rS_list)
    rS = rS_list(i);
%     r = WNLData.(GS).(epsS).(rS).r;
%     if r < 239 || isfield(WNLData.(GS).(epsS).(rS),"tlower")
%         continue
%     else
%         r
%         figure()
%         plot(abs(WNLData.(GS).(epsS).(rS).A), '-o'), hold on
%         plot(WNLData.(GS).(epsS).(rS).phi)
%         tlower = input('Start? ');
%         WNLData.(GS).(epsS).(rS).tlower  = tlower;
%         close all
%     end

    t = WNLData.(GS).(epsS).(rS).t;
    t = t*0.01;
    WNLData.(GS).(epsS).(rS).t = t;
end

%% Now do the period stuff
FS = 20;
TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)
r_list = [];
Period_list = [];
for i=1:length(rS_list)
    rS = rS_list(i);
    r = WNLData.(GS).(epsS).(rS).r;
    if r < 239 
        continue
    else
        tlower = WNLData.(GS).(epsS).(rS).tlower;
        phi = WNLData.(GS).(epsS).(rS).phi; phi = phi(tlower:end);
        t = WNLData.(GS).(epsS).(rS).t; t = t(tlower:end);
        [~,locs] = findpeaks(phi);
        tpeaks = t(locs);
        dtpeaks = diff(tpeaks);
        Period = mean(dtpeaks);
        Period_list = [Period Period_list];
        r_list = [r r_list];
    end
end
figure('Renderer', 'painters', 'Position', [5 5 600 300])
plot(r_list,Period_list,'*')
ax = gca;
ax.XAxis.FontSize = FS;
ax.YAxis.FontSize = FS;
xlabel('$r$', 'FontSize', FS)
ylabel('Period', 'FontSize', FS)
xlim([239 3000])

