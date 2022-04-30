clearvars -except AllData
close all
TE = 'latex';
home = '/Users/philipwinchester/Dropbox/Matlab';
RB = [home '/redblue'];
addpath(home);
addpath(RB);
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)

%% Input
size = 100;
g = 1;
a = 1;
DT = 1;
x = pi;
y = pi;
L = 2*pi;
h = pi;
m = 0:(size-1);
n = 1:size;
[mm, nn] = meshgrid(m,n);
B = sqrt((0.32142957270183e-1)^2 + (0.19103339225036e-2)^2); % Taken from runs
C = sqrt((0.25311952084684e-1)^2 + (0.15043507137726e-2)^2);
Ra = 8e2;
Pr = 1;
Atwo = (4*pi^2/L^2 + pi^2/h^2)*ones(size,size);

%% Set up
nu = sqrt(h^3*Pr/Ra);
kappa = sqrt((h^3/(Ra*Pr)));
kx = mm*2*pi/L;
ky = nn*pi/h;
Ktwo = kx.^2 + ky.^2;
f = ((1i*4*pi*B)/(L*h))*(-mm*cot(pi*y/h)*sin(2*pi*x/L)-1i*nn*cot(ky*y)*cos(2*pi*x/L));
fhat = ((1i*4*pi*C)/(L*h))*(mm*cot(pi*y/h)*cos(2*pi*x/L)-1i*nn*cot(ky*y)*sin(2*pi*x/L));
s = 0.1;
sigma = s*1i;

%% Coefficients in quadratic
D = -Ktwo;
E = (Ktwo.*(f-kappa*Ktwo)+f.*(Ktwo-Atwo)-nu*Ktwo.^2);
F = ((Atwo-Ktwo).*f + nu*Ktwo^2).*(f - kappa*Ktwo)+ 1i*kx*g*a*(fhat-DT*1i*kx/h);

%% Real equation
Dr = real(D*sigma^2);
Er = real(E*sigma);
Fr = real(F);
RealPart = Dr + Er + Fr;

% Scaling
% minValue = min(RealPart(:));
% maxValue = max(RealPart(:));
% for i=1:51
%     for j =1:51
%         if RealPart(i,j) < 0
%             RealPart(i,j) = - RealPart(i,j)/minValue;
%         else
%             RealPart(i,j) =  RealPart(i,j)/maxValue;
%         end
%     end
% end
RealPart = sign(RealPart);
figure()
pcolor(RealPart);
shading flat
colormap(redblue)
colorbar()
xlabel('$m$ $(k_x)$', 'FontSize', 15)
ylabel('$n$ $(k_y)$', 'FontSize', 15)
title('Real Part', 'FontSize', 15)
%% Imag equatin
Di = imag(D*sigma^2);
Ei = imag(E*sigma);
Fi = imag(F);
ImagPart = Di + Ei + Fi;

% Scaling
% minValue = min(ImagPart(:));
% maxValue = max(ImagPart(:));
% for i=1:51
%     for j =1:51
%         if ImagPart(i,j) < 0
%             ImagPart(i,j) = - ImagPart(i,j)/minValue;
%         else
%             ImagPart(i,j) =  ImagPart(i,j)/maxValue;
%         end
%     end
% end
ImagPart = sign(ImagPart);

figure()
pcolor(ImagPart);
shading flat
colormap(redblue)
colorbar()
xlabel('$m$ $(k_x)$', 'FontSize', 15)
ylabel('$n$ $(k_y)$', 'FontSize', 15)
title('Imag Part', 'FontSize', 15)
