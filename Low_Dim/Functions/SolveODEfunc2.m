function x = SolveODEfunc2(G,Ra,Pr,x0,tint)
PiFourG = pi^4/G;
PiG = pi/G;
PiTwoG = pi^2/G;
xOneConst = (-(2*PiG)^2-pi^2);
xTwoConst = (-(2*PiG)^2-4*pi^2);
%% Solver
fun = @(t,u) [ (-4*PiFourG*u(2)*u(3)+Ra*Pr*2*PiG*u(4)+Pr*xOneConst^2*u(1))/xOneConst;...
    (4*(PiFourG/G^2)*u(1)*u(3)-Ra*Pr*2*PiG*u(5)+Pr*xTwoConst^2*u(2))/xTwoConst;...
    (6*PiFourG*(u(2)*u(1))+Pr*pi^4*u(3))/(-pi^2);...
    -PiTwoG*(u(5)*u(3)+2*u(1)*u(6))-2*PiG*u(1)+xOneConst*u(4);...
    PiTwoG*u(4)*u(3)+2*PiG*u(2)+xOneConst*u(5);...
    4*PiTwoG*(u(4)*u(1))-4*pi^2*u(6)];
x = ode113(fun,tint,x0);
end

