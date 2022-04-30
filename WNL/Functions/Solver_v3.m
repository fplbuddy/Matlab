function x = Solver_v3(x0,tmax,As, sigmas,eps,r,Fs,CFL)
%% Solver
fun = @(t,u) [-exp(u(2)*2-u(1))*interp1(As,Fs,exp(u(1)))+r-exp(u(1)*2);...
    interp1(As,sigmas,exp(u(1)))/eps^2];
opts = odeset('MaxStep',tmax*CFL);
x = ode23tb(fun,[0 tmax],x0, opts);

end



