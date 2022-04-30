function [psi1,theta1,theta2] = steadyNew(RaA)
    RaC = 8*pi^4;
    Ra = RaC + RaA;
    psi1 = 2*sqrt(RaA/RaC);
    theta1 = (- pi^3*4/Ra)*psi1;
    theta2 = psi1*theta1/2;
end

