fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions/';
addpath(fpath)
dpath = '/Volumes/Samsung_T5/OldData/masternew.mat';
load(dpath);

%% finding position of 0,1
N = 256;
n = [(-N/2):2:(N/2-1) (-N/2+1):2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:); 
m = 1:N; m = repelem(m, N/2);
[~,~,n,m] = GetRemGeneral(n,m,N);
loc = find(n==0);

%%
Pr_list = [1e4 3e4 6e4 1e5 3e5 1e6];
ZeroOne_list = zeros(length(Pr_list),1);
for i=1:length(Pr_list)
    Pr = Pr_list(i);
    PrS = PrtoPrS(Pr);
    RaS_list = string(fields(Data.AR_2.OneOne256.(PrS)));
    for j=1:length(RaS_list)
        RaS = RaS_list(j);
        try
        sigmaodd = Data.AR_2.OneOne256.(PrS).(RaS).sigmaodd; % will cause error for some
        check = abs(max(real(sigmaodd)));
        catch
            check = 100; % hacky
        end
        if j == 1
            atm = check;
            Ra = RaStoRa(RaS);
        else
            if atm > check
                atm = check;
                Ra = RaStoRa(RaS);
            end
        end
    end
    RaS = RatoRaS(Ra);
    Eigv = Data.AR_2.OneOne256.(PrS).(RaS).Eigv;
    ZeroOne_list(i) = sum(abs(Eigv(loc)));
end
