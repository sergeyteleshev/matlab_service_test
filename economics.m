arguments;
global mean_arrive factorPlanFileName device_amount mean_service N queue_limit;

device_amount_dif = 2;
device_min = device_amount - device_amount_dif;
device_max = device_amount + device_amount_dif;

s=[device_min device_max device_min device_max device_min device_max device_min device_max];
m_A = mean_arrive;
factorPlanResult = xlsread(factorPlanFileName, 1, "A2:G9");

EH=0.15;

c1=3*10^8;
c2=3*10^5;
c3=9*10^3;
c4=0.015;
c5=0.094;

T=2.5*10^7;

Nq=factorPlanResult(:, 4); 
Ns=factorPlanResult(:, 5);
Ca=factorPlanResult(:, 6);

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

xlswrite(factorPlanFileName ,"I", 1, 'I1');
xlswrite(factorPlanFileName ,I', 1, 'I2:I9');
xlswrite(factorPlanFileName ,[factor_p, factor_Tq, factor_Ts, factor_Nq, factor_Ns, factor_Ca, factor_Cr], 1, 'A11:G11');

xlswrite(factorPlanFileName ,Ist, 1, 'I11:I11');