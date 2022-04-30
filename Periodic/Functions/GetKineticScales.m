function [euuresult,fenresult,denresult,henresult] = GetKineticScales(path,tcrit)
%%
spath = [path '/Spectra/'];
times = importdata([spath 'spec_times.txt']);
rem = times(:,2) < tcrit;
for i=1:length(rem)
   if rem(i)
       times(1,:) = []; % removing outputs which are before tcrit
   end
end
%% euu
for i=1:length(times)
    inst = num2str(times(i,1));
    while length(inst) < 4
        inst = ['0' inst];
    end
    flux  = importdata([spath 'vectrans_euu.' inst '.txt']); % Getting a vectrans instance
    if i == 1
        total = flux; % Initiating total
    else
       total = total + flux; % Added to total
    end
end

euuresult = total/length(times); % Take average 


%%
for i=1:length(times)
    inst = num2str(times(i,1));
    while length(inst) < 4
        inst = ['0' inst];
    end
    flux  = importdata([spath 'vectrans_fenktrans.' inst '.txt']); % Getting a vectrans instance
    if i == 1
        total = flux; % Initiating total
    else
       total = total + flux; % Added to total
    end
end

fenresult = total/length(times); % Take average 

%%
for i=1:length(times)
    inst = num2str(times(i,1));
    while length(inst) < 4
        inst = ['0' inst];
    end
    try
    flux  = importdata([spath 'vectrans_den.' inst '.txt']); % Getting a vectrans instance
    catch
            flux  = importdata([spath 'vectrans_denktrans.' inst '.txt']); % Getting a vectrans instance
    end
    if i == 1
        total = flux; % Initiating total
    else
       total = total + flux; % Added to total
    end
end

denresult = total/length(times); % Take average 

%%
for i=1:length(times)
    inst = num2str(times(i,1));
    while length(inst) < 4
        inst = ['0' inst];
    end
    try
        flux  = importdata([spath 'vectrans_hen.' inst '.txt']); % Getting a vectrans instance
    catch
        flux  = importdata([spath 'vectrans_henktrans.' inst '.txt']);
    end
    if i == 1
        total = flux; % Initiating total
    else
       total = total + flux; % Added to total
    end
end

henresult = total/length(times); % Take average 

end


