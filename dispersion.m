function [DX] = dispersion(X)
    DX=0;
    MX = average(X);
    for k=1:1:length(X)
        DX = DX+(X(k)- MX)*(X(k)-MX);
    end
    DX=DX/(length(X)-1);
end
    