n1 = '0100';
n2 = '0101';
n3 = '0300';
type = 'PEspec';
spec1 = importdata([path '/Spectra/' type n1 '.txt']);
spec2 = importdata([path '/Spectra/' type n2 '.txt']);
spec3 = importdata([path '/Spectra/' type n3 '.txt']);
figure()
loglog(spec1), hold on
loglog(spec2), hold on
loglog(spec3), hold on
