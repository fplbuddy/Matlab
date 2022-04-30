function x = SolverZero_slowstage(x0,tmax,As, sigmas,eps,Fs,CFL)
lambda = @(A) interp1(As,Fs,A);
sigma = @(A) interp1(As,sigmas,A);
fun = @(t,u) [exp(u(2)*2-u(1))*lambda(exp(u(1)))+1;...
    sigma(exp(u(1)))/eps^2];
opts = odeset('MaxStep',CFL*eps^2,'Events', @EventsFcn_slow);
x = ode23tb(fun,[0 tmax],x0, opts);
end



