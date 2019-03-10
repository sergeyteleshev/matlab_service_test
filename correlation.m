function [p] = correlation(X)
    k=[];
    p=[];
    N = length(X);
    MX = average(X);
    DX = dispersion(X); 
    for j=1:1:(N-1)
       k=0;
       for i=1:1:(N-j)
          k=k+(X(i)-MX)*(X(i+j)-MX);
       end
       k(j)=k/(N-j);
       p(j)=k(j)/DX;
    end
end