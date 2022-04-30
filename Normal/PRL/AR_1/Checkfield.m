for num = 5900:5910
    num = num2str(num);
    pathF = convertStringsToChars([path '/Fields/']);
    files = dir([pathF,'hd2DTT','.*.',num,'.dat']);
    ff = zeros(nx*ny/nmpi,nmpi);
    for i=1:nmpi % Looping round mpi
        fid = fopen([pathF,files(i).name],'r');
        fread(fid,1,'real*4');
        ff(:,i) = fread(fid,inf,'real*8');
        fclose(fid);
    end
    figure
    ff = reshape(ff,nx,ny);
    fieldcheck = ff';
    pcolor(ff');
    shading flat
    colormap('jet')
    colorbar
    xlabel('$x$', 'FontSize', 14)
    ylabel('$y$', 'FontSize', 14)
    xticks([1 nx])
    xticklabels({'$0$' '$\Gamma$'})
    yticks([1 ny])
    yticklabels({'$0$' '$1$'})
end
%%

for num = 5900:6000
    num = num2str(num);
    fid = fopen([pathF 'spectrum2D_UU.' num '.out'],'r');
    fread(fid,1, 'real*4');
    Spectra = fread(fid,inf, 'real*8');
    fclose(fid);
    % Reshape and plot
    figure
    Spectra = reshape(Spectra,xr,yr);
    pcolor(Spectra');
    colormap('jet')
    colorbar; caxis([1e-6 1e-1])
    set(gca,'ColorScale','log')
    xlim([1 10])
    ylim([1 10])
    xlabel('$k_x$', 'FontSize', 14)
    ylabel('$k_y$', 'FontSize', 14)
    l = 3:2:40; l = l/2;
    xticks(l)
    xticklabels({'$0$' '$1$' '$2$' '$3$' '$4$' '$5$' '$6$' '$7$' '$8$'})
    yticks(l)
    yticklabels({'$1$' '$2$' '$3$' '$4$' '$5$' '$6$' '$7$' '$8$' '$9$' '$10$' '$11$' '$12$' '$13$' '$14$' '$15$' '$16$' '$17$' '$18$' '$19$'})
end


