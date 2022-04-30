function txtfilesteadyinf(Data,Ra,ARS,type)
    % Getting data
    RaS = RatoRaS(Ra);
    ThetaE = Data.(ARS).(type).(RaS).ThetaE;
    [Nx,Ny] = typetoNxNyinf(type);
    n = [1:2:(Nx/2-1) 0:2:(Nx/2-2)]; n = repmat(n, Ny/2); n = n(1,:);
    m = 1:Ny; m = repelem(m, Nx/4);
    [Rem,~,~,~] = GetRemGeneral_nxny(n,m,Nx,Ny);
    ThetaE =  ExpandFieldsinf(Rem, ThetaE);
    % making dir
    folder = ['/Volumes/Samsung_T5/SteadyStatesInf/' convertStringsToChars(ARS) '/' num2str(Nx) 'x' num2str(Ny)  '/' convertStringsToChars(RaS)];
    if ~exist(folder, 'dir')
       mkdir(folder)
    end
    % storing values
    Out1 = zeros(length(ThetaE)*2,1); % Real and imaginary values
    for i=1:2:length(ThetaE)*2
        Out1(i) = real(ThetaE((i+1)/2));
        Out1(i+1) = imag(ThetaE((i+1)/2));  
    end
    writematrix(Out1,[folder '/ThetaE.txt'],'Delimiter','tab')
end