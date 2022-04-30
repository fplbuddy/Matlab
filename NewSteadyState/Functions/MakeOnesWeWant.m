function res = MakeOnesWeWant(ninst, minst, Nx,Ny,n_list,m_list)
    len = length(m_list);
    res = [zeros(3*len,2) reshape(repelem(n_list,3), 3*len,1) reshape(repelem(m_list,3), 3*len,1)]; % maybe could trim this
    nmax = floor(Nx*sqrt(1/9-1/(4*Ny^2)));
    %mmax = floor(2*N/3);
    rem = zeros(3*Ny*Nx/2,1);
    for i=1:length(n_list)
        n1 = n_list(i);
        m1 = m_list(i);
        n2 = ninst - n1;
        if abs(n2) <= nmax
            minsts = [minst - m1 minst + m1  m1 - minst];
            for j = 1:3
                m2 = minsts(j);
                %if moddinst <= mmax && moddinst >= 1 % i think this error
                %has been fine before, as we have just removed the extra
                %modes with rem
                if n2^2/Nx^2 + m2^2/(4*Ny^2) <= 1/9 && m2 >= 1 
                    res((i-1)*3+j,1) = n2;
                    res((i-1)*3+j,2) = m2;
                else
                    %rem = [(i-1)*3+j rem];
                    rem((i-1)*3+j) = 1;
                end
            end
        else
            %rem = [(i-1)*3+1 (i-1)*3+2 (i-1)*3+3 rem];
            rem((i-1)*3+1:(i-1)*3+3) = 1;
            %rem((i-1)*3+2) = 1;
            %rem((i-1)*3+3) = 1;
        end
    end
    %res(rem,:) = [];
    res(rem==1,:) = [];
end

