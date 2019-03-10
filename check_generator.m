%Проверка генератора
function [] = check_generator(Exp_X, M)

    N=length(Exp_X);
    
    %Оценка мат.ожидания
    MX=average(Exp_X);
    fprintf('Мат ожидание: %g\n', MX);    
    
    %Оценка дисперсии
    DX=dispersion(Exp_X);
    fprintf('Дисперсия: %g\n', DX);
    
    %Корреляционная функция
    p = correlation(Exp_X);  
    
    %Построение гистограммы
    step=1;
    
    figure;
    bar([min(Exp_X)+step/2:step:max(Exp_X)-step/2],hist(Exp_X,[min(Exp_X)+step/2:step:max(Exp_X)-step/2])/(N*step/10));
    hold on
    plot ([min(Exp_X):step:max(Exp_X)],exp(-[min(Exp_X):step:max(Exp_X)]/M), 'r', 'LineWidth', 3);
    
    %Построение графика последующего от предыдущего(диаграмма разброса)
    figure;
    plot(Exp_X(1:end-1),Exp_X(2:end), '*r');
    
    %Построение графика коэффициента корреляции
    figure;
    plot(1:20, p(1:20), '-mo');
    
    
    %Построение доверительного интервала для математического ожидания
    A_MX = MX-1.96*sqrt(DX)/sqrt(N);
    B_MX = MX+1.96*sqrt(DX)/sqrt(N);   
    
    if (M<B_MX)&&(M>A_MX)       
        fprintf('Доверительный интервал:');
        display([A_MX B_MX]);
        disp('Теоретическое значение математического ожидания попадает в доверительный интервал с вероятностью 95%');
    else
        fprintf('Доверительный интервал:');
        display([A_MX B_MX]);
        disp('Теоретическое значение математического ожидания не попадает в доверительный интервал с вероятностью 95%');
    end
    
    %Проверка гипотезы о значении математического ожидания
    %Вычисление статистики критерия значимости:
    Z=sqrt(N)*(MX-M)/sqrt(DX);
    if abs(Z)<1.96
        fprintf('|Z| = %g\n', abs(Z));
        fprintf('t = %g\n', 1.96);
        fprintf("|Z| < t => Гипотеза о значении математического ожидания принимается \n");       
    else
        fprintf('|Z| = %g\n', abs(Z));
        fprintf('t = %g\n', 1.96);
        fprintf("|Z| >= t => Гипотеза о значении математического ожидания отвергается \n");              
    end
    
    %Проверка гипотезуы о законе распределения методом гистограмм
    %Определение количества интервалов разбиения:
    k = round(1.72*(N^(1/3)));
    
    %Разбиение на интервалы:
    step=(max(Exp_X)-min(Exp_X))/k;
    Int = [min(Exp_X):step:max(Exp_X)];
    
    %Подсчет количества случайных величин, попавших в каждый из интервалов:
    N_i=zeros(1, k);
    for i=1:1:N
        j=1;
        while Exp_X(i)>Int(j+1)
            j=j+1;
        end
        N_i(j)=N_i(j)+1;
    end
    
    %N_i
    %Подсчет частоты попадания в каждый интервал:
    H_i=N_i/N;
    
    %Вывод гистограммы и графика плотности распределения
    
    figure;
    bar(Int(1:(end-1))+step/2, H_i/step);
    hold on
    plot ([min(Exp_X):step:max(Exp_X)],exp(-[min(Exp_X):step:max(Exp_X)]/M)/M, 'r', 'LineWidth', 3);
    
    [Nh, edges] = histcounts(Exp_X);
    Nh = Nh / length(Exp_X);
    summ = sum(Nh);
    fprintf('Площадь гистограммы: %.4f\n', summ);
    
    %Проверка гипотезы о законе распределения генеральной совокупности
    %методом xi_kvadrat
    
    %Вычисление теоретического значения вероятности попадания в интервалы:
    P_i=exp(-[min(Exp_X):step:max(Exp_X)]/M);
    p_i=P_i(1:end-1)-P_i(2:end);

    %Объединение промежутков
    p_i(11)=sum(p_i(7:end));
    p_i=p_i(1:11);
    
    N_i(11)=sum(N_i(7:end));
    N_i=N_i(1:11);
    ex=(N_i-p_i*N);
    ex=(N_i-p_i*N).^2./(p_i*N);
 
    %Вычисление значения статистики критерия:
    xi_kvadrat=sum((N_i-p_i*N).^2./(p_i*N));
    if xi_kvadrat < 7.96
        fprintf('Хи-квадрат = %g\n', xi_kvadrat);
        fprintf('Хи-квадрат < 7.96 => Гипотеза о законе распределения генеральной совокупности принимается');
    else
        fprintf('Хи-квадрат = %g\n', xi_kvadrat);
        fprintf('Хи-квадрат >= 7.96 => Гипотеза о законе распределения генеральной совокупности отвергается');
    end    
    fprintf('\n');
    fprintf('\n');
end