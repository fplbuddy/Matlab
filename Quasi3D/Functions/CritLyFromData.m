function [LyC,exponent,Ly_list] = CritLyFromData(Ra,Pr,type, Nx,Ny,AllData)
PrS = normaltoS(Pr,'Pr',1); IC = ['IC_' type(1)]; RaS = normaltoS(Ra,'Ra',1);
NS = ['N_' num2str(Nx) 'x' num2str(Ny)];
LyS_list = string(fields(AllData.(IC).(NS).(PrS).(RaS)));
exponent = zeros(length(LyS_list),1);
Ly_list = zeros(length(LyS_list),1);
for i=1:length(LyS_list)
    LyS = LyS_list(i);
    Ly = StoNormal(LyS,4);
    Ly_list(i) = Ly;
    path = AllData.(IC).(NS).(PrS).(RaS).(LyS).path;
    kenergy2 = importdata([path '/Checks/penergy2.txt']);
    t = kenergy2(:,1); s = kenergy2(:,2);
    if isfield(AllData.(IC).(NS).(PrS).(RaS).(LyS),'trans')
        trans = AllData.(IC).(NS).(PrS).(RaS).(LyS).trans;
    else
        trans = 1;
    end
    if isfield(AllData.(IC).(NS).(PrS).(RaS).(LyS),'top') % if we have some maximum time series goes to
        top = AllData.(IC).(NS).(PrS).(RaS).(LyS).top;
        t = t(trans:top); s = s(trans:top);
    else
        t = t(trans:end); s = s(trans:end);
    end
    % remove NaN
    I = find(s == 0, 1 );
    if ~isempty(I) 
        t = t(1:I-1);
        s = s(1:I-1);
    end
    [alpha, ~, ~, ~, ~] = Fitslogy(t,s);
    exponent(i) = alpha;
end
[Ly_list, I] = sort(Ly_list);
exponent = exponent(I);
% 
% figure()
% plot(Ly_list,exponent)

d = diff(sign(exponent));
I = find(d == 2);
explower = exponent(I);
expupper = exponent(I+1);
Lylower = Ly_list(I);
Lyupper = Ly_list(I+1);

grad = (explower - expupper)/(Lylower-Lyupper);
inter = explower - grad*Lylower;
LyC = -inter/grad;


end

