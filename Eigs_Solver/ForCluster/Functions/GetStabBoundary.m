function [Ra_list,Pr_list] = GetStabBoundary(Data,varargin)
AR = "AR_2";
type_list = ["OneOne400" "OneOne320" "OneOne256" "OneOne152" "OneOne128" "OneOne200" "OneOne172" "OneOne100" "OneOne88" "OneOne64"];
%addpath('/Users/philipwinchester/Dropbox/Matlab/Normal/Functions');
%addpath('/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions');

%% cleaning
Data.AR_2.OneOne152 = rmfield(Data.AR_2.OneOne152, "Pr_0_7");
Data.AR_2.OneOne152 = rmfield(Data.AR_2.OneOne152, "Pr_0_6");
Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_7_6");
Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_7_8");
Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_8_55");
Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_8_53");
Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_8_58");
Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_8_55");
Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_8_53");
Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_8_58");
Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_8_6");
Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_8_61");
% above we might want to remove for good
% below are just for this bit
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_30000");
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_60000");
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_100000");
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_8_5");
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_8_52");
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_8_54");
Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_0_01");
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_110000");
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_120000");
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_130000");
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_160000");
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_200000");
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_210000");
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_220000");
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_230000");
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_260000");
Data.AR_2.OneOne172 = rmfield(Data.AR_2.OneOne172, "Pr_5");
Data.AR_2.OneOne152.Pr_0_1 = rmfield(Data.AR_2.OneOne152.Pr_0_1, "Ra_1e6");
Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_0_0548");
Data.AR_2.OneOne152 = rmfield(Data.AR_2.OneOne152, "Pr_0_0181");


% FOR NOW ONLY
%Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_5");
Data.AR_2.OneOne400 = rmfield(Data.AR_2.OneOne400, "Pr_220000");
Data.AR_2.OneOne400 = rmfield(Data.AR_2.OneOne400, "Pr_230000");
Data.AR_2.OneOne400 = rmfield(Data.AR_2.OneOne400, "Pr_260000");
Data.AR_2.OneOne400 = rmfield(Data.AR_2.OneOne400, "Pr_210000");
Data.AR_2.OneOne400 = rmfield(Data.AR_2.OneOne400, "Pr_800000");
Data.AR_2.OneOne400 = rmfield(Data.AR_2.OneOne400, "Pr_600000");

%%
maxPr = 100; % defining some max Pr we consider
minPr = 0.01; % defining some min Pr we consider
PrS_list = [];
for i = 1:length(type_list)
    type = type_list(i);
    try
    PrS_list_inst = string(fields(Data.(AR).(type)));
    PrS_list = [PrS_list; PrS_list_inst];
    catch
    end
end
PrS_list = RemoveStringDuplicatesPr(PrS_list, maxPr, minPr);
[PrS_list, ~]= OrderPrS_list(PrS_list); % Now we have all of our PrS;



%% get crossings

for i=1:length(PrS_list)
    PrS = PrS_list(i);
    Pr = PrStoPr(PrS);
    M = GetFullM(Data, PrS, AR,"");
    PlotData.(PrS).v = CrossingVector(M);
end

PrSmax = "Pr_4_98"; % will change 
PrSmin = "Pr_9_53"; 
PrSmaxloc = find(PrS_list == PrSmax);
PrSminloc = find(PrS_list == PrSmin);

%%
Pr_list = [];
Ra_list = [];
% first monotonically increasing bit until PrSmax
for i=1:PrSmaxloc
    PrS = PrS_list(i);
    Pr = PrStoPr(PrS);
    M = GetFullM(Data, PrS, AR,"");
    v = CrossingVector(M);
    Ra_list = [Ra_list v];
    Pr_list = [Pr_list Pr*ones(1,length(v))];
end
[Ra_list, I] = sort(Ra_list);
Pr_list = Pr_list(I);
% monotonically decreasing bit
Pr_listinst = [];
Ra_listinst = [];
for i=PrSmaxloc:PrSminloc
    PrS = PrS_list(i);
    Pr = PrStoPr(PrS);
    M = GetFullM(Data, PrS, AR,"");
    v = CrossingVector(M);
    Ra_listinst = [Ra_listinst v];
    Pr_listinst = [Pr_listinst Pr*ones(1,length(v))];
end
[Ra_listinst, I] = sort(Ra_listinst,'descend');
Pr_listinst = Pr_listinst(I);
Ra_list = [Ra_list Ra_listinst];
Pr_list = [Pr_list Pr_listinst];
% second monotonically increasing bit
Pr_listinst = [];
Ra_listinst = [];
for i=PrSminloc:length(PrS_list)
    PrS = PrS_list(i);
    Pr = PrStoPr(PrS);
    M = GetFullM(Data, PrS, AR,"");
    v = CrossingVector(M);
    Ra_listinst = [Ra_listinst v];
    Pr_listinst = [Pr_listinst Pr*ones(1,length(v))];
end
[Ra_listinst, I] = sort(Ra_listinst);
Pr_listinst = Pr_listinst(I);
Ra_list = [Ra_list Ra_listinst];
Pr_list = [Pr_list Pr_listinst];

%% do zero stuff
if not(isempty(varargin))
PrZeroData = varargin{1};
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions/';
fpath2 = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/PrZero/Functions/';
fpath4 = '/Users/philipwinchester/Dropbox/Matlab/Normal/Functions/';
addpath(fpath)
addpath(fpath2)
addpath(fpath4)
% Loading in the old data
RaC = 8*pi^4;


PrS_list = [string(fields(PrZeroData.G_2.N_32)); string(fields(PrZeroData.G_2.N_64))];
PrS_list(PrS_list == "Pr_2_6e_2") = [];
PrS_list(PrS_list == "Pr_2_5e_2") = [];
PrS_list(PrS_list == "Pr_2_4e_2") = [];
PrS_list(PrS_list == "Pr_2_3e_2") = [];
PrS_list(PrS_list == "Pr_3e_2") = [];
PrS_list(PrS_list == "Pr_1e14") = [];

Pr_list2 = [];
RaA_list2 = [];





for i=1:length(PrS_list)
    PrS = PrS_list(i);
    Pr = PrStoPrZero(PrS);
    D = GetFullMZero(PrZeroData,"G_2",PrS,"Odd",["N_32" "N_64"]);
    RaA_add = GetCrossings(D);
    Pr_add = ones(1,length(RaA_add))*Pr;
    Pr_list2 = [Pr_list2 Pr_add];
    RaA_list2 = [RaA_list2 RaA_add];
end


[RaA_list2, I] = sort(RaA_list2);
Pr_list2 = Pr_list2(I);

%% combining
Pr_list = [Pr_list2 Pr_list];
Ra_list2 = RaA_list2 + RaC;
Ra_list = [Ra_list2 Ra_list];
end

%% now add large Pr stuff
maxPr = 1e6; % defining some max Pr we consider
minPr = 1e2; % defining some min Pr we consider
PrS_list = [];
for i = 1:length(type_list)
    type = type_list(i);
    try
        PrS_list_inst = string(fields(Data.(AR).(type)));
        PrS_list = [PrS_list; PrS_list_inst];
    catch
    end
end
PrS_list = RemoveStringDuplicatesPr(PrS_list, maxPr, minPr);
[PrS_list] = OrderPrS_list(PrS_list); % Now we have all of our PrS;


%%
Pr_zonal = [];
Ra_zonal = [];
Pr_nonzonal = [];
Ra_nonzonal = [];

% Do until we change method
PrSChange = "Pr_160000";
PrSChangeloc  = find(PrS_list == PrSChange );
for i=1:PrSChangeloc
    PrS = PrS_list(i);
    Pr = PrStoPr(PrS);
    M = GetFullM(Data, PrS, AR,"");
    v = CrossingVector(M);
    Ra_zonal = [Ra_zonal v];
    Pr_zonal = [Pr_zonal Pr*ones(1,length(v))];
end
% get remaining zonal
for i=PrSChangeloc+1:length(PrS_list)
    PrS = PrS_list(i);
    Pr = PrStoPr(PrS);
    try
        A = GetFullMZonal(Data, PrS);
        [~,Ra] = GetNextRaNonLinear(A);
        Ra_zonal = [Ra_zonal Ra];
        Pr_zonal = [Pr_zonal Pr];
    catch
    end
end
% get remaining nonzonal
for i=1:length(PrS_list)
    PrS = PrS_list(i);
    Pr = PrStoPr(PrS);
    try
        A = GetFullMNonZonal(Data, PrS);
        [~,Ra] = GetNextRaNonLinear(A);
        Ra_nonzonal = [Ra_nonzonal Ra];
        Pr_nonzonal = [Pr_nonzonal Pr];
    catch
    end
end
Ra_nonzonal = [Ra_nonzonal 2.54e7];
Pr_nonzonal = [Pr_nonzonal 1e6];

%% making minimum
Pr_list2 = [];
Ra_list2 = [];
for i=1:length(PrS_list)
    PrS = PrS_list(i);
    Pr = PrStoPr(PrS);
    try
        I =  find(Pr_zonal == Pr);
        zonal = Ra_zonal(I);
    catch
        zonal = 1e8; % some large number
    end
    try
        I =  find(Pr_nonzonal == Pr);
        nonzonal = Ra_nonzonal(I);
    catch
        nonzonal = 1e8; % some large number
    end
    Pr_list2 = [Pr_list2 Pr];
    if length(min([nonzonal zonal])) == 0
        Pr
        PrS
    end
    Ra_list2 = [Ra_list2 min([nonzonal zonal])];
end

%% combining
Pr_list = [Pr_list Pr_list2];
Ra_list = [Ra_list Ra_list2];
%% remove duplicats next to each other


end

