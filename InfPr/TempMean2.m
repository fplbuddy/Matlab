run Params.m
run SomeInputStuff.m

field =  'TT';
Res = convertStringsToChars(AllData.(ARS).(PrS).(RaS).Res);
nx = '';
ny = '';
for i=1:find('x' == Res)-1
   nx = [nx Res(i)];
end
for i=find('x' == Res)+1:length(Res)
   ny = [ny Res(i)];
end
nx = str2double(nx);
ny = str2double(ny);
nmpi = 8;

pathF = join([path "/" ARS "/" AllData.(ARS).(PrS).(RaS).Res "/" PrS "/" RaS "/Fields/"],"");
field_times = join([pathF "field_times.txt"],"");
Times = importdata(field_times);
prints = Times(end,1);
MasterMatrix = zeros(ny,nx);

for num=1:prints % Looping round times
    num = num2str(num);
    while length(num) < 3
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
    MasterMatrix =  MasterMatrix + ff';
end
% Average
MasterMatrix = MasterMatrix/prints;
% Zonal average
[row,col] = size(MasterMatrix);
Out = zeros(row,1);
for i = 1:nx
    for j=1:ny
        Out(j) = Out(j) + MasterMatrix(j,i)/nx;
    end
end
y = linspace(0,1, ny);
%figure
plot(Out,y);
ylabel('$y$','Interpreter','latex', 'FontSize', 17)
xlabel('$\bar{T}^t(y)$','Interpreter','latex', 'FontSize', 17)
title(join(["$" AllData.(ARS).(PrS).(RaS).title "$"],""))
clearvars -except AllData