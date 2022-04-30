%% zonal
run SetUp.m
run Params.m
run SomeInputStuff.m
file = 'zonalmean';

% Finding nondim factor
kenergy = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kenergy.txt']);
t = kenergy(:,1);
Ey = kenergy(:,5);
Ex = kenergy(:,6);
urms = 2*Ex+2*Ey;
urms = MyMeanEasy(urms,t); urms = urms^(1/2);
h = pi;
ND = 1/(urms);

% Getting how many points in y
Res = convertStringsToChars(AllData.(ARS).(PrS).(RaS).Res);
[nx, ny] = nxny(Res);

PrintTimes = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Spectra/spec_times.txt']);
First = PrintTimes(1,1);
Last = PrintTimes(end,1);
Times = PrintTimes(:,2);
Prints = PrintTimes(:,1);
t = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kenergy.txt']);
t = t(:,1);
t = t(xlower:end);
t = reshape(t, 1, length(t));

% Setting up the time vectors, number is there for tollerance later
post = [1e8];
negt = [1e8];
zerot = [1e8];

% Finding pos shearing times 
for i=1:length(AllData.(ARS).(PrS).(RaS).calcs.pos)
   section = AllData.(ARS).(PrS).(RaS).calcs.pos{i};
   post = [post t(AllData.(ARS).(PrS).(RaS).calcs.pos{i})];
end
% Finding neg shearing times 
for i=1:length(AllData.(ARS).(PrS).(RaS).calcs.neg)
   section = AllData.(ARS).(PrS).(RaS).calcs.neg{i};
   negt = [negt t(AllData.(ARS).(PrS).(RaS).calcs.neg{i})];
end
% Finding zero times 
for i=1:length(AllData.(ARS).(PrS).(RaS).calcs.zero)
   section = AllData.(ARS).(PrS).(RaS).calcs.zero{i};
   zerot = [zerot t(AllData.(ARS).(PrS).(RaS).calcs.zero{i})];
end


% Setting up how many we have of each
pn = 0;
nn = 0;
zn = 0;

% Setting up the averages
pav = zeros(ny,1);
nav = zeros(ny,1);
zav = zeros(ny,1);

figure('Renderer', 'painters', 'Position', [5 5 600 400])
y = linspace(0 + 1/(2*ny), 1 - 1/(2*ny), ny);

if convertCharsToStrings(file) == "Zonaltheta" % Add to y for boundary conditions if we are plotting TT.
   y = [0 y 1]; 
end
    
subplot(3,6,[1 2 3 7 8 9 13 14 15])    
hold on
% Looping around print times, ASSUMES WELL BEHAVED HERE. Ie start at 1 etc.
for i=First:Last
    Time = Times(i);
    Print = Prints(i);
    % Convert print to format we want
    Print = num2str(Print);
    while length(Print) < 4
        Print = ['0' Print];
    end
    % Extracting data
    Data = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Spectra/' file '.' Print '.txt']);   
    if convertCharsToStrings(file) == "Zonaltheta" 
        Data = reshape(Data, 1, ny);
        Data = Data + (1-linspace(0 + 1/(2*ny), 1 - 1/(2*ny), ny)); % Converting to TT
        % Adding BCs
        Data = [1 Data 0];
    end
    
    if ismembertol(Time, post,1e-9) % Ie we are positive shearing
        pn = pn + 1;
        plot1 = plot(Data*ND, y, 'Color', [1 0.7 0.7]);
        plot1.Color(4) = 0.15;
        pav = pav + Data;
    elseif ismembertol(Time, negt,1e-9) % Ie we are negative shearing
        nn = nn + 1;
        plot1 = plot(Data*ND, y, 'Color', [0.7 0.7 1]);
        plot1.Color(4) = 0.15;
        nav = nav + Data;
    elseif ismembertol(Time, zerot,1e-9) % Ie we are zero
        zn = zn + 1;
        plot1 = plot(Data*ND, y, 'Color', [0.35 0.5 0.35]);
        plot1.Color(4) = 0.15;
        zav = zav + Data;    
    end
end
plot([0 0], [0 1], 'black--');
plot([-1.5 0.5], [0.5 0.5], 'black--');
% Finding averages
pav = pav/pn;
nav = nav/nn;
zav = zav/zn;

% Plotting averages
p1 = plot(nav*ND, y, 'blue-','LineWidth', 2);
p2 = plot(zav*ND, y, 'Color', [0 0.5 0],'LineWidth', 2);
p3 = plot(pav*ND, y, 'red-','LineWidth', 2);
legend('Location', 'best'); legend('boxoff')


h = [p1; p2; p3];
 % Now call the legend function passing the handle h and specify the text
legend(h,'$\langle\hat \psi_{0,1}\rangle < 0$','$\langle\hat \psi_{0,1}\rangle = 0$' ,'$\langle\hat \psi_{0,1}\rangle > 0$', 'Location', 'east');


if convertCharsToStrings(file) == "Zonaltheta"
    xlabel('Temperature', 'FontSize', 13)
elseif convertCharsToStrings(file) == "zonalmean"
    xlabel('$U$ $(u_{rms})$', 'FontSize', FS1)
end
ylabel('$y$', 'FontSize', FS1)
yticks([0 0.5 1])
yticklabels({'$0$' '$0.5$' '$1$'})
%title(['$' convertStringsToChars(AllData.(ARS).(PrS).(RaS).title) '$'], 'FontSize',14)

clearvars -except AllData Data

%% Vis and time series

run SetUp.m
run Params.m
run SomeInputStuff.m

kenergy = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kenergy.txt']);
kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes1.txt']);
xlower = AllData.(ARS).(PrS).(RaS).ICT;
kappa = AllData.(ARS).(PrS).(RaS).kappa;
tE = kenergy(:,1);
Ey = kenergy(:,5);
Ex = kenergy(:,6);
urms = 2*Ex+2*Ey;
urms = MyMeanEasy(urms,tE); urms = urms^(1/2);
h = pi;

signal = 2*kpsmodes1(:,2); signal = signal(xlower:end)/(h*urms);
t = kpsmodes1(:,1); t = t(xlower:end)/(h/urms);
Ik = kenergy(:,4);
Nut = 1 + pi*2*Ik(xlower:end)/kappa;

% Going to do it all with ext
urms = AllData.AR_2.Pr_30.Ra_6_4e6.urms; h = pi; kappa = AllData.AR_2.Pr_30.Ra_6_4e6.kappa;
kpsmodes1ext = importdata('/Volumes/Samsung_T5/Residue/Ra_6_4e6_ext/Checks/kpsmodes1.txt');
kenergy = importdata('/Volumes/Samsung_T5/Residue/Ra_6_4e6_ext/Checks/kenergy.txt');
Signalext = 2*kpsmodes1ext(:,2)/(h*urms); t = kpsmodes1ext(:,1)/(h/urms);
Ik = kenergy(:,4);
Nut = 1 + pi*2*Ik/kappa;

%% Plot
hold off
subplot(3,6,[13,14,15, 16, 16,18])
plot(t-1.4e4, Signalext, 'Color', [0 0.5 0]), hold on
xlim([0 2000])
set(gca,'xtick',[])
ylabel({'$\hat \psi_{0,1}$','$(hu_{rms})$'}, 'Fontsize', FS1)
plot([0.3e3 0.3e3], [-0.5 0.5], 'black--')
plot([1e3 1e3], [-0.5 0.5], 'black--')
plot([1.7e3 1.7e3], [-0.5 0.5], 'black--')
text(0.3e3-120,0.35,'(a)', 'FontSize', FS1)
text(1e3-120,0.35,'(b)', 'FontSize', FS1)
text(1.7e3-120,-0.35,'(c)', 'FontSize', FS1), hold off
hp4 = get(gca,'ylabel').Position;
set(get(gca,'ylabel'),'Position', [hp4(1)*1.01 hp4(2) hp4(3)])

% subplot(3,3,[7,8,9])
% plot(t-1.4e4, Nut(1:length(t)), 'Color', [0 0.5 0]), hold on
% xlim([0 2000])
% plot([0.3e3 0.3e3], [0 70], 'black--')
% plot([1e3 1e3], [0 70], 'black--')
% plot([1.7e3 1.7e3], [0 70], 'black--')
% ylabel('Nu$(t)$', 'Fontsize', FS1)
% xlabel('$t$', 'Fontsize', FS1)
% hold off

nx = 256; ny = 256; nmpi = 16;
titlepos = [50 250 1.00011];
subplot(3,9,4)
num = '021';
pathF = convertStringsToChars([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Fields/']);
files = dir([pathF,'hd2DTT','.*.',num,'.dat']);
ff = zeros(nx*ny/nmpi,nmpi);
for i=1:nmpi % Looping round mpi
    fid = fopen([pathF,files(i).name],'r');
    fread(fid,1,'real*4');
    ff(:,i) = fread(fid,inf,'real*8');
    fclose(fid);
end
ff = reshape(ff,nx,ny);
fieldcheck = ff';
pcolor(ff');
title('(a)','FontSize', FS1 )
%set(get(gca,'title'),'Position', titlepos)
shading flat
colormap('jet')
caxis([0 1])
xlabel('$x$', 'FontSize', FS1)
ylabel('$y$', 'FontSize', FS1)
xticks([1 nx])
xticklabels({'$0$' '$\Gamma$'})
yticks([1 ny])
yticklabels({'$0$' '$1$'})
hp4 = get(gca,'xlabel').Position;
set(get(gca,'xlabel'),'Position', [hp4(1) hp4(2)/2 hp4(3)])
hp4 = get(gca,'ylabel').Position;
set(get(gca,'ylabel'),'Position', [hp4(1)*2.1 hp4(2) hp4(3)])

subplot(3,6,2)
num = '033';
pathF = convertStringsToChars([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Fields/']);
files = dir([pathF,'hd2DTT','.*.',num,'.dat']);
ff = zeros(nx*ny/nmpi,nmpi);
for i=1:nmpi % Looping round mpi
    fid = fopen([pathF,files(i).name],'r');
    fread(fid,1,'real*4');
    ff(:,i) = fread(fid,inf,'real*8');
    fclose(fid);
end
ff = reshape(ff,nx,ny);
fieldcheck = ff';
pcolor(ff');
title('(b)','FontSize', FS1)
%set(get(gca,'title'),'Position', titlepos)
shading flat
colormap('jet')
caxis([0 1])
xlabel('$x$', 'FontSize', FS1)
xticks([1 nx])
xticklabels({'$0$' '$\Gamma$'})
yticks([])
yticklabels({})
hp4 = get(gca,'xlabel').Position;
set(get(gca,'xlabel'),'Position', [hp4(1) hp4(2)/2 hp4(3)])

subplot(3,3,3)
num = '006';
pathF = convertStringsToChars([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Fields/']);
files = dir([pathF,'hd2DTT','.*.',num,'.dat']);
ff = zeros(nx*ny/nmpi,nmpi);
for i=1:nmpi % Looping round mpi
    fid = fopen([pathF,files(i).name],'r');
    fread(fid,1,'real*4');
    ff(:,i) = fread(fid,inf,'real*8');
    fclose(fid);
end
ff = reshape(ff,nx,ny);
fieldcheck = ff';
pcolor(ff');
title('(c)','FontSize', FS1 )
%set(get(gca,'title'),'Position', titlepos)
shading flat
colormap('jet')
caxis([0 1])
xlabel('$x$', 'FontSize', FS1)
xticks([1 nx])
xticklabels({'$0$' '$\Gamma$'})
yticks([])
yticklabels({})
hp4 = get(gca,'xlabel').Position;
set(get(gca,'xlabel'),'Position', [hp4(1) hp4(2)/2 hp4(3)])

hp4 = get(subplot(3,3,3),'Position');
colorbar('Position', [hp4(1)+hp4(3)+0.015  hp4(2)  0.015  hp4(4)])