function alpha = BurstExponent(AllData,Ly,Pr,Ra,N,type,k)
LyS = normaltoS(Ly,'Ly',1); PrS = normaltoS(Pr,'Pr',1); RaS = normaltoS(Ra,'Ra',1);
NS = ['N_' num2str(N) 'x' num2str(N)];
IC = ['IC_' type(1)];
path = AllData.(IC).(NS).(PrS).(RaS).(LyS).path;
kenergy2 = importdata([path '/Checks/kenergy2.txt']);
%%
s = kenergy2(:,2);
t = kenergy2(:,1);
mm = movmean(log(s),k);
figure()
[~,locs] = findpeaks(mm);
% plot(t,log(s)), hold on
% plot(t,mm)
% title([RaS LyS])

if length(locs) < 4 % if we dont do have many points, we just do the whole thing
    [alpha, ~, ~, ~, ~] = Fitslogy(t,s);
else
    [alpha, ~, ~, ~, ~] = Fitslogy(t(locs),s(locs));
end
    
end

