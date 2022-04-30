function AllData = MeanQuantitiesPeriodic(AllData,errprop)
% Data we want to extract and their position
kenergy_quants.ken = 2;
kenergy_quants.denk = 3;
kenergy_quants.fenk = 4;
kenergy_quants.henk = 5;
penergy_quants.pen = 2;
penergy_quants.denp = 3;

names = string(unnest_fields(AllData, 'AllData'));
names = names(contains(names,'trans'));
for i = 1:length(names)
    name = names(i);
    name = split(name,'.');
    res = name(2); o1S = name(3); o2S = name(4); fS = name(5); hnuS = name(6); nuS = name(7); kappaS = name(8);
    path = AllData.(res).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).path;
    xlower = AllData.(res).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).trans;
    kenergy = importdata([convertStringsToChars(path) '/Checks/kenergy.txt']);
    penergy = importdata([convertStringsToChars(path) '/Checks/penergy.txt']);
    % remove xlower
    kenergy = kenergy(xlower:end,:); penergy = penergy(xlower:end,:);
    % do kenergy first
    t = kenergy(:,1);
    top = round((length(t)*errprop/100));
    field_list = string(fields(kenergy_quants));
    for l =1:length(field_list)
        field =  convertStringsToChars(field_list(l));
        Loc = kenergy_quants.(field);
        Signal = kenergy(:,Loc);
        AllData.(res).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).calcs.(field) = MyMeanEasy(Signal,t);
        % do error
        AllData.(res).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).calcs.([field 'err' num2str(errprop)]) = MyMeanEasy(Signal(1:top),t(1:top));
    end
    % do penergy first
    t = penergy(:,1);
    top = round((length(t)*errprop/100));
    field_list = string(fields(penergy_quants));
    for l =1:length(field_list)
        field =  convertStringsToChars(field_list(l));
        Loc = penergy_quants.(field);
        Signal = penergy(:,Loc);
        AllData.(res).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).calcs.(field) = MyMeanEasy(Signal,t);
        % do error
        AllData.(res).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).calcs.([field 'err' num2str(errprop)]) = MyMeanEasy(Signal(1:top),t(1:top));
    end
end
end

