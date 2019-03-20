%�������� ����������
function [] = check_generator(Exp_X, M)
    xiKvadratFileName = "chiSquare.xlsx";
    N=length(Exp_X);
    
    %������ ���.��������
    MX=average(Exp_X);
    fprintf('��� ��������: %g\n', MX);    
    
    %������ ���������
    DX=dispersion(Exp_X);
    fprintf('���������: %g\n', DX);
    
    %�������������� �������
    p = correlation(Exp_X);  
    
    %���������� �����������
    step=1;
    
    figure;
    bar([min(Exp_X)+step/2:step:max(Exp_X)-step/2],hist(Exp_X,[min(Exp_X)+step/2:step:max(Exp_X)-step/2])/(N*step/10));
    hold on
    plot ([min(Exp_X):step:max(Exp_X)],exp(-[min(Exp_X):step:max(Exp_X)]/M), 'r', 'LineWidth', 3);
    
    %���������� ������� ������������ �� �����������(��������� ��������)
    figure;
    plot(Exp_X(1:end-1),Exp_X(2:end), '*r');
    
    %���������� ������� ������������ ����������
    figure;
    plot(1:20, p(1:20), '-mo');
        
    %���������� �������������� ��������� ��� ��������������� ��������
    A_MX = MX-1.96*sqrt(DX)/sqrt(N);
    B_MX = MX+1.96*sqrt(DX)/sqrt(N);   
    
    if (M<B_MX)&&(M>A_MX)       
        fprintf('������������� ��������:');
        display([A_MX B_MX]);
        disp('������������� �������� ��������������� �������� �������� � ������������� �������� � ������������ 95%');
    else
        fprintf('������������� ��������:');
        display([A_MX B_MX]);
        disp('������������� �������� ��������������� �������� �� �������� � ������������� �������� � ������������ 95%');
    end
    
    %�������� �������� � �������� ��������������� ��������
    %���������� ���������� �������� ����������:
    Z=sqrt(N)*(MX-M)/sqrt(DX);
    if abs(Z)<1.96
        fprintf('|Z| = %g\n', abs(Z));
        fprintf('t = %g\n', 1.96);
        fprintf("|Z| < t => �������� � �������� ��������������� �������� ����������� \n");       
    else
        fprintf('|Z| = %g\n', abs(Z));
        fprintf('t = %g\n', 1.96);
        fprintf("|Z| >= t => �������� � �������� ��������������� �������� ����������� \n");              
    end
    
    %�������� ��������� � ������ ������������� ������� ����������
    %����������� ���������� ���������� ���������:
    k = round(1.72*(N^(1/3)));
    
    %��������� �� ���������:
    step=(max(Exp_X)-min(Exp_X))/k;
    Int = [min(Exp_X):step:max(Exp_X)];
    leftInt = [];
    rightInt = [];
    
    for k=1:1:length(Int) - 1
        leftInt(end+1) = Int(k);
        rightInt(end+1) = Int(k+1);
    end
    
    %������� ���������� ��������� �������, �������� � ������ �� ����������:
    N_i=zeros(1, k);
    for i=1:1:N
        j=1;
        while Exp_X(i)>Int(j+1)
            j=j+1;
        end
        N_i(j)=N_i(j)+1;
    end
    
    %N_i
    %������� ������� ��������� � ������ ��������:
    H_i=N_i/N;
    
    %����� ����������� � ������� ��������� �������������
    
    figure;
    bar(Int(1:(end-1))+step/2, H_i/step);
    hold on
    plot ([min(Exp_X):step:max(Exp_X)],exp(-[min(Exp_X):step:max(Exp_X)]/M)/M, 'r', 'LineWidth', 3);
    
    [Nh, edges] = histcounts(Exp_X);
    Nh = Nh / length(Exp_X);
    summ = sum(Nh);
    fprintf('������� �����������: %.4f\n', summ);
  
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
    disp('���������� �������� ��-�������');
    disp(Z);
    alpha = 0.05;
    degree = k - 2;
    chi_table = chi2inv(1 - alpha, degree);
    disp('��������� �������� �������� ��-�������');
    disp(chi_table);
    if Z <= chi_table
        disp('�������� � ������ ������������� ����������� ������������ �����������');
    else
        disp('�������� � ������ ������������� ����������� ������������ �����������');
    end
    
    headers = ["����� �������", "������ �������", "h", "p_i", "z_i"];
    xlswrite(xiKvadratFileName,headers, currentSheet, 'A1:E1');        
    xlswrite(xiKvadratFileName,transpose(h), currentSheet, 'C2');
    xlswrite(xiKvadratFileName,transpose(partial_p), currentSheet, 'D2');
    xlswrite(xiKvadratFileName,transpose(z_i), currentSheet, 'E2');  
end