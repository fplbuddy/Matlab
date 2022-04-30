function [M,rem] = CleanEigenMatrix(M, N,type,DNS)
%     if type == "odd"
%         n = [(-N/2):2:(N/2-1) (-N/2+1):2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:); % This is half the length of the matrix
%         m = 1:N; m = repelem(m, N/2);
%     else
%         n = [(-N/2+1):2:(N/2-1) (-N/2):2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:); 
%         m = 1:N; m = repelem(m, N/2);
%     end
%     ad = length(n);
%     rem = [];
%     if DNS
%         N = N*2/3; % 2/3 dialising rule
%     end
%     for i = 1:length(n)
%         ninst = 2*n(i); minst = m(i); % The two is here to make it a circle;
%         check = sqrt(ninst^2+minst^2);
%         if check > N
%             rem = [i i+ad rem];
%         end
%     end
%     % stirp matrix
%     M(rem,:) = [];
%     M(:,rem) = [];

    if type == "odd"
        n = [(-N/2):2:(N/2-1) (-N/2+1):2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:); % This is half the length of the matrix
        m = 1:N; m = repelem(m, N/2);
    else
        n = [(-N/2+1):2:(N/2-1) (-N/2):2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:); 
        m = 1:N; m = repelem(m, N/2);
    end
    ad = length(n);
    rem = [];
    if DNS
        kmax = 1/9;
    else
        kmax = 1/4;
    end
    for i = 1:length(n)
        ninst = n(i); minst = m(i); % The two is here to make it a circle;
        check = ninst^2/N^2+minst^2/(4*N^2);
        if check > kmax
            rem = [i i+ad rem];
        end
    end
    % stirp matrix
    M(rem,:) = [];
    M(:,rem) = [];  
end

