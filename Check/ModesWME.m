path = '/Users/philipwinchester/Documents/Data/Low_Dim/4x14/AR_1/Pr_30/Ra_1e6/';
nx = 16;
ny = 32;
NumModes = 4*14;
%% Checking kinetic energy
NumsAndTimes = importdata([path 'Fields/field_times.txt']);
Nums = NumsAndTimes(:,1);
xr = floor(nx/3 + 1) + 1;
yr = floor(2*ny/3 + 1);
All = zeros(yr,xr);
Upath = [path 'Spectra/'];
for i=2:length(Nums)
    num = Nums(i);
    num = num2str(num);
    while length(num) < 4; num = ['0' num]; end
    fid = fopen([Upath 'spectrum2D_UU.' num '.out'],'r');
    fread(fid,1, 'real*4');
    Spectra = fread(fid,inf, 'real*8');
    fclose(fid);
    Spectra = reshape(Spectra,xr,yr);
    Spectra = Spectra';
    All = All + Spectra;
end

AAll1 = All/length(Nums);
pcolor(AAll1);
colormap('jet')
colorbar
set(gca,'ColorScale','log')
% ranking
mode = [];
value = [];
for i=1:xr
   for j=1:yr
       modeinst = ['(' num2str(i-1) ',' num2str(j) ')'];
       mode = [convertCharsToStrings(modeinst) mode];
       value = [AAll1(j,i) value];
   end  
end
[value, I] = sort(value, 'descend');
mode = mode(I);
mode = mode(1:NumModes);

% To make plot nice
xlim([1 5])
ylim([1 15])
xticks([1.5 2.5 3.5 4.5])
xticklabels({'0' '1' '2' '3'})
yticks([1.5 2.5 3.5 4.5 5.5 6.5 7.5 8.5 9.5 10.5 11.5 12.5 13.5 14.5])
yticklabels({'1' '2' '3' '4' '5' '6' '7' '8' '9' '10' '11' '12' '13' '14'})
ylabel('$k_y$', 'FontSize', 18)
xlabel('$k_x$', 'FontSize', 18)
title('Kinetic energy held in each mode (Time averaged)', 'FontSize', 20)

%% Checking potential energy
NumsAndTimes = importdata([path 'Fields/field_times.txt']);
Nums = NumsAndTimes(:,1);
xr = floor(nx/3 + 1) + 1;
yr = floor(2*ny/3 + 1);
All = zeros(yr,xr);
Upath = [path 'Spectra/'];
for i=2:length(Nums)
    num = Nums(i);
    num = num2str(num);
    while length(num) < 4; num = ['0' num]; end
    fid = fopen([Upath 'spectrum2D_PP.' num '.out'],'r');
    fread(fid,1, 'real*4');
    Spectra = fread(fid,inf, 'real*8');
    fclose(fid);
    Spectra = reshape(Spectra,xr,yr);
    Spectra = Spectra';
    All = All + Spectra;
end

AAll2 = All/length(Nums);
pcolor(AAll2);
colormap('jet')
colorbar
set(gca,'ColorScale','log')
% ranking
mode = [];
value = [];
for i=1:xr
   for j=1:yr
       modeinst = ['(' num2str(i-1) ',' num2str(j) ')'];
       mode = [convertCharsToStrings(modeinst) mode];
       value = [AAll2(j,i) value];
   end  
end
[value, I] = sort(value, 'descend');
mode = mode(I);

% To make plot nice
xlim([1 5])
ylim([1 15])
xticks([1.5 2.5 3.5 4.5])
xticklabels({'0' '1' '2' '3'})
yticks([1.5 2.5 3.5 4.5 5.5 6.5 7.5 8.5 9.5 10.5 11.5 12.5 13.5 14.5])
yticklabels({'1' '2' '3' '4' '5' '6' '7' '8' '9' '10' '11' '12' '13' '14'})
ylabel('$k_y$', 'FontSize', 18)
xlabel('$k_x$', 'FontSize', 18)
title('Potential energy held in each mode (Time averaged)', 'FontSize', 20)

%% Both
% Finding ratio
AAll1 = AAll1/max(max(AAll1));
AAll2 = AAll2/max(max(AAll2));
AAll = AAll1 + AAll2;
% ranking
mode = [];
value = [];
for i=1:xr
   for j=1:yr
       modeinst = ['(' num2str(i-1) ',' num2str(j) ')'];
       mode = [convertCharsToStrings(modeinst) mode];
       value = [AAll(j,i) value];
   end  
end
[value, I] = sort(value, 'descend');
mode = mode(I);
mode = mode(1:NumModes);


