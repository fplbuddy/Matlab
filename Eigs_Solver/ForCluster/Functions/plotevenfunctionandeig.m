function plotevenfunctionandeig(Data, AR, N,Pr,Ra,G,T)
    TE = 'latex';
    set(groot,'defaultTextInterpreter',TE);
    set(groot, 'DefaultAxesTickLabelInterpreter', TE)
    set(groot, 'DefaultLegendInterpreter', TE);
    type = ['OneOne' num2str(N)];
    PrS = PrtoPrS(Pr);
    RaS = RatoRaS(Ra);
    PsiE = Data.(AR).(type).(PrS).(RaS).PsiE;
    ThetaE = Data.(AR).(type).(PrS).(RaS).ThetaE;
    if length(PsiE) < N^2/4 % then we have truncated in circle
        [~,~,n,m] = GetRemKeep(N,1);
    else
        n = [1:2:(N/2-1) 0:2:(N/2-2)]; n = repmat(n, N/2); n = n(1,:);
        m = 1:N; m = repelem(m, N/4); 
    end
    ky = m*pi;
    kx = n*2*pi/G;
    figure('Renderer', 'painters', 'Position', [5 5 540 500])
    sgt = sgtitle(['$Ra = ' num2str(Ra) ', Pr = ' num2str(Pr) '$']);
    sgt.FontSize = 15;
    x = linspace(G/(2*N*2), G-G/(2*N*2), 2*N); % Evaluate inside squares, 2N since we actually have double the grid points due to e/o decomp
    y = linspace(1/(2*N*2), 1-1/(2*N*2), 2*N);
    [xx, yy] = meshgrid(x,y);

    Eigenfuntionpsi = zeros(2*N, 2*N);
    Eigenfuntiontheta = zeros(2*N, 2*N);
    for i=1:length(kx)
        kxp = kx(i);
        kyp = ky(i);
        amppsi = PsiE(i);
        amptheta = ThetaE(i);
        funcinst = sin(kyp*yy).*exp(1i*xx*kxp);
        Eigenfuntionpsi = 2*real(amppsi*funcinst) + Eigenfuntionpsi; % 2 real is there so we get complex conj as well
        Eigenfuntiontheta = 2*real(amptheta*funcinst) + Eigenfuntiontheta;
    end

    subplot(2,2,1)
    pcolor(Eigenfuntionpsi);
    shading flat
    colormap('jet')
    colorbar
    xlabel('$x$', 'FontSize', 14)
    ylabel('$y$', 'FontSize', 14)
    xticks([1 2*N])
    xticklabels({'$0$' '$\Gamma$'})
    yticks([1 2*N])
    yticklabels({'$0$' '$1$'})
    title('Steady $\psi$', 'FontSize', 15)

    subplot(2,2,2)
    if T
      funcinst = ones(2*N, 2*N)-yy;
      Eigenfuntiontheta = Eigenfuntiontheta + funcinst;
    end
    pcolor(Eigenfuntiontheta);
    shading flat
    colormap('jet')
    colorbar
    xlabel('$x$', 'FontSize', 14)
    ylabel('$y$', 'FontSize', 14)
    xticks([1 2*N])
    xticklabels({'$0$' '$\Gamma$'})
    yticks([1 2*N])
    yticklabels({'$0$' '$1$'})
    title('Steady $\theta$', 'FontSize', 15)
    if T
      title('Steady $T$', 'FontSize', 15)  
    end
    
    
    % Now plot eigenvectors
    V = Data.(AR).(type).(PrS).(RaS).Eigv;
    PsiV = V(1:length(V)/2);
    ThetaV = V(length(V)/2+1:end);
    n = [(-N/2):2:(N/2-1) (-N/2+1):2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:); 
    m = 1:N; m = repelem(m, N/2);
    [~,~,n,m] = GetRemGeneral(n,m,N);
    ky = m*pi;
    kx = n*2*pi/G;
    Eigenfuntionpsi = zeros(2*N, 2*N);
    Eigenfuntiontheta = zeros(2*N, 2*N);
    for i=1:length(kx)
        kxp = kx(i);
        kyp = ky(i);
        amppsi = PsiV(i);
        amptheta = ThetaV(i);
        funcinst = sin(kyp*yy).*exp(1i*xx*kxp);
        Eigenfuntionpsi = amppsi*funcinst + Eigenfuntionpsi; % 2 real is there so we get complex conj as well
        Eigenfuntiontheta = amptheta*funcinst + Eigenfuntiontheta;
    end
    
    subplot(2,2,3)
    pcolor(real(Eigenfuntionpsi));
    shading flat
    colormap('jet')
    colorbar
    xlabel('$x$', 'FontSize', 14)
    ylabel('$y$', 'FontSize', 14)
    xticks([1 2*N])
    xticklabels({'$0$' '$\Gamma$'})
    yticks([1 2*N])
    yticklabels({'$0$' '$1$'})
    title('Eigen $R(\psi)$', 'FontSize', 15)

    subplot(2,2,4)
    pcolor(real(Eigenfuntiontheta));
    shading flat
    colormap('jet')
    colorbar
    xlabel('$x$', 'FontSize', 14)
    ylabel('$y$', 'FontSize', 14)
    xticks([1 2*N])
    xticklabels({'$0$' '$\Gamma$'})
    yticks([1 2*N])
    yticklabels({'$0$' '$1$'})
    title('Eigen $R(\theta)$', 'FontSize', 15)
end


