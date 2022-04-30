%% Get Data
addpath('/Users/philipwinchester/Dropbox/Matlab/Normal/WaitingTimeGamma1/Functions')
run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
G = 1;
ARS = ['AR_' num2str(G)];
Pr = 30;
PrS = ['Pr_' num2str(Pr)];
Ra = 5e5; RaS = normaltoS(Ra,'Ra',1); RaT = RatoRaT(Ra);
kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes1.txt']);
s = kpsmodes1(:,2);
t = kpsmodes1(:,1);
xlower = AllData.(ARS).(PrS).(RaS).ICT;
t = kpsmodes1(:,1); t = t(xlower:end);
s = kpsmodes1(:,2); s = s(xlower:end);
dt = mean(diff(t));
%%
thresh = mean(abs(s)); % point where we have a reversal
m = max(abs(s));
% range of psi values that we take into our model is form m to -thresh I
% guess

% now extract the sections that we have
Status = sign(s(1));
instswitch = [1];
for j=2:length(s)
    if Status == 1 % we are positive and going negative
        if s(j) < -thresh % we have switched!
            Status = -1;
            instswitch = [instswitch j];
        end
    else % we are negative and going posiive
        if s(j) > thresh % we have switched!
            Status = 1;
            instswitch = [instswitch j];
        end
    end
end
partitions = [instswitch length(t)]; % this is w

%% Now make our bins
bins_list = 40;
efm_list = zeros(1,length(bins_list));
for b=1:length(bins_list)
    bins = bins_list(b)
    total = m + thresh;
    binlength = total/bins; % should probably make bin length proportial to the average step size in psi_{0,1} or something
    binedges = [m m-(1:bins-1)*binlength -thresh];

    %% Make transition probability
    TM = zeros(bins,bins);
    for i=1:length(partitions)-1
       sint = s(partitions(i):partitions(i+1));
       if sign(sint(1)) == -1 % flip the sample if needed
           sint = -sint;
       end
       for j=1:length(sint)-1
           ref = sint(j);
           I = BinEdgeLower(binedges,ref,1,bins+1); % i is the bin that we're in
           %sample = log(sint(j+1)/ref); % get sample 
           sample = sint(j+1)-ref;
           % add to TM
           J = I + round(sample/binlength); % gives which one we're going to
           J = min(bins,J); % making sure in range
           J = max(1,J);
           TM(I,J) = TM(I,J)+1;
       end
    end
    for i = 1:bins
        TM(:,i) = TM(:,i)/sum(TM(:,i)); % normalising
    end
    TM = TM';
    % Make the final bin an obsorbing state
    v = zeros(1,bins); v(end) = 1;
    TM(bins,:) = v;

    % look at https://en.wikipedia.org/wiki/Absorbing_Markov_chain
    Q = TM(1:bins-1,1:bins-1);
%     N = inv(eye(bins-1)-Q);
%     t = N*ones(bins-1,1);
    t = (eye(bins-1)-Q)\ones(bins-1,1);
    loc = round(bins/3);
    efm_list(b) = t(loc);
end




