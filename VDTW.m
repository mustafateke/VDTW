function score = VDTW(x,y)
% VDTW Codes computes vector distance between two signals x and y
% Mustafa Teke, mustafa.teke@gmal.com, 17.02.2019

% This code is based on Pau Mico's implementation of DTW
% https://www.mathworks.com/matlabcentral/fileexchange/16350-continuous-dynamic-time-warping?s_tid=prof_contriblnk

r = length(x);
c = length(y);
d = zeros(r,c);

for m = 2:r
    for n = 2:c
        
        d(m,n)= acos(dot(x(m-1:m), y(n-1:n))/ (norm(x(m-1:m)) * norm(y(n-1:n))));
        
    end
end

D=zeros(size(d));
D(2,2)=d(2,2);

for m=3:r
    D(m,2)=d(m,2)+D(m-1,2);
end

for n=3:c
    D(2,n)=d(2,n)+D(2,n-1);
end

for m = 3:r
    for n = 3:c
        D(m,n)=d(m,n)+min(D(m-1,n),min(D(m-1,n-1),D(m,n-1)));
    end
end

score=D(size(x,1),size(y,1));

end