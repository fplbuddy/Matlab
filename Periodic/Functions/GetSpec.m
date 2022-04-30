function [Ktotal,Ptotal] = GetSpec(path,tcrit)

spath = [path '/Spectra/'];
times = importdata([spath 'spec_times.txt']);
rem = times(:,2) < tcrit;
for i=1:length(rem)
    if rem(i)
        times(1,:) = []; % removing outputs which are before tcrit
    end
end
%% kinetic spectra
for i=1:length(times)
    inst = num2str(times(i,1));
    while length(inst) < 4
        inst = ['0' inst];
    end
    flux  = importdata([spath 'KEspec' inst '.txt']);
    if i == 1
        total = flux;
    else
        total = total + flux;
    end
end
Ktotal = total/length(times);

%% potential spectra
for i=1:length(times)
    inst = num2str(times(i,1));
    while length(inst) < 4
        inst = ['0' inst];
    end
    flux  = importdata([spath 'PEspec' inst '.txt']);
    if i == 1
        total = flux;
    else
        total = total + flux;
    end
end
Ptotal = total/length(times);
end

