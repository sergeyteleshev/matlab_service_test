%�������� ����������
function [] = check_generator(Exp_X, M)

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
    
    %�������� �������� � ������ ������������� ����������� ������������
    %������� xi_kvadrat
    
    %���������� �������������� �������� ����������� ��������� � ���������:
    P_i=exp(-[min(Exp_X):step:max(Exp_X)]/M);
    p_i=P_i(1:end-1)-P_i(2:end);

    %����������� �����������
    p_i(11)=sum(p_i(7:end));
    p_i=p_i(1:11);
    
    N_i(11)=sum(N_i(7:end));
    N_i=N_i(1:11);
    ex=(N_i-p_i*N);
    ex=(N_i-p_i*N).^2./(p_i*N);
 
    %���������� �������� ���������� ��������:
    xi_kvadrat=sum((N_i-p_i*N).^2./(p_i*N));
    if xi_kvadrat < 7.96
        fprintf('��-������� = %g\n', xi_kvadrat);
        fprintf('��-������� < 7.96 => �������� � ������ ������������� ����������� ������������ �����������');
    else
        fprintf('��-������� = %g\n', xi_kvadrat);
        fprintf('��-������� >= 7.96 => �������� � ������ ������������� ����������� ������������ �����������');
    end    
    fprintf('\n');
    fprintf('\n');
end