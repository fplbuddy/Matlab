function [PsiE,ThetaE] = ExtractMeanFields(Nx,Ny,path,nproc,Ra,Pr)
n = [0:(Nx/2-1)]; n = repmat(n, Ny);  n = n(1,:);
m = 1:Ny; m = repelem(m, Nx/2);
[~,~,n,m] = GetRemGeneral_nxny(n,m,Nx,Ny);
for i=0:nproc-1
    num = num2str(i);
    while length(num) < 3
        num = ['0' num];
    end
    if i == 0
        PsiEData = importdata([path '/Spectra/ps.' num '.mean.txt']);
        ThetaEData = importdata([path '/Spectra/theta.' num '.mean.txt']);
    else
        PsiEDataAdd = importdata([path '/Spectra/ps.' num '.mean.txt']);
        ThetaEDataAdd = importdata([path '/Spectra/theta.' num '.mean.txt']);
        PsiEData = [PsiEData;PsiEDataAdd];
        ThetaEData = [ThetaEData;ThetaEDataAdd];
    end
end
PsiE = zeros(length(n),1);
ThetaE = zeros(length(n),1);
positionMatrix = MakepositionMatrix(n,m);
% Now fill PsiE and ThetaE
for i=1:height(PsiEData)
    PsiEAdd = PsiEData(i,1) + 1i*PsiEData(i,2);
    ThetaEAdd = ThetaEData(i,1) + 1i*ThetaEData(i,2);
    loc = positionMatrix(PsiEData(i,4),PsiEData(i,3)+1);
    PsiE(loc) = PsiEAdd;
    ThetaE(loc) = ThetaEAdd;
end
% Make non-dim
kappa = sqrt((pi)^3/(Ra*Pr));
PsiE = PsiE/kappa;
end

