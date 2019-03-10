function [] = check_priority_generator(Exp_X, N)
    %�������� ��������� � ������ ������������� ������� ����������
    %����������� ���������� ���������� ���������:
    k=round(1.72*(N^(1/3)));
    
    %��������� �� ���������:
    step=(max(Exp_X)-min(Exp_X))/k;
    Int=[min(Exp_X):step:max(Exp_X)];
    
    %������� ���������� ��������� �������, �������� � ������ �� ����������:
    N_i=zeros(1, k);
    for i=1:1:N
        j=1;
        while Exp_X(i)>Int(j+1)
            j=j+1;
        end
        N_i(j)=N_i(j)+1;
    end
    
    %N_i;
    %������� ������� ��������� � ������ ��������:
    H_i=N_i/N;
    
    %����� ����������� � ������� ��������� �������������
    
    figure;
    bar(Int(1:(end-1))+step/2, H_i/step);
    hold on  
end