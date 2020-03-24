function score = TWDTWLinear(x,y)
% x = corn2013;%(5:9);
% x = corn2014;%(5:9);
% x = cotton2013;%(5:10);
% x = cotton2014;%(5:10);
% y = cotton2013;%(5:10);
% y = cotton2014;%(5:10);
r = length(x);
c = length(y);
d = zeros(r,c);
% w = 15;
for m = 1:r
    for n = 1:c
        %     for n = max(m-w,2):min(m+w,c)
        d(m,n)= fabs(x(m)- y(n))+ abs(m-n)/100;
        %         d(m,n)= acos(dot(x(m-1:m), y(n-1:n))/ (norm(x(m-1:m)) * norm(y(n-1:n))));
        %         d(m,n)= pdist([x(m-1:m)'; y(n-1:n)'], 'cosine' );
    end
end

D=zeros(size(d));
D(2,2)=d(2,2);

for m=2:r
    D(m,1)=d(m,1)+D(m-1,1);
end

for n=2:c
    D(1,n)=d(1,n)+D(1,n-1);
end

for m = 3:r
    for n = 3:c
        D(m,n)=d(m,n)+min(D(m-1,n),min(D(m-1,n-1),D(m,n-1))); % this double MIn construction improves in 10-fold the Speed-up. Thanks Sven Mensing
    end
end
% % angle=d(size(x,1),size(y,1));
% [ix,iy] = traceback1(D);
% score=length(ix)*D(size(x,1),size(y,1));
score=D(size(x,1),size(y,1));
% [ix,iy] = traceback1(D);
% dtwplot(x, y, ix, iy, dist,'euclidean')
end