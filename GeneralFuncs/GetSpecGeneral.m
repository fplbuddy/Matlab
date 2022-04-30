function Data = GetSpecGeneral(path,tcrit,fields,loc)
% fields holds the different fields
% loc is location of where the data is
spath = [path '/Spectra/'];
times = importdata([spath 'spec_times.txt']);
rem = times(:,2) < tcrit;
for i=1:length(rem)
    if rem(i)
        times(1,:) = []; % removing outputs which are before tcrit
    end
end
% looping round fields
for j=1:length(fields)
    field = convertStringsToChars(fields(j));
    for i=1:length(times)
        inst = num2str(times(i,1));
        while length(inst) < 4
            inst = ['0' inst];
        end
        flux  = importdata([spath field '.' inst '.txt']);
        flux = flux(:,loc);
        if i == 1
            total = flux;
        else
            %%% hacky thing to deal with NaNs
            nan_list = isnan(flux);
            if sum(nan_list) > 0 % then we do have a nan
                nanloc = find(isnan(flux),1);
                flux = flux(1:nanloc-2);
                % Addind zero to remaining
                flux = [flux; zeros(length(total)-length(flux),1)];     
            end
            %%%
            total = total + flux;
        end
    end
    Data.(field) = total/length(times);
end
end

