function [X] = X_start_generator()

persistent X_start

a = 2416;
b = 374441;
m = 1771875;


if isempty(X_start)
    X_start = 1500000;
else
    X_start = rem((a*X_start+b),m);

end
X=X_start;
end