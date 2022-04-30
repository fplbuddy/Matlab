function data = GetExpAndPF(Pr_list2, AR, AllData)
ay = [];
aE = [];
Ay = [];
AE = [];
ax = [];
Ax = [];

for i=1:length(Pr_list2)
    Pr = Pr_list2(i);
    run SomeInputStuff.m
    Ra = [];
    ExShearing = [];
    EyShearing = [];
    Ra_list = string(fieldnames(AllData.(ARS).(PrS)));
    for i=1:length(Ra_list)
        if (isfield(AllData.(ARS).(PrS).(Ra_list(i)),'ICT') && not(isnan(AllData.(ARS).(PrS).(Ra_list(i)).calcs.sExmean))) % Make sure that we have shearing
            Ra = [Ra AllData.(ARS).(PrS).(Ra_list(i)).Ra];
            ExShearingAdd = AllData.(ARS).(PrS).(Ra_list(i)).calcs.sExmean;
            EyShearingAdd = AllData.(ARS).(PrS).(Ra_list(i)).calcs.sEymean;
            ExShearing = [ExShearing ExShearingAdd];
            EyShearing = [EyShearing EyShearingAdd];
        end
    end
    % Sorting
    [Ra, I] = sort(Ra);
    ExShearing = ExShearing(I);
    EyShearing = EyShearing(I);
    EShearing = ExShearing + EyShearing;
    % Saving in data
    data.(['Pr_' num2str(Pr)]).ExShearing = ExShearing;
    data.(['Pr_' num2str(Pr)]).EyShearing = EyShearing;
    data.(['Pr_' num2str(Pr)]).EShearing = EShearing;
    data.(['Pr_' num2str(Pr)]).Ra = Ra;
    data.(['Pr_' num2str(Pr)]).Pr = Pr;
    
    [alphay, AAy, xFitted, yFitted, Rval] = FitsPowerLaw(Ra,EyShearing);
    [alphaE, AAE, xFitted, yFitted, Rval] = FitsPowerLaw(Ra,EShearing);
    [alphax, AAx, xFitted, yFitted, Rval] = Fitslogx(Ra,sqrt(ExShearing));
    
    ay = [ay alphay];
    aE = [aE alphaE];
    ax = [ax alphax];
    Ay = [Ay AAy];
    AE = [AE AAE];
    Ax = [Ax AAx];
    
    clear Ra Ra_list
end
data.ay = ay;
data.aE = aE;
data.Ay = Ay;
data.AE = AE;
data.ax = ax;
data.Ax = Ax;
end