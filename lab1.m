function [] = lab1()
    global N mean_arrive mean_service;

    P_start=rem((X_start_generator()+1000),1000);
    A_start=X_start_generator();
    S_start=X_start_generator();

    %Генерирование последовательностей
    A=numbers_generator(A_start, mean_arrive, N);
    S=numbers_generator(S_start, mean_service, N);
    Pr=priority_generator(P_start, length(A));

    check_generator(A, mean_arrive);
    check_generator(S, mean_service);
    check_priority_generator(Pr, N);
end