function [nu,kappa] = nukappa(o1,Ra,Pr)
  nu = sqrt((2*pi)^(4*o1-1)*Pr/Ra);
  kappa = sqrt((2*pi)^(4*o1-1)/(Ra*Pr));
end

