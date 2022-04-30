AR = "AR_2";
type_list = ["OneOne400" "OneOne320" "OneOne256" "OneOne152" "OneOne128" "OneOne200" "OneOne172" "OneOne100" "OneOne88" "OneOne64"];
addpath('/Users/philipwinchester/Dropbox/Matlab/Normal/Functions');
addpath('/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions');

%% cleaning

% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_0_1");
% Data.AR_2.OneOne88 = rmfield(Data.AR_2.OneOne88, "Pr_0_1");
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_0_1");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_0_2");
% Data.AR_2.OneOne88 = rmfield(Data.AR_2.OneOne88, "Pr_0_2");
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_0_2");
% Data.AR_2.OneOne128 = rmfield(Data.AR_2.OneOne128, "Pr_0_3");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_0_3");
% Data.AR_2.OneOne88 = rmfield(Data.AR_2.OneOne88, "Pr_0_3");
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_0_3");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_0_4");
% Data.AR_2.OneOne88 = rmfield(Data.AR_2.OneOne88, "Pr_0_4");
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_0_4");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_0_5");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_0_6");
% Data.AR_2.OneOne88 = rmfield(Data.AR_2.OneOne88, "Pr_0_6");
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_0_6");
% Data.AR_2.OneOne88 = rmfield(Data.AR_2.OneOne88, "Pr_0_7");
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_0_7");
% Data.AR_2.OneOne152 = rmfield(Data.AR_2.OneOne152, "Pr_0_8");
% Data.AR_2.OneOne88 = rmfield(Data.AR_2.OneOne88, "Pr_0_8");
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_0_8");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_0_9");
% Data.AR_2.OneOne88 = rmfield(Data.AR_2.OneOne88, "Pr_0_9");
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_0_9");
% Data.AR_2.OneOne88 = rmfield(Data.AR_2.OneOne88, "Pr_1");
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_1");
% Data.AR_2.OneOne88 = rmfield(Data.AR_2.OneOne88, "Pr_2");
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_2");
% Data.AR_2.OneOne88 = rmfield(Data.AR_2.OneOne88, "Pr_3");
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_3");
% Data.AR_2.OneOne88 = rmfield(Data.AR_2.OneOne88, "Pr_4");
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_4");
% Data.AR_2.OneOne88 = rmfield(Data.AR_2.OneOne88, "Pr_5");
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_5");
% Data.AR_2.OneOne88 = rmfield(Data.AR_2.OneOne88, "Pr_6");
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_6");
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_7");
% Data.AR_2.OneOne152 = rmfield(Data.AR_2.OneOne152, "Pr_7");
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_8");
% Data.AR_2.OneOne200 = rmfield(Data.AR_2.OneOne200, "Pr_30000");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_30000");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_60000");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_100000");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_200000");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_300000");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_600000");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_1000000");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_0_31");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_0_311");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_0_312");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_0_313");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_0_314");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_0_315");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_0_319");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_0_32");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_0_33");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_0_35");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_0_38");
% Data.AR_2.OneOne172 = rmfield(Data.AR_2.OneOne172, "Pr_0_8");
% Data.AR_2.OneOne172 = rmfield(Data.AR_2.OneOne172, "Pr_0_9");
% Data.AR_2.OneOne172 = rmfield(Data.AR_2.OneOne172, "Pr_1");
% Data.AR_2.OneOne172 = rmfield(Data.AR_2.OneOne172, "Pr_60000");
% Data.AR_2.OneOne172 = rmfield(Data.AR_2.OneOne172, "Pr_30000");
% Data.AR_2.OneOne172 = rmfield(Data.AR_2.OneOne172, "Pr_20000");
% Data.AR_2.OneOne172 = rmfield(Data.AR_2.OneOne172, "Pr_10000");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_20000");
% 
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_100000000");
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_10000000000");
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_100000000000");
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_1000000000000");
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_10000000000000");
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_100000000000000");
% Data.AR_2.OneOne64 = rmfield(Data.AR_2.OneOne64, "Pr_1000000000000000");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_10_317");
% Data.AR_2.OneOne100 = rmfield(Data.AR_2.OneOne100, "Pr_6000");
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
% above we might want to remove for good
% below are just for this bit
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_30000");
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_60000");
Data.AR_2.OneOne256 = rmfield(Data.AR_2.OneOne256, "Pr_100000");


% FOR NOW ONLY
%%
PrS_list = [];
for i = 1:length(type_list)
    type = type_list(i);
    try
    PrS_list_inst = string(fields(Data.(AR).(type)));
    PrS_list = [PrS_list; PrS_list_inst];
    catch
    end
end
PrS_list = RemoveStringDuplicates(PrS_list);
[PrS_list, ~]= OrderPrS_list(PrS_list); % Now we have all of our PrS;

%% checking duplicates
% for i=1:length(PrS_list)
%     PrS = PrS_list(i);
%     types = [];
%     for j=1:length(type_list)
%         type = type_list(j);
%         try
%         if isfield(Data.(AR).(type), PrS)
%             types = [types type];
%         end
%         catch
%         end
%     end
%     if length(types) > 1
%        PrS 
%        types
%     end  
% end


%% get crossings

for i=1:length(PrS_list)
    PrS = PrS_list(i);
    Pr = PrStoPr(PrS);
    M = GetFullM(Data, PrS, AR,"");
    PlotData.(PrS).v = CrossingVector(M);
end
PrSEnd = "Pr_8_61";
PrSStart = "Pr_6_17";
PrLower = "Pr_1";
PrSEndloc = find(PrS_list == PrSEnd);
PrSStartloc = find(PrS_list == PrSStart);
PrLowerloc = find(PrS_list == PrLower);


%% 
Pr_list1 = [];
Ra_list1 = [];
% fist weird bit
for i=1:PrLowerloc
    PrS = PrS_list(i);
    Pr = PrStoPr(PrS);
    M = GetFullM(Data, PrS, AR,"");
    v = CrossingVector(M);
    Ra_list1 = [Ra_list1 v];
    if length(v) == 3
        Pr_list1 = [Pr_list1 Pr*ones(1,3)];
    elseif length(v) == 1
       Pr_list1 = [Pr_list1 Pr*ones(1,1)]; 
    elseif isempty(v)
        continue
    else
        error
    end 
end
[Ra_list1, I] = sort(Ra_list1);
Pr_list1 = Pr_list1(I);

% Get first top line, 1 or 3
for i=PrLowerloc:PrSEndloc
    PrS = PrS_list(i);
    v =  PlotData.(PrS).v;
    if length(v) == 3 || length(v) == 1
        Pr = PrStoPr(PrS);
        Ra = v(end);
        Pr_list1 = [Pr_list1 Pr];
        Ra_list1 = [Ra_list1 Ra];
    end
end
% Getting intermidiate
for i=PrSEndloc:-1:PrSStartloc
    PrS = PrS_list(i);
    v =  PlotData.(PrS).v;
    if length(v) == 3 || length(v) == 2
        Pr = PrStoPr(PrS);
        Ra = v(2);
        Pr_list1 = [Pr_list1 Pr];
        Ra_list1 = [Ra_list1 Ra];
    end
    
end
% Getting end
for i=PrSStartloc:length(PrS_list)
    PrS = PrS_list(i);
    v =  PlotData.(PrS).v;
    Pr = PrStoPr(PrS);
    Ra = v(1);
    Pr_list1 = [Pr_list1 Pr];
    Ra_list1 = [Ra_list1 Ra];  
end

%%
% check = PrS_list(8:53);
% type_check = ["OneOne200" "OneOne172" "OneOne100" "OneOne88" "OneOne64"];
% for i=1:length(check)
%     PrS = check(i);
%     types = [];
%     for j=1:length(type_check)
%         type = type_check(j);
%         if isfield(Data.(AR).(type), PrS)
%              types = [types type];
%         end
%      end
%      if ~isempty(types)
%         PrS 
%         types
%      end 
%         
% end

%% do zero stuff
fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions/';
fpath2 = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/PrZero/Functions/';
fpath4 = '/Users/philipwinchester/Dropbox/Matlab/Normal/Functions/';
addpath(fpath)
addpath(fpath2)
addpath(fpath4)
% Loading in the old data
dpath = '/Volumes/Samsung_T5/OldData/PrZeroData.mat';
load(dpath);
RaC = 8*pi^4;


PrS_list = [string(fields(PrZeroData.N_32)); string(fields(PrZeroData.N_64))];
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
    D = GetFullMZero(PrZeroData,PrS);
    RaA_add = GetCrossings(D);
    Pr_add = ones(1,length(RaA_add))*Pr;
    Pr_list2 = [Pr_list2 Pr_add];
    RaA_list2 = [RaA_list2 RaA_add];
end


[RaA_list2, I] = sort(RaA_list2);
Pr_list2 = Pr_list2(I);

%% combining
Pr_list = [Pr_list2 Pr_list1];
Ra_list2 = RaA_list2 + RaC;
Ra_list = [Ra_list2 Ra_list1];