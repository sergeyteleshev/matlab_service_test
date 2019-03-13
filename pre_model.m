nRuns = 30;
nFeatures = 7;

stats = zeros(1, nFeatures);

global N mean_arrive mean_service queue_limit device_amount;

for i=1:1:nRuns
    P_start=rem((X_start_generator()+1000),1000);
    A_start=X_start_generator();
    S_start=X_start_generator();

    %Генерирование последовательностей
    A=numbers_generator(A_start, mean_arrive, N);
    S=numbers_generator(S_start, mean_service, N);
    Pr=priority_generator(P_start, N);

    [factor_p, factor_Tq, factor_Ts, factor_Nq, factor_Ns, factor_Ca, factor_Cr, T, U_condition, Q_amount] = modelSystem(A, S, Pr, device_amount, queue_limit);
    
    stats(i,1) = factor_p;
    stats(i,2) = factor_Tq;
    stats(i,3) = factor_Ts;
    stats(i,4) = factor_Nq;
    stats(i,5) = factor_Ns;
    stats(i,6) = factor_Ca;
    stats(i,7) = factor_Cr;
end

stats