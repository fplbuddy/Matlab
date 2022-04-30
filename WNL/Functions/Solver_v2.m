function x = Solver_v2(x0,tmax,As, sigmas,eps,r,Fs,CFL)
%% Solver
fun = @(t,u) [-exp(u(2)*2)*interp1(As,Fs,u(1))+r*u(1)-u(1)^3;...
    interp1(As,sigmas,u(1))/eps^2];
opts = odeset('MaxStep',tmax*CFL);
x = ode23tb(fun,[0 tmax],x0, opts);

end



