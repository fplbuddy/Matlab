fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions';
addpath(fpath)
dpath = '/Volumes/Samsung_T5/OldData/masternew.mat';
% load(dpath)
G = 2;
AR = ['AR_' num2str(G)];
Ra_list = [1e3 2e3 3e3 6e3 1e4 2e4 3e4 6e4 1e5 2e5 3e5 6e5 1e6 2e6 3e6 6e6 1e7 2e7 3e7 6e7 1e8];
%% first table
Pr_list = [1e-6 1e-5 1e-4 1e-3];
Nu_table = zeros(length(Ra_list),length(Pr_list));
for i=1:length(Pr_list)
    Pr = Pr_list(i);
    for j=1:length(Ra_list)
        Ra = Ra_list(j);
        % check which res
        if Ra <= 3e3
            N = 64;
        elseif Ra <= 6e5
            N = 152;
        elseif Ra <= 4e6
            N = 256;
        elseif Ra <= 3e7
            N = 400;
        end
        Nu = CalculateNusselt(Data,G,Ra,Pr,N);
        Nu_table(j,i) = Nu;
    end
end
Nu_table = round(Nu_table,6,'significant');
writematrix(Nu_table,"/Users/philipwinchester/Desktop/JFM/6_3_minus.csv")
%% second table
Pr_list = [1e-2 1e-1 1 10 100];
Nu_table = zeros(length(Ra_list),length(Pr_list));
for i=1:length(Pr_list)
    Pr = Pr_list(i);
    for j=1:length(Ra_list)
        Ra = Ra_list(j);
        % check which res
        if Ra <= 3e3
            N = 64;
        elseif Ra <= 6e5
            N = 152;
        elseif Ra <= 4e6
            N = 256;
        elseif Ra <= 3e7
            N = 400;
        end
        Nu = CalculateNusselt(Data,G,Ra,Pr,N);
        Nu_table(j,i) = Nu;
    end
end
Nu_table = round(Nu_table,6,'significant');
writematrix(Nu_table,"/Users/philipwinchester/Desktop/JFM/comp.csv")
%% third table
Pr_list = [1e3 1e4 1e5 1e6];
Nu_table = zeros(length(Ra_list),length(Pr_list));
for i=1:length(Pr_list)
    Pr = Pr_list(i);
    for j=1:length(Ra_list)
        Ra = Ra_list(j);
        % check which res
        if Ra <= 3e3
            N = 64;
        elseif Ra <= 6e5
            N = 152;
        elseif Ra <= 4e6
            N = 256;
        elseif Ra <= 3e7
            N = 400;
        end
        Nu = CalculateNusselt(Data,G,Ra,Pr,N);
        Nu_table(j,i) = Nu;
    end
end
Nu_table = round(Nu_table,6,'significant');
writematrix(Nu_table,"/Users/philipwinchester/Desktop/JFM/3_6_plus.csv")
