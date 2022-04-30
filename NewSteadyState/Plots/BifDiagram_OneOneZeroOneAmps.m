% load('/Volumes/Samsung_T5/OldData/PrZeroData.mat');
% load('/Volumes/Samsung_T5/OldData/NewSteadyState.mat');
Pr = 1e-4;
G = 0.3; GS = GtoGS(G);
Nx = 32;
Ny = 32;
RaA_list = []; OneOne_list = []; ZeroOne_list = [];
RaApitch = 1.27e-4;
RaAhopf = 1.56e-3;
%% Do SCRS first
PrS = PrtoPrSZero(Pr); 
type = ['N_' num2str(Nx)];
RaAS_list = string(fields(PrZeroData.(GS).(type).(PrS)));
for i=1:length(RaAS_list)
    RaAS = RaAS_list(i); RaA = RaAStoRaA(RaAS); 
    if RaA < RaApitch
    RaA_list = [RaA_list RaA];
    PsiE = PrZeroData.(GS).(type).(PrS).(RaAS).PsiE;
    OneOne_list = [OneOne_list abs(PsiE(1))];
    ZeroOne_list = [ZeroOne_list 0];
    end
end

%% Now do new SS
type = ['N_' num2str(Nx) 'x' num2str(Ny)];
PrS = PrtoPrS(Pr); 
RaAS_list = string(fields(Data.(GS).(type).(PrS)));
for i=1:length(RaAS_list)
    RaAS = RaAS_list(i); RaA = RaAStoRaA(RaAS); 
    if RaA < RaAhopf
    RaA_list = [RaA_list RaA];
    PsiE = Data.(GS).(type).(PrS).(RaAS).PsiE;
    OneOne_list = [OneOne_list abs(PsiE(2))];
    ZeroOne_list = [ZeroOne_list abs(PsiE(1))];
    end
end
%% Make plot
figure
loglog(RaA_list,OneOne_list,'b*'), hold on
plot(RaA_list,ZeroOne_list,'r*')

