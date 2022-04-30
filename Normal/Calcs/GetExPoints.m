% Settting up vectors
if not(exist('PrShearingOwn','var')), PrShearingOwn = []; end
if not(exist('RaShearingOwn','var')), RaShearingOwn = []; end
if not(exist('ExEShearingOwn','var')), ExEShearingOwn = []; end
if not(exist('PrShearingShared','var')), PrShearingShared = []; end
if not(exist('RaShearingShared','var')), RaShearingShared = []; end
if not(exist('ExEShearingShared','var')), ExEShearingShared = []; end
if not(exist('PrNonShearingOwn','var')), PrNonShearingOwn = []; end
if not(exist('RaNonShearingOwn','var')), RaNonShearingOwn = []; end
if not(exist('ExENonShearingOwn','var')), ExENonShearingOwn = []; end
if not(exist('PrNonShearingShared','var')), PrNonShearingShared = []; end
if not(exist('RaNonShearingShared','var')), RaNonShearingShared = []; end
if not(exist('ExENonShearingShared','var')), ExENonShearingShared = []; end

Ra = AllData.(ARS).(PrS).(RaS).Ra;
Pr = AllData.(ARS).(PrS).(RaS).Pr;

% Saving data
if (isfield(AllData.(ARS).(PrS).(RaS),'ICT') && not(isnan(AllData.(ARS).(PrS).(RaS).calcs.sExmean)) && isnan(AllData.(ARS).(PrS).(RaS).calcs.zExmean))
    RaShearingOwn = [Ra RaShearingOwn];
    PrShearingOwn = [Pr PrShearingOwn];
    ExEShearingOwn = [AllData.(ARS).(PrS).(RaS).calcs.sExmean ExEShearingOwn];
elseif (isfield(AllData.(ARS).(PrS).(RaS),'ICT') && not(isnan(AllData.(ARS).(PrS).(RaS).calcs.sExmean)) && not(isnan(AllData.(ARS).(PrS).(RaS).calcs.zExmean)))
    RaShearingShared = [Ra RaShearingShared];
    PrShearingShared = [Pr PrShearingShared];
    ExEShearingShared = [AllData.(ARS).(PrS).(RaS).calcs.sExmean ExEShearingShared];
    RaNonShearingShared = [Ra RaNonShearingShared];
    PrNonShearingShared = [Pr PrNonShearingShared];
    ExENonShearingShared = [AllData.(ARS).(PrS).(RaS).calcs.zExmean ExENonShearingShared];
elseif (isfield(AllData.(ARS).(PrS).(RaS),'ICT') && isnan(AllData.(ARS).(PrS).(RaS).calcs.sExmean) && not(isnan(AllData.(ARS).(PrS).(RaS).calcs.zExmean)))
    RaNonShearingOwn = [Ra RaNonShearingOwn];
    PrNonShearingOwn = [Pr PrNonShearingOwn];
    ExENonShearingOwn = [AllData.(ARS).(PrS).(RaS).calcs.zExmean ExENonShearingOwn];
end
