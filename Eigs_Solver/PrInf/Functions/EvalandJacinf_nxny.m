function [J,Eval] = EvalandJacinf_nxny(ThetaE, Ra,G,n,m,Nx,Ny,positionMatrix)
     K2 = ((2*pi/G)*n').^2 + (pi*m').^2;
     K4 = K2.^2;
     kx = (2*pi/G)*n';  
    len = length(ThetaE);
    J = zeros(len, len); 
    NLtheta = zeros(len,1);
    PF = Ra*2*pi^3/G^2;
    for i=1:length(n) 
        ninst = n(i); minst = m(i);
        OnesWeWant = OWWinfsteady_nxny(ninst,minst, n,m,Nx,Ny);
        for j=1:length(OnesWeWant)
            n1 = OnesWeWant(j, 1);  m1 = OnesWeWant(j, 2);  n2 = OnesWeWant(j, 3);  m2 = OnesWeWant(j, 4);
            % do the NL stuff dor eveluatuon first
            pos1 = positionMatrix(m1,abs(n1)+1); pos2 = positionMatrix(m2,abs(n2)+1); % using abs her as can be negative, and all the entries are real, so will not have issues with c.c.
            possteady = positionMatrix(minst, ninst+1);
            
            
            
            SS = SignStuffSteady(n1,m1,n2,m2,minst);
            RF = RemainingFactSteady(n2,m2,G);
            
            

            NLtheta(i) = NLtheta(i) + PF*SS*RF*ThetaE(pos1)*ThetaE(pos2);

            J(possteady,pos1) = J(possteady,pos1) + PF*SS*RF*ThetaE(pos2); % the minus sign is here because sign1 and sign2 are reversed for the heat eq non-linearity
            J(possteady,pos2) = J(possteady,pos2) + PF*SS*RF*ThetaE(pos1); % the minus sign is here because sign1 and sign2 are reversed for the heat eq non-linearity
        end
    end
    % adding non-linear terms
    % eval
    Eval = NLtheta + (Ra*(kx.^2./K4).*ThetaE - K2.*ThetaE);
    % jacob
    J = J + (diag(Ra*kx.^2./K4) - diag(K2)); 
end

