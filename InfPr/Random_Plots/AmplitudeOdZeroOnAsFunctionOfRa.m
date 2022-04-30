% Getting data
Ra_list = string(fieldnames(AllData.AR_2.Pr_30));
for i=1:length(Ra_list)
    if AllData.AR_2.Pr_30.(Ra_list(i)).Ra > 5.4e6
        Table = importdata(join(["/Volumes/Samsung_T5/AR_2/256x256/Pr_30/" Ra_list(i) "/Checks/kpsmodes1.txt"],"") );
        t = Table(:,1);
        s = Table(:,2);
        h = figure;
        plot(s);
        xlabel('Step, not time')
        xlower = input('Where do we start? ');
        xupper = input('Where do we end? ');
        close(h)
        data.(Ra_list(i)).t = t(xlower:xupper);
        data.(Ra_list(i)).s = s(xlower:xupper);
    end
end
%%
% Making Ra_val
Ra_val = []; % Making Ra_val
for i=1:length(Ra_list)
    if AllData.AR_2.Pr_30.(Ra_list(i)).Ra > 4e6
        Ra_val(length(Ra_val)+1) = AllData.AR_2.Pr_30.(Ra_list(i)).Ra;
    end
end

% Making mean
things = string(fieldnames(data));
for i=1:length(things)
    m(i) = MyMean(data.(things(i)).s, data.(things(i)).t);
    z(i) = log10(data.(things(i)).t(end)-data.(things(i)).t(1));
end
%%
figure('Renderer', 'painters', 'Position', [5 5 540 200])
scatter(Ra_val, m, 30, z, 'filled');
xlim([5.4e6 1e7])
set(gca,'xscale','log')
colormap winter;
c = colorbar;
c.Label.Interpreter = 'latex';
c.Label.String = '$\log_{10}$(TISS)';
c.Label.FontSize = 13
xlabel("$Ra$",'Interpreter','latex', 'FontSize', 13)
ylabel("$m$",'Interpreter','latex', 'FontSize', 13)
title("$Pr = 30$",'Interpreter','latex', 'FontSize', 13)
hold on

clearvars -except AllData data Ra_list










