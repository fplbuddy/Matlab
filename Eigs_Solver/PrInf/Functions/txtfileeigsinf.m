function txtfileeigsinf(Data,Ra,ARS,type,eigtype)
    % Getting data
    RaS = RatoRaS(Ra);
    [Nx,Ny] = typetoNxNyinf(type);
    ThetaV = Data.(ARS).(type).(RaS).(eigtype);
    % Remove conjugates
    if eigtype == "Eigveven"
        n = [(-Nx/2+1):2:(Nx/2-1) (-Nx/2):2:(Nx/2-1)]; n = repmat(n, Ny/2);  n = n(1,:);
        m = 1:Ny; m = repelem(m, Nx/2);
    else
        n = [(-Nx/2):2:(Nx/2-1) (-Nx/2+1):2:(Nx/2-1)]; n = repmat(n, Ny/2);  n = n(1,:); 
        m = 1:Ny; m = repelem(m, Nx/2);
    end
    [~,~,n,~] = GetRemGeneral_nxny(n,m,Nx,Ny);
    Rem = [];
    for i=1:length(n)
       ninst = n(i); 
       if ninst < 0 % checking if conj
           Rem = [Rem i];
       end    
    end
    ThetaV(Rem) = [];
    % Expand fields
    if eigtype == "Eigveven"
        n = [1:2:(Nx/2-1) 0:2:(Nx/2-1)]; n = repmat(n, Ny/2); n = n(1,:);
        m = 1:Ny; m = repelem(m, Nx/4);
    else
        n = [0:2:(Nx/2-1) 1:2:(Nx/2-1)]; n = repmat(n, Ny/2); n = n(1,:);
        m = 1:Ny; m = repelem(m, Nx/4);
    end
    [Rem,~,~,~] = GetRemGeneral_nxny(n,m,Nx,Ny);
    ThetaV = ExpandFieldsinf(Rem, ThetaV);
    % making dir
    folder = ['/Volumes/Samsung_T5/EigenVecInf/' convertStringsToChars(ARS) '/' num2str(Nx) 'x' num2str(Ny)  '/' convertStringsToChars(RaS)];
    if ~exist(folder, 'dir')
       mkdir(folder)
    end
    % storing values
    Out1 = zeros(length(ThetaV)*2,1); % Real and imaginary values
    for i=1:2:length(ThetaV)*2
        Out1(i) = real(ThetaV((i+1)/2)); % when we add the two c.c. we only get real
        Out1(i+1) = 0;
    end
    % removing very small values
    thres = 1e-13;
    Out1(abs(Out1)<thres) = 0;
    writematrix(Out1,[folder '/ThetaV.txt'],'Delimiter','tab')
end
