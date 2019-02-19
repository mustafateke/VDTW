function score = VDTW(x,y)
% VDTW Codes computes vector distance between two signals x and y
% Mustafa Teke, mustafa.teke@gmal.com, 17.02.2019

% This code is based on Pau Mico's implementation of DTW
% https://www.mathworks.com/matlabcentral/fileexchange/16350-continuous-dynamic-time-warping?s_tid=prof_contriblnk

r = length(x);
c = length(y);
psi = zeros(r, c); %distance matrix
d = zeros(r, c); % accumulated distance matrix.
for m = 2:r
    for n = 2:c   
        psi(m,n)= acos(dot(x(m-1:m), y(n-1:n))/ (norm(x(m-1:m)) * norm(y(n-1:n))));
    end
end

for m= 2:r
    d(m,2) = psi(m,2)+d(m-1,2);
end

for n= 2:c
    d(2,n)= psi(2,n)+d(2,n-1);
end

for m = 3:r
    for n = 3:c
        d(m,n) = psi(m,n) + min(d(m-1,n), min(d(m-1,n-1),d(m,n-1)));
    end
end

score = d(size(x,1),size(y,1));

end