function [shearing,nonshearing,numshearing,numnonshearing] = GetDataForSpectra(AllData,Pr,Ra, G,Spectrum)
PrS = PrtoPrS(Pr);
RaS = RatoRaS(Ra); 
ARS = ['AR_' num2str(G)];
xlower = AllData.(ARS).(PrS).(RaS).ICT;

kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes1.txt']);
t = kpsmodes1(:,1);
t = t(xlower:end);
t = reshape(t, 1, length(t));
ZeroOne = kpsmodes1(:,2);
ZeroOne = ZeroOne(xlower:end);

path = [convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Spectra/'];
Times = importdata([path 'spec_times.txt']);
start = Times(1,1);

% Setting up the time vectors, number is there for tollerance later
post = [1e8];
negt = [1e8];
zerot = [1e8];

% Finding pos shearing times
for i=1:length(AllData.(ARS).(PrS).(RaS).calcs.pos)
    section = AllData.(ARS).(PrS).(RaS).calcs.pos{i};
    post = [post t(AllData.(ARS).(PrS).(RaS).calcs.pos{i})];
end
% Finding neg shearing times
for i=1:length(AllData.(ARS).(PrS).(RaS).calcs.neg)
    section = AllData.(ARS).(PrS).(RaS).calcs.neg{i};
    negt = [negt t(AllData.(ARS).(PrS).(RaS).calcs.neg{i})];
end
% Finding zero times
for i=1:length(AllData.(ARS).(PrS).(RaS).calcs.zero)
    section = AllData.(ARS).(PrS).(RaS).calcs.zero{i};
    zerot = [zerot t(AllData.(ARS).(PrS).(RaS).calcs.zero{i})];
end
sheart = [post negt];

% Setting up the spectra vectors
data = importdata([path Spectrum '.000' num2str(start) '.txt']);
shearing = zeros(length(data),1); numshearing = 0;
nonshearing = zeros(length(data),1); numnonshearing = 0;

% Getting the data
for i = 1:length(Times)
    node = num2str(i+start-1);
    Time = Times(i,2);
    while length(node) < 4
        node = ['0' node];
    end
    data = importdata([path Spectrum '.' node '.txt']);
    data = data(:,2);
    if ismembertol(Time, sheart,1e-9) % Ie we are in shearing
        numshearing = numshearing + 1;
        shearing = shearing + data;
    elseif ismembertol(Time, zerot,1e-9) % Ie we are in nonshearing
        numnonshearing = numnonshearing + 1;
        nonshearing = nonshearing + data;
    end
end
shearing = shearing/numshearing;
nonshearing = nonshearing/numnonshearing;
end

