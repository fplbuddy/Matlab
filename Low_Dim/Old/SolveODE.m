chebfunpath = '/Users/philipwinchester/Documents/MATLAB/chebfun-master/';
addpath(genpath(chebfunpath));
G = 2;
Ra = 1e3;
Pr = 30;
PiFourG = pi^4/G;
PiG = pi/G;
PiTwoG = pi^2/G;
xOneConst = (-(2*PiG)^2-pi^2);
xTwoConst = (-(2*PiG)^2-4*pi^2);
%% Solver
fun = @(t,u) [(4*PiFourG*u(4)*u(5)-Ra*Pr*2*PiG*u(7)+Pr*xOneConst^2*u(1))/xOneConst;... 
    (-4*PiFourG*u(3)*u(5)+Ra*Pr*2*PiG*u(6)+Pr*xOneConst^2*u(2))/xOneConst;...
    (4*(PiFourG/G^2)*u(2)*u(5)-Ra*Pr*2*PiG*u(9)+Pr*xTwoConst^2*u(3))/xTwoConst;...
    (-4*(PiFourG/G^2)*u(1)*u(5)+Ra*Pr*2*PiG*u(8)+Pr*xTwoConst^2*u(4))/xTwoConst;...
    (6*PiFourG*(u(3)*u(2)-u(1)*u(4))+Pr*pi^4*u(5))/(-pi^2);...
    -PiTwoG*(u(9)*u(5)+2*u(2)*u(10))-2*PiG*u(2)+xOneConst*u(6);...
    PiTwoG*(u(8)*u(5)+2*u(1)*u(10))+2*PiG*u(1)+xOneConst*u(7);...
    -PiTwoG*u(7)*u(5)-2*PiG*u(4)+xOneConst*u(8);...
    PiTwoG*u(6)*u(5)+2*PiG*u(3)+xOneConst*u(9);...
    4*PiTwoG*(u(6)*u(2)-u(7)*u(1))-4*pi^2*u(10)];
v = ode113(fun,[0,0.02],[1 1 1 1 1 1 1 1 1 1]);




%% Lorentz attractor
% opts = odeset('abstol',1e-13,'reltol',1e-13);
% fun = @(t,u) [10*(u(2)-u(1)); 28*u(1)-u(2)-u(1)*u(3); u(1)*u(2)-(8/3)*u(3)];
% u = chebfun.ode113(fun,[0,500],[-14 -15 20], opts);
% LW = 'linewidth'; FS = 'fontsize';
% plot3(u(:,1),u(:,2),u(:,3), LW, 1.6), view(20,20)
% axis([-20 20 -40 40 5 45]), grid on
% xlabel 'x(t)', ylabel 'y(t)', zlabel 'z(t)'
% title('A 3D Trajectory of the Lorenz Attractor', FS, 14)