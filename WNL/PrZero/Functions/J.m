function J = J(t,x)
J = [exp(x(2)*2-x(1))*(lambda(exp(x(1)))-exp(x(1))*lambdadash(exp(x(1)))) -2*lambda(exp(x(1)))*exp(x(2)*2-x(1));
    exp(x(1))*sigmasdash(exp(x(1)))/eps^2 0];
end

