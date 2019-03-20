%Проверка генератора
function [] = check_generator(Exp_X, M)
    xiKvadratFileName = "chiSquare.xlsx";
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
    leftInt = [];
    rightInt = [];
    
    for k=1:1:length(Int) - 1
        leftInt(end+1) = Int(k);
        rightInt(end+1) = Int(k+1);
    end
    
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
  
    %chi square
    k = round(1.72 * N ^ (1/3));
    interval_length = (max(Exp_X) - min(Exp_X)) / k;
    h = histcounts(Exp_X, min(Exp_X):interval_length:max(Exp_X));
    an = min(Exp_X);
    bn = an + interval_length;
    syms x;
    initial_distribution = 1 / M * exp(-x / M);
    partial_p = zeros(1, k);
    
    [status,sheets,xlFormat] = xlsfinfo(xiKvadratFileName);
    currentSheet = 1;
    if(length(sheets) == 1)
        currentSheet = 2;
    end
    
    for i=1:k
        partial_p(i) = int(initial_distribution, x, [an bn]);
        an = an + interval_length;
        bn = bn + interval_length;
        xlswrite(xiKvadratFileName,an, currentSheet, strcat('A',num2str(i+1)));
        xlswrite(xiKvadratFileName,bn, currentSheet, strcat('B',num2str(i+1)));
    end

    Z = 0;
    z_i = [];
    for i=1:k
        z_i(end+1) = (h(i) - partial_p(i) * N) ^ 2 / (partial_p(i) * N);
        Z = Z + z_i(i);       
    end
    disp('Статистика критерия хи-квадрат');
    disp(Z);
    alpha = 0.05;
    degree = k - 2;
    chi_table = chi2inv(1 - alpha, degree);
    disp('Табличное значение критерия хи-квадрат');
    disp(chi_table);
    if Z <= chi_table
        disp('Гипотеза о законе распределения генеральной совокупности принимается');
    else
        disp('Гипотеза о законе распределения генеральной совокупности отвергается');
    end
    
    headers = ["левая граница", "правая граница", "h", "p_i", "z_i"];
    xlswrite(xiKvadratFileName,headers, currentSheet, 'A1:E1');        
    xlswrite(xiKvadratFileName,transpose(h), currentSheet, 'C2');
    xlswrite(xiKvadratFileName,transpose(partial_p), currentSheet, 'D2');
    xlswrite(xiKvadratFileName,transpose(z_i), currentSheet, 'E2');  
end