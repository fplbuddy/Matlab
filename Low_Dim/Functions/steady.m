function F = steady(x, Ra, Pr, G) 
    F(1) = (Ra*Pr*(2*pi/G)*x(2)+Pr*((-(2*pi/G)^2-pi^2)^2)*x(1));
    F(2) = ((2*pi/G)*x(1)*(pi*x(3)+1)+((2*pi/G)^2+pi^2)*x(2));
    F(3) = (x(3)-x(1)*x(2)/G);  
end

