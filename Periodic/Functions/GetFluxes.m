function [Kresult,Presult] = GetFluxes(path,tcrit)

spath = [path '/Spectra/'];
times = importdata([spath 'spec_times.txt']);
rem = times(:,2) < tcrit;
for i=1:length(rem)
    if rem(i)
        times(1,:) = []; % removing outputs which are before tcrit
    end
end
%% Energy flux firsts
for i=1:length(times)
    inst = num2str(times(i,1));
    while length(inst) < 4
        inst = ['0' inst];
    end
    flux  = importdata([spath 'vectrans_euu.' inst '.txt']);
    if i == 1
        totalflux = flux;
    else
        totalflux = totalflux + flux;
    end
end
% take average
totalflux = -totalflux/length(times); % minus sign means that we get u dot (u dot nabla)u
% follwing convention in Alexakis. Ie, only consider wavenumbers that are
% smallers. UPDATE: This was slighlty missleading. The notation in Alexakis
% is actually that we consider all of them up to the one AND INCLUDING
% where we are at.
for i=1:length(totalflux)
    Kresult(i) = sum(totalflux(1:i));
end

%% entropy flux
for i=1:length(times)
    inst = num2str(times(i,1));
    while length(inst) < 4
        inst = ['0' inst];
    end
    flux  = importdata([spath 'vectrans_puu.' inst '.txt']);
    if i == 1
        totalflux = flux;
    else
        totalflux = totalflux + flux;
    end
end
% take average
totalflux = totalflux/length(times); % dont need minus sign here
for i=1:length(totalflux)
    Presult(i) = sum(totalflux(1:i));
end
end

