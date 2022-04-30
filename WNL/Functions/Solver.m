function x = Solver(x0,tint,As, sigmas,eps,G,r,Fs, Bsmaller)
Ktwo = (2*pi/G)^2+pi^2;
tderiv = Ktwo*(4+G^2)*pi/(2*G);
Aterm = r*2*pi/G;
Athreeterm = (Ktwo^2)*(4+G^2)^2*pi^3/(4*G^3);
%% Solver
fun = @(t,u) [(-(u(2)/Bsmaller)^2*interp1(As,Fs,u(1))+Aterm*u(1)-Athreeterm*u(1)^3)/(tderiv/eps^2);...
    interp1(As,sigmas,u(1))*u(2)];
x = ode113(fun,tint,x0);


end



