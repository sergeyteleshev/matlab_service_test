arguments;
global mean_arrive N;

%% Расчет экономической оценки

% Исходные параметры
reqCount = N;
reqArrivalMean = mean_arrive;
stackSize = 20:2:30;
reqServeMean = 50:5:70;
handlersCount = 3:1:5;

% Комбинации
[x, y, z] = ndgrid(stackSize, handlersCount, reqServeMean);
params = [x(:) y(:) z(:)];

% Матрица для результатов
output = zeros(length(params), 12);

% Расчет
for i = 1:length(params)
    % Значения генераторов
    reqArrivalInit = randi(2147483647, 1, 1);
    reqServeInit = randi(2147483647, 1, 1);
    
    % Значения входных параметров модели
    queue_size = params(i, 1);
    s = params(i, 2);
    uS = params(i, 3);
    uA = mean_arrive;
    
    % Создаем модель
    %model = Model(reqCount, uA, uS, stackSize, s, reqArrivalInit, reqServeInit);
    P_start=rem((X_start_generator()+1000),1000);
    A_start=X_start_generator();
    S_start=X_start_generator();

    %Генерирование последовательностей
    A=numbers_generator(A_start, uA, reqCount);
    S=numbers_generator(S_start, uS, reqCount);
    Pr=priority_generator(P_start, reqCount);

    [factor_p, factor_Tq, factor_Ts, factor_Nq, factor_Ns, factor_Ca, factor_Cr, T, U_condition, Q_amount] = modelSystem(A, S, Pr, s, queue_size);
 
    % Считаем экономическую оценку
    I = eco_eval(s, factor_Ns, factor_Nq, uA, factor_Ca);
    
    % Записываем в матрицу
    output(i, :) = [i, queue_size, uS, s, factor_p, factor_Tq, factor_Ts, factor_Nq, factor_Ns, factor_Ca, factor_Cr, I];
end

% Записываем результат в xls
colHeaders = {'№', 'queue_size', 'uS', 's', 'p', 'Tq', 'Ts', 'Nq', 'Ns', 'Ca', 'Cr', 'I'};
xlswrite('eco.xlsx', [colHeaders; num2cell(output)]);

function res = eco_eval(s, Ns, Nq, reqArrivalMean, Ca)
    c1=3*10^8;
    c2=3*10^5;
    c3=9*10^3;
    c4=0.015;
    c5=0.094;    
    En = 0.15;
    c = [c1, c2, c3, c4, c5];
    T = 2.5 * 10^7;
    
    res = En * c(1) * s + c(2) * (Ns - Nq) + c(3) * (s - Ns + Nq) + c(4) * T * ((reqArrivalMean ^ (-1)) - Ca) + c(5) * T * Nq;
end
