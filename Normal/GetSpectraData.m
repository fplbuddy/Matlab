run ./Random_Plots/SetUp.m
G = 2;
thresh = 0.95;
ARS = ['AR_' num2str(G)];
Spectrum_list = ["Epspectrum","Ekspectrum"];
Pr_list = [30,50,100,150,200,250,300];
Ramin = 1e7;
for i=1:length(Spectrum_list)
    Spectrum = convertStringsToChars(Spectrum_list(i));
    for j=1:length(Pr_list)
        Pr = Pr_list(j), PrS = PrtoPrS(Pr);
        RaS_list = string(fieldnames(AllData.(ARS).(PrS)));
        for k=1:length(RaS_list)
            RaS = RaS_list(k); Ra = RaStoRa(RaS);
            if Ra < Ramin
                continue
            end
            % Get Data
            [shearing,nonshearing,numshearing,numnonshearing] = GetDataForSpectra(AllData,Pr,Ra, G,Spectrum);
            % Get power law
            Res = AllData.(ARS).(PrS).(RaS).Res;
            [Nx,~] = nxny(Res);
            if numnonshearing > 0
                [powernonshearing,Rvalns,lowerns,upperns] = GetPLFromSpectra(nonshearing,Spectrum,Nx,thresh);
            else
                powernonshearing = NaN;
                Rvalns = NaN;
                lowerns = NaN;
                upperns = NaN;
            end
            if numshearing > 0
                [powershearing,Rvals,lowers,uppers] = GetPLFromSpectra(shearing,Spectrum,Nx,thresh);
            else
                powershearing = NaN;
                Rvals = NaN;
                lowers = NaN;
                uppers = NaN;
            end
            AllData.(ARS).(PrS).(RaS).(Spectrum).powernonshearing = powernonshearing;
            AllData.(ARS).(PrS).(RaS).(Spectrum).powershearing = powershearing;
            AllData.(ARS).(PrS).(RaS).(Spectrum).Rvalns = Rvalns;
            AllData.(ARS).(PrS).(RaS).(Spectrum).Rvals = Rvals;
            AllData.(ARS).(PrS).(RaS).(Spectrum).lowers = lowers;
            AllData.(ARS).(PrS).(RaS).(Spectrum).lowerns = lowerns;
            AllData.(ARS).(PrS).(RaS).(Spectrum).uppers = uppers;
            AllData.(ARS).(PrS).(RaS).(Spectrum).upperns = upperns;
        end
    end
end

%% Look at data
figure('Renderer', 'painters', 'Position', [5 5 600 300])
G = 2;
ARS = ['AR_' num2str(G)];
Spectrum = 'Ekspectrum';
Pr_list = [30,50,100,150,200,250,300];
Ramin = 1e7;
for j=1:length(Pr_list)
    Pr = Pr_list(j); PrS = PrtoPrS(Pr);
    RaS_list = string(fieldnames(AllData.(ARS).(PrS)));
    powers = [];
    Ra_list = [];
    for k=1:length(RaS_list)
        RaS = RaS_list(k); Ra = RaStoRa(RaS);
        if Ra < Ramin
            continue
        end
        powers = [AllData.(ARS).(PrS).(RaS).(Spectrum).powershearing powers];
        Ra_list = [Ra Ra_list];
    end
    [Ra_list,I] = sort(Ra_list);
    powers = powers(I);
    semilogx(Ra_list,powers,'DisplayName', num2str(Pr)), hold on
end
lgnd = legend('Location', 'Bestoutside', 'FontSize', numFS); title(lgnd,'$Pr$', 'FontSize', numFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$Ra$', 'FontSize',labelFS)
ylabel('Exponent', 'FontSize',labelFS)
if Spectrum(2) == 'p'
    title('$|\widehat \theta_{k_x,k_y}|^2$','FontSize', labelFS)
else
    title('$|\nabla^2 \widehat \psi_{k_x,k_y}|^2$','FontSize', labelFS)
end






