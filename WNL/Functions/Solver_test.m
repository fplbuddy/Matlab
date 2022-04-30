function x = Solver_test(x0,tint,eps,r)
%% Solver
fun = @(t,u) [(r*u(1)-u(1)^3)*eps^2];
x = ode113(fun,tint,x0);


end



