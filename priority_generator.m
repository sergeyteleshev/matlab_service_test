%Генератор приоритетов

function [ Prt_X ] = priority_generator( X_start, N)
    %Коэффициенты ЛК-генератора
    a = 421;
    b = 1663;
    m = 7875;
    
    Prt_X = [0];
    
    %Вероятность появления X1
    P_X1=0.4;
    
    %Вероятность появления X2
    P_X2=0.3;
    
    %Вероятность появления X3
    P_X3=0.2;
    
    
    X_current = X_start;
    
    i=0;
    
    
    while length(Prt_X)<N
        i=i+1; 
        X_current = rem((a*X_current+b),m);
        
        if (X_current/m)<P_X1
            Prt_X(i) = 1;
        else
            if (X_current/m)<(P_X2+P_X1)
                Prt_X(i) = 2;
            else
                if (X_current/m)<(P_X2+P_X1+P_X3)
                    Prt_X(i) = 3;
                else
                    Prt_X(i) = 4;
                end
            end
        
        end
      
    end
    
    %figure;
    %bar([1 2 3 4],hist(Prt_X,[1 2 3 4])/1000);
end