function AllData = MeanQuantities(AllData,errprop)
% Data we want to extract and their position
kenergy_quants.ken = 2;
kenergy_quants.denk = 3;
kenergy_quants.fenk = 4;
kenergy_quants.Ex = 5;
kenergy_quants.Ey = 6;
kpsmodes1_quants.ZeroOne = 2;
penergy_quants.pen = 2;
penergy_quants.denp = 3;

AR_list =string(fieldnames(AllData));
for i=1:length(AR_list)
    ARS = AR_list(i);
    Pr_list = string(fieldnames(AllData.(ARS)));
    for j=1:length(Pr_list)
        PrS = Pr_list(j);
        Ra_list = string(fieldnames(AllData.(ARS).(PrS)));
        for k=1:length(Ra_list)
            RaS = Ra_list(k);
            if isfield(AllData.(ARS).(PrS).(RaS),'ICT')
                path =AllData.(ARS).(PrS).(RaS).path;
                xlower = AllData.(ARS).(PrS).(RaS).ICT;
                try % wont work for Pr = inf
                    kenergy = importdata([convertStringsToChars(path) '/Checks/kenergy.txt']);
                    kpsmodes1 = importdata([convertStringsToChars(path) '/Checks/kpsmodes1.txt']);
                    % remove xlower
                    kenergy = kenergy(xlower:end,:); kpsmodes1 = kpsmodes1(xlower:end,:);
                    % do kenergy first
                    t = kenergy(:,1);
                    top = round((length(t)*errprop/100));
                    field_list = string(fields(kenergy_quants));
                    for l =1:length(field_list)
                        field =  convertStringsToChars(field_list(l));
                        Loc = kenergy_quants.(field);
                        Signal = kenergy(:,Loc);
                        AllData.(ARS).(PrS).(RaS).calcs.(field) = MyMeanEasy(Signal,t);
                        % do error
                        AllData.(ARS).(PrS).(RaS).calcs.([field 'err' num2str(errprop)]) = MyMeanEasy(Signal(1:top),t(1:top));
                    end
                    % do kpsmodes1 first
                    t = kpsmodes1(:,1);
                    top = round((length(t)*errprop/100));
                    field_list = string(fields(kpsmodes1_quants));
                    for l =1:length(field_list)
                        field =  convertStringsToChars(field_list(l));
                        Loc = kpsmodes1_quants.(field);
                        Signal = kpsmodes1(:,Loc);
                        AllData.(ARS).(PrS).(RaS).calcs.(field) = MyMeanEasy(Signal,t);
                        % do error
                        AllData.(ARS).(PrS).(RaS).calcs.([field 'err' num2str(errprop)]) = MyMeanEasy(Signal(1:top),t(1:top));
                    end
                    %                     % this is all the right positions for 2.5.1
                    %                     t = kenergy(:,1); ken = kenergy(:,2); denk = kenergy(:,3); fenk = kenergy(:,4); Ex = kenergy(:,5); Ey = kenergy(:,6);
                    %                     t = t(xlower:end); ken = ken(xlower:end); denk = denk(xlower:end); fenk = fenk(xlower:end); Ex = Ex(xlower:end); Ey = Ey(xlower:end);
                    %                     AllData.(ARS).(PrS).(RaS).calcs.ken = MyMeanEasy(ken,t);
                    %                     AllData.(ARS).(PrS).(RaS).calcs.Ex = MyMeanEasy(Ex,t);
                    %                     AllData.(ARS).(PrS).(RaS).calcs.Ey = MyMeanEasy(Ey,t);
                    %                     AllData.(ARS).(PrS).(RaS).calcs.fenk = MyMeanEasy(fenk,t);
                    %                     AllData.(ARS).(PrS).(RaS).calcs.denk = MyMeanEasy(denk,t);
                    %                     % do some errors
                    %                     top = round((length(t)*errprop/100));
                    %                     t = t(1:top);ken = ken(1:top); denk = denk(1:top); fenk = fenk(1:top); Ex = Ex(1:top); Ey = Ey(1:top);
                    %                     AllData.(ARS).(PrS).(RaS).calcs.(['kenerr' num2str(errprop)]) = MyMeanEasy(ken,t);
                    %                     AllData.(ARS).(PrS).(RaS).calcs.(['Exerr' num2str(errprop)]) = MyMeanEasy(Ex,t);
                    %                     AllData.(ARS).(PrS).(RaS).calcs.(['Eyerr' num2str(errprop)]) = MyMeanEasy(Ey,t);
                    %                     AllData.(ARS).(PrS).(RaS).calcs.(['fenkerr' num2str(errprop)]) = MyMeanEasy(fenk,t);
                    %                     AllData.(ARS).(PrS).(RaS).calcs.(['denkerr' num2str(errprop)]) = MyMeanEasy(denk,t);
                    %                     % Get zero one
                    %                     t = kpsmodes1(:,1); t = t(xlower:end);
                    %                     ZeroOne = kpsmodes1(:,2);  ZeroOne = ZeroOne(xlower:end);
                    %                     AllData.(ARS).(PrS).(RaS).calcs.ZeroOne = MyMeanEasy(ZeroOne,t);
                    %                     % get error
                    %                     top = round((length(t)*errprop/100));
                    %                     t = t(1:top); ZeroOne = ZeroOne(1:top);
                    %                     AllData.(ARS).(PrS).(RaS).calcs.(['ZeroOneerr' num2str(errprop)]) = MyMeanEasy(ZeroOne,t);
                catch
                end
                %                 penergy = importdata([convertStringsToChars(path) '/Checks/penergy.txt']);
                %                 t = penergy(:,1);
                %                 pen = penergy(:,2); denp = penergy(:,3);
                %                 pen = pen(xlower:end); denp = denp(xlower:end); t = t(xlower:end);
                %                 AllData.(ARS).(PrS).(RaS).calcs.pen = MyMeanEasy(pen,t);
                %                 AllData.(ARS).(PrS).(RaS).calcs.denp = MyMeanEasy(denp,t);
                %                 % get error
                %                 top = round((length(t)*errprop/100));
                %                 t = t(1:top); pen = pen(1:top); denp = denp(1:top);
                %                 AllData.(ARS).(PrS).(RaS).calcs.(['penerr' num2str(errprop)]) = MyMeanEasy(pen,t);
                %                 AllData.(ARS).(PrS).(RaS).calcs.(['denperr' num2str(errprop)]) = MyMeanEasy(denp,t);
                penergy = importdata([convertStringsToChars(path) '/Checks/penergy.txt']);
                % remove xlower
                penergy = penergy(xlower:end,:);
                % do kenergy first
                t = penergy(:,1);
                top = round((length(t)*errprop/100));
                field_list = string(fields(penergy_quants));
                for l =1:length(field_list)
                    field =  convertStringsToChars(field_list(l));
                    Loc = penergy_quants.(field);
                    Signal = penergy(:,Loc);
                    AllData.(ARS).(PrS).(RaS).calcs.(field) = MyMeanEasy(Signal,t);
                    % do error
                    AllData.(ARS).(PrS).(RaS).calcs.([field 'err' num2str(errprop)]) = MyMeanEasy(Signal(1:top),t(1:top));
                end
            end
        end
    end
end
end

