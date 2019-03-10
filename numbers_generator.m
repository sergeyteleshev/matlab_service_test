%Генератор по количеству заявок в системе

function [ Exp_X ] = numbers_generator( X_start, MX, N)
    %Коэффициенты ЛК-генератора
    a = 630360016;
    b = 0;
    m = 2147483647;
    
    %Вычисление первого значения
    Exp_X = [-log(X_start/m)*MX];    
    
    X_current = X_start;
    
    i=1;
    
    while length(Exp_X)<N+1
        i=i+1; 
        X_current = rem((a*X_current+b),m);
        Exp_X(i) = -log(X_current/m)*MX;
        
    end
    Exp_X=Exp_X(2:length(Exp_X));
    
end