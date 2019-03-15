arguments
global factorPlanFileName device_amount queue_limit mean_service mean_arrive N nFeatures;
runsFileSheet = 1;
device_amount_dif = 2;
queue_limit_dif = 5;
mean_service_dif = 10;
statistic = zeros(1, nFeatures);
headers = ["p", "Tq", "Ts", "Nq", "Ns", "Ca", "Cr"];
xlswrite(factorPlanFileName,headers, 1, 'A1:G1');

n = xlsread(runsFileName, runsFileSheet, 'I2');
%n = 1;

%столбец 1 = девайсы ; столбец 2 = очередь; столбец 3 = время обслуживания
plan = [
    '-','-','-' ;
    '+','-','-' ;
    '-','+','-' ;
    '+','+','-' ;
    '-','-','+' ;
    '+','-','+' ;
    '-','+','+' ;
    '+','+','+' ;
];

length(plan(1, :)) %3
length(plan(:,1)) %8


for i=1:1:length(plan(:, 1))
    current_device_amount = device_amount;
    current_queue_limit = queue_limit;    
    current_mean_service = mean_service;
    
    %столбец 1 = девайсы ; столбец 2 = очередь; столбец 3 = время обслуживания
    for j=1:1:length(plan(1,:))              
        if(j == 1)
            if(plan(i,j) == '+')
                current_device_amount = current_device_amount + device_amount_dif;
            end
            
            if(plan(i,j) == '-')
                current_device_amount = current_device_amount - device_amount_dif;
            end
        end
        
        if(j == 2)
            if(plan(i,j) == '+')
                current_queue_limit = current_queue_limit + queue_limit_dif;
            end
            
            if(plan(i,j) == '-')
                current_queue_limit = current_queue_limit - queue_limit_dif;
            end
        end
        
        if(j == 3)
            if(plan(i,j) == '+')
                current_mean_service = current_mean_service + mean_service_dif;
            end
            
            if(plan(i,j) == '-')
                current_mean_service = current_mean_service - mean_service_dif;
            end
        end
    end
    
    for k=1:1:n
        P_start=rem((X_start_generator()+1000),1000);
        A_start=X_start_generator();
        S_start=X_start_generator();

        %Генерирование последовательностей
        A=numbers_generator(A_start, mean_arrive, N);
        S=numbers_generator(S_start, current_mean_service, N);
        Pr=priority_generator(P_start, N);

        [factor_p, factor_Tq, factor_Ts, factor_Nq, factor_Ns, factor_Ca, factor_Cr, T, U_condition, Q_amount] = modelSystem(A, S, Pr, current_device_amount, current_queue_limit);

        statistic(k, 1) = factor_p;
        statistic(k, 2) = factor_Tq; 
        statistic(k, 3) = factor_Ts;
        statistic(k, 4) = factor_Nq;
        statistic(k, 5) = factor_Ns;
        statistic(k, 6) = factor_Ca;
        statistic(k, 7) = factor_Cr;                 
    end                       
    
    average_statistic = zeros(1, length(statistic(1, :)));
    for m=1:1:length(average_statistic(1, :))
        average_statistic(m) = average(statistic(:, m));
    end  
        
    xlswrite(factorPlanFileName,average_statistic, 1, strcat('A', int2str(i+1)));   
end

fprintf('ФАКТОРНЫЙ ПЛАН ГОТОВ!');    