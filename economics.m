arguments;
global mean_arrive factorPlanFileName device_amount mean_service N queue_limit regressionFileName economicsFileName;

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

s=[x1min x1max x1min x1max x1min x1max x1min x1max];
m_A = mean_arrive;
factorPlanResult = xlsread(factorPlanFileName, 1, "A2:G9");
a = xlsread(regressionFileName, 1, "A2:G9")

EH=0.15;

c1=3*10^8;
c2=3*10^5;
c3=9*10^3;
c4=0.015;
c5=0.094;

T=2.5*10^7;

y = zeros(length(a(1,:)), length(a(:,1))-1);

for i=1:1:7
    y(1,i) = a(1,i) + a(2,i)*x1min + a(3,i)*x2min + a(4,i)*x3min + a(5,i)*x1min*x2min + a(6,i)*x1min*x3min + a(7,i)*x2min*x3min + a(8,i)*x1min*x2min*x3min;
    y(2,i) = a(1,i) + a(2,i)*x1max + a(3,i)*x2min + a(4,i)*x3min + a(5,i)*x1max*x2min + a(6,i)*x1max*x3min + a(7,i)*x2min*x3min + a(8,i)*x1max*x2min*x3min;
    y(3,i) = a(1,i) + a(2,i)*x1min + a(3,i)*x2max + a(4,i)*x3min + a(5,i)*x1min*x2max + a(6,i)*x1min*x3min + a(7,i)*x2max*x3min + a(8,i)*x1min*x2max*x3min;
    y(4,i) = a(1,i) + a(2,i)*x1max + a(3,i)*x2max + a(4,i)*x3min + a(5,i)*x1max*x2max + a(6,i)*x1max*x3min + a(7,i)*x2max*x3min + a(8,i)*x1max*x2max*x3min;
    y(5,i) = a(1,i) + a(2,i)*x1min + a(3,i)*x2min + a(4,i)*x3max + a(5,i)*x1min*x2min + a(6,i)*x1min*x3max + a(7,i)*x2min*x3max + a(8,i)*x1min*x2min*x3max;
    y(6,i) = a(1,i) + a(2,i)*x1max + a(3,i)*x2min + a(4,i)*x3max + a(5,i)*x1max*x2min + a(6,i)*x1max*x3max + a(7,i)*x2min*x3max + a(8,i)*x1max*x2min*x3max;
    y(7,i) = a(1,i) + a(2,i)*x1min + a(3,i)*x2max + a(4,i)*x3max + a(5,i)*x1min*x2max + a(6,i)*x1min*x3max + a(7,i)*x2max*x3max + a(8,i)*x1min*x2max*x3max;
    y(8,i) = a(1,i) + a(2,i)*x1max + a(3,i)*x2max + a(4,i)*x3max + a(5,i)*x1max*x2max + a(6,i)*x1max*x3max + a(7,i)*x2max*x3max + a(8,i)*x1max*x2max*x3max;
end

Nq=y(:, 4); 
Ns=y(:, 5);
Ca=y(:, 6);

I=[];

for k=1:1:8    
    I(k)=EH*c1*s(k)+c2*(Ns(k)-Nq(k))+c3*(s(k)-Ns(k)+Nq(k))+ c4*T*(1/m_A-Ca(k))+c5*T*Nq(k);
end

I'

P_start=rem((X_start_generator()+1000),1000);
A_start=X_start_generator();
S_start=X_start_generator();

%Генерирование последовательностей
A=numbers_generator(A_start, mean_arrive, N);
S=numbers_generator(S_start, mean_service, N);
Pr=priority_generator(P_start, N);

[factor_p, factor_Tq, factor_Ts, factor_Nq, factor_Ns, factor_Ca, factor_Cr, T, U_condition, Q_amount] = modelSystem(A, S, Pr, device_amount, queue_limit);

Ist=EH*c1*device_amount+c2*(factor_Ns-factor_Nq)+c3*(device_amount-factor_Ns+factor_Nq)+ c4*T*(1/m_A-factor_Ca)+c5*T*factor_Nq;

headers = ["p", "Tq", "Ts", "Nq", "Ns", "Ca", "Cr"];
xlswrite(economicsFileName,headers, 1, 'A1:G1');
xlswrite(economicsFileName,"I", 1, 'I1');
xlswrite(economicsFileName, y, 1, 'A2');
xlswrite(economicsFileName ,I', 1, 'I2:I9');
xlswrite(economicsFileName ,[factor_p, factor_Tq, factor_Ts, factor_Nq, factor_Ns, factor_Ca, factor_Cr], 1, 'A11:G11');

xlswrite(economicsFileName ,Ist, 1, 'I11:I11');