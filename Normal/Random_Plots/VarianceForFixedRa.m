%% Input
AR = 2;
Pr = 30; %3, 5, 10, 30,50, 100, 300, 200
run SomeInputStuff.m
%% Get data
Ra = [];
StanDev = [];
av = []; % Will just use normal mean to this one...

Ra_list = string(fieldnames(AllData.(ARS).(PrS)));
for i=1:length(Ra_list)
    if isfield(AllData.(ARS).(PrS).(Ra_list(i)),'ICT')
        Ra = [Ra AllData.(ARS).(PrS).(Ra_list(i)).Ra];
        kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(Ra_list(i)).path) '/Checks/kpsmodes1.txt']);
        Mode = kpsmodes1(:,2);
        % Get rid of transient
        Mode = Mode(AllData.(ARS).(PrS).(Ra_list(i)).ICT:end);
        
        % Only get points with shearing
        ShearingPos = [];
    
        shearing = [AllData.(ARS).(PrS).(Ra_list(i)).calcs.pos AllData.(ARS).(PrS).(Ra_list(i)).calcs.neg];
        for j=1:length(shearing)
            section = shearing{j};
            section(section > length(Mode)) = [];
            ShearingPos = [ShearingPos section];
        end
        av = [av mean(abs(Mode(ShearingPos)))];
        StanDev = [StanDev std(abs(Mode(ShearingPos)))];
    end
end
%% Plot
errorbar(Ra,av,StanDev*5,'r*'); 
set(gca, 'XScale', 'log'); 
