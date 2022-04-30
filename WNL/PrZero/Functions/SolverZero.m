function x = SolverZero(x0,tmax,As, sigmas,eps,Fs,CFL)
lambda = @(A) interp1(As,Fs,A);
sigma = @(A) interp1(As,sigmas,A);
% derives
lambdadash_list = diff(Fs)./diff(As);
sigmadash_list = diff(sigmas)./diff(As);
As2 = As(1:end-1);
lambdadash = @(A) interp1(As2,lambdadash_list,A);
sigmasdash = @(A) interp1(As2,sigmadash_list,A);

%J = @(theta, phi) [exp(phi*2-theta)*(lambda(exp(theta))-exp(theta)*lambdadash(exp(theta))) -2*lambda(exp(theta))*exp(phi*2-theta);
    %exp(theta)*sigmasdash(exp(theta))/eps^2 0];
%% Solver
%fun = @(t,u) [exp(u(2)*2-u(1))*interp1(As,Fs,exp(u(1)))+1;...
    %interp1(As,sigmas,exp(u(1)))/eps^2];
fun = @(t,u) [exp(u(2)*2-u(1))*lambda(exp(u(1)))+1;...
    sigma(exp(u(1)))/eps^2];
opts = odeset('MaxStep',tmax*CFL,'Jacobian',@J);
x = ode23tb(fun,[0 tmax],x0, opts);

end



