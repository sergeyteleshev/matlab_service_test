global N mean_arrive mean_service queue_limit device_amount;
nRuns = 50;
nFeatures = 7;
statistic = zeros(1, nFeatures);
sheetList = 1;
runsFileName = 'pre_model.xlsx';

for i=1:1:nRuns
    P_start=rem((X_start_generator()+1000),1000);
    A_start=X_start_generator();
    S_start=X_start_generator();

    %Генерирование последовательностей
    A=numbers_generator(A_start, mean_arrive, N);
    S=numbers_generator(S_start, mean_service, N);
    Pr=priority_generator(P_start, N);

    [factor_p, factor_Tq, factor_Ts, factor_Nq, factor_Ns, factor_Ca, factor_Cr, T, U_condition, Q_amount] = modelSystem(A, S, Pr, device_amount, queue_limit);
    
    statistic(i, 1) = factor_p;
    statistic(i, 2) = factor_Tq; 
    statistic(i, 3) = factor_Ts;
    statistic(i, 4) = factor_Nq;
    statistic(i, 5) = factor_Ns;
    statistic(i, 6) = factor_Ca;
    statistic(i, 7) = factor_Cr;   
end

mean_stat = zeros(1, nFeatures);
var_stat = zeros(1, nFeatures);
n_stat = zeros(1, nFeatures);

for i=1:1:nFeatures    
    mean_stat(i) = average(statistic(:,i));
    var_stat(i) = dispersion(statistic(:,i));
    epsilon = 0.05 * mean_stat(i);
    n_stat(i) = (1.96 ^ 2 * var_stat(i)) / epsilon ^ 2;
end

n_max = ceil(max(n_stat))

headers = ["p", "Tq", "Ts", "Nq", "Ns", "Ca", "Cr"];
xlswrite(runsFileName,headers, sheetList, 'A1:G1');
xlswrite(runsFileName,statistic, sheetList, 'A2');
xlswrite(runsFileName,"n", sheetList, 'I1');
xlswrite(runsFileName,n_max, sheetList, 'I2');