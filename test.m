function [factor_p, factor_Tq, factor_Ts, factor_Nq, factor_Ns, factor_Ca, factor_Cr, T, U_condition, Q_amount] = modelSystem(A, S, Pr, device_number, queue_max)        
    U=zeros(1, device_number);           %������ ��������� -  �����
    U_priority=zeros(1, device_number);  %������ ��������� - ����������
    T=[0];                               %������ ���������� �������
    Int=[];                              %������ ���������� �������
    Q=zeros(1, queue_max);                                %������ ������� - ����� ���������� ������ S(i)
    Q_current=zeros(1, queue_max);                        %������ ������� - ���������� ������ ������ i 
    Q_priority=zeros(1, queue_max);                       %������ ������� - ���������� ������

    
    p=zeros(1, device_number); %�����, ������� ������ ���������� ���������� � ��������� ��������� ������
    d=[];                      %����� ���������� ������ ������ � �������
    
    
    n=length(A);               %����� ����� ����������� � ������� ����������   
    Ns=0;                      %����� ��������� ������
    
    Q_amount=[0];              %������ ����� ���������� � ������� - ��������� ��� �������
    S_amount=[0];              %������ ����� ���������� � ������� - ��������� ��� �������
    dn=[];                     %������ �������� ����� �������� ������ � ������� - ��������� ��� �������
    sn=[];                     %������ �������� ����� ���������� ������ � ������� - ��������� ��� �������
    p_current=[0];             %������ ������� ������������� ������� - ��������� ��� �������
    
    
    U_condition(1,:)=[U];      %������ ��������� ��������� - ��������� ��� ������������
     
    i=1;                       %���������� ����������� ������ ������� ������
    
    while i <= n
        %����������� ���������� �������: ����������� ����� ������(�(i)) ���
        %���������� ������� (S_MIN)
        
        % ���������� ������������� �������� ����� ���� ��������������� ��������
        S_MIN = max([A,S])+1;

        % ���� �����-�� �� ��������� ������...
        if ~isempty(U(U>0))
           S_MIN = min(U(U>0));
        end
        
        if S_MIN < A(i)  %��������� ������� - ���������� ��������� ������                        
            %��������� �������� �������
            Int(end+1)=S_MIN;
            T(end+1)=T(end)+S_MIN;                        
            
            %������� ������� ��������� ��������� ������
            A(i)=A(i)-S_MIN;
            
            for k = 1:1:length(U)
                 if U(k)>0 && (length(Int)>1)
                     U(k)=U(k)-S_MIN;
                     if(U(k))
                     %���� ���������� p
                     %p(k)=p(k)+S_MIN;
                 end
            end
            
        else %��������� ������� - ����������� ����� ������                        
            
        end

        %��������� S_MIN � ������� ����������� ����� ������
    end
end