fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions/';
addpath(fpath)
RaS_list = string(fields(Data.AR_2.OneOne88.Pr_8));
RaS_list = OrderRaS_list(RaS_list);
Ra_list = [];
sigmaoddb = [];
fact_list = [];
fact_imag = [];
fact_real = [];
for i=1:length(RaS_list)
    RaS = RaS_list(i);
    Ra = Data.AR_2.OneOne88.Pr_8.(RaS).Ra;
    Ra_list = [Ra_list Ra];
    s = Data.AR_2.OneOne88.Pr_8.(RaS).sigmaoddbranch;
    sigmaoddb = [sigmaoddb s];
    try 
        RaSN = RaS_list(i+1);
        RaN = RaStoRa(RaSN);
        sigmaoddbN = Data.AR_2.OneOne88.Pr_8.(RaSN).sigmaoddbranch;
        fact_list = [fact_list RaN/Ra];
        fact_imag = [fact_imag imag(sigmaoddbN)/imag(s)];
        fact_real = [fact_real real(sigmaoddbN)/real(s)];
    catch
    end
end
DeltaSigma = abs(diff(sigmaoddb));
DeltaRa = abs(diff(Ra_list));

Deltaimag = abs(diff(imag(sigmaoddb)));
Deltareal = abs(diff(real(sigmaoddb)));


