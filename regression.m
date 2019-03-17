arguments
global factorPlanFileName device_amount queue_limit mean_service regressionFileName;

factorPlanResult = xlsread(factorPlanFileName, 1, "A2:G9");
device_amount_dif = 2;
queue_limit_dif = 5;
mean_service_dif = 10;
%столбец 1 = девайсы ; столбец 2 = очередь; столбец 3 = время обслуживания
x1max = device_amount + device_amount_dif;
x1min = device_amount - device_amount_dif;

x2max = queue_limit + queue_limit_dif;
x2min = queue_limit - queue_limit_dif;    

x3max = mean_service + mean_service_dif;
x3min = mean_service - mean_service_dif;

answer = [];

for i=1:1:length(factorPlanResult(1, :))
    b = factorPlanResult(:, i);
                   
    A = [
        1 x1min x2min x3min x1min*x2min x1min*x3min x2min*x3min x1min*x2min*x3min;
        1 x1max x2min x3min x1max*x2min x1max*x3min x2min*x3min x1max*x2min*x3min;
        1 x1min x2max x3min x1min*x2max x1min*x3min x2max*x3min x1min*x2max*x3min;
        1 x1max x2max x3min x1max*x2max x1max*x3min x2max*x3min x1max*x2max*x3min;
        1 x1min x2min x3max x1min*x2min x1min*x3max x2min*x3max x1min*x2min*x3max;
        1 x1max x2min x3max x1max*x2min x1max*x3max x2min*x3max x1max*x2min*x3max;
        1 x1min x2max x3max x1min*x2max x1min*x3max x2max*x3max x1min*x2max*x3max;
        1 x1max x2max x3max x1max*x2max x1max*x3max x2max*x3max x1max*x2max*x3max;
    ];
    
    answer = [answer A\b]; 
end

answer

headers = ["p", "Tq", "Ts", "Nq", "Ns", "Ca", "Cr"];
xlswrite(regressionFileName,headers, 1, 'A1:G1');
xlswrite(regressionFileName,answer, 1, 'A2:G9');
