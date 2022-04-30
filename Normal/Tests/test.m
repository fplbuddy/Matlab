run Params.m
run SomeInputStuff.m
%% Old method
Extension = 'Epspectrum';
time = '0001';
data = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Spectra/' Extension '.' time '.txt']);
kold = data(:,1);
yold = data(:,2);
figure()
loglog(kold,yold)
%% New method
nodes = 8;
type = 'theta';
Lx = 0.5;
Ly = 1;
Dkx = 1.0/Lx;
Dky = 1.0/Ly;
ynew = zeros(length(kold),1);
for i=0:nodes-1
    node = ['00' num2str(i)];
    data = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Spectra/' type '.' node '.' time '.txt']);
    if length(data) > 0
    kx = data(:,3); ky = data(:,4); R = data(:,1); I = data(:,2);
    for j=1:length(kx)
        kxinst = kx(j); kyinst = ky(j); mode = R(j) + 1i*I(j);
        kk2 = (kxinst*Dkx)^2 + (kyinst*Dky)^2;
        kmn = round(sqrt(kk2));
        if kmn == 0
            kmn = 1;
        end
        if kxinst == 0
            %ynew(kmn) = ynew(kmn)+(kk2)*abs(mode)^2; 
            ynew(kmn) = ynew(kmn)+abs(mode)^2; 
        else
            %ynew(kmn) = ynew(kmn)+2*(kk2)*abs(mode)^2;
            ynew(kmn) = ynew(kmn)+2*abs(mode)^2;
        end
        
    end
    end
end
figure()
loglog(kold,ynew)


