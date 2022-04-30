run Params.m
run SomeInputStuff.m

if not(exist('PrintTimes','var'))
    PrintTimes = input('Times? (input as double) ');
end
while PrintTimes(1) > PrintTimes(2)
   PrintTimes = input('Times? (input as double) ');    
end

Res = convertStringsToChars(AllData.(ARS).(PrS).(RaS).Res);
[nx, ny] = nxny(Res);

if not(exist('nmpi','var'))
    PrintTimes = input('nmpi? ');
end


pathF = join([path "/" ARS "/" AllData.(ARS).(PrS).(RaS).Res "/" PrS "/" RaS "/Fields/"],"");
field_times = join([pathF "field_times.txt"],"");
Times = importdata(field_times);

ListTimes = Times(:,2);
% Non-dim ListTimes 
if NDT
    ListTimes = ListTimes*AllData.(ARS).(PrS).(RaS).kappa/pi^2;
end

NumberTimes = Times(:,1);
% Finding lower prints number
[~,~,idx]=unique(abs(ListTimes-PrintTimes(1)));
LowerPrint = NumberTimes(idx==1);
% Finding upper prints number
[~,~,idx]=unique(abs(ListTimes-PrintTimes(2)));
UpperPrint = NumberTimes(idx==1);

field = input('Field? (input as char) ');

for num=LowerPrint:UpperPrint % Looping round times
    Time = ListTimes(num); % Time of plot
    if not(NDT)
        Time = round(Time);
    end
    Time = num2str(Time);
    num = num2str(num);
    while length(num) < 4
        num = ['0' num];
    end
    pathF = convertStringsToChars(pathF);
    files = dir([pathF,'hd2D',field,'.*.',num,'.dat']);
    ff = zeros(nx*ny/nmpi,nmpi);
    for i=1:nmpi % Looping round mpi
        fid = fopen([pathF,files(i).name],'r');
        fread(fid,1,'real*4');
        ff(:,i) = fread(fid,inf,'real*8');
        fclose(fid);
    end
    ff = reshape(ff,nx,ny);
    figure
    fieldcheck = ff';
    pcolor(ff');
    shading flat
    colormap('winter')
    colorbar
    xlabel('$x$', 'FontSize', 14)
    ylabel('$y$', 'FontSize', 14)
    xticks([1 nx])
    xticklabels({'$0$' '$2\pi$'})
    yticks([1 ny])
    yticklabels({'$0$' '$\pi$'})
    if convertCharsToStrings(field) == "ps"
        fieldt = 'psi'; % For title
    else
        fieldt = 'theta'; % For title
    end
    title(['$' convertStringsToChars(AllData.(ARS).(PrS).(RaS).title) ', ' '\' fieldt '$' ' at time $= ' Time '$'], 'FontSize',15)
end
clearvars -except AllData