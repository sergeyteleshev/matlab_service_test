
%factor_p - ����������� ������������� �������
%factor_Tq - ������� ����� �������� ����� � �������
%factor_Ts - ������� ����� ���������� ����� � �������
%factor_Nq - ������� �� ������� ����� ���������� � �������
%factor_Ns - ������� �� ������� ����� ���������� � �������
%factor_C - ���������� ���������� ����������� �������
%factor_Cr - ������������� ���������� ����������� �������

%T - ������ ���������� �������
%U_condition - ������ ��������� ���������
%Q_amount=[0] - ������ ����� ���������� � ������� - ��������� ��� �������

%� - ����� ����� ������������� ����������
%S - ����� ��������� ����������    
%device_number - ���������� ��������� ���������
%queue_max - ����� �������


function [factor_p, factor_Tq, factor_Ts, factor_Nq, factor_Ns, factor_Ca, factor_Cr, T, U_condition, Q_amount] = modelSystem(A, S, Pr, device_number, queue_max)

    
    %������������� ����������
    
    U=zeros(1, device_number);           %������ ��������� -  �����
    U_priority=zeros(1, device_number);  %������ ��������� - ����������
    T=[0];                               %������ ���������� �������
    Int=[];                              %������ ���������� �������
    Q=[];                                %������ ������� - ����� ���������� ������ S(i)
    Q_current=[];                        %������ ������� - ���������� ������ ������ i 
    Q_priority=[];                       %������ ������� - ���������� ������

    
    p=zeros(1, device_number); %�����, ������� ������ ���������� ���������� � ��������� ��������� ������
    d=[];                      %����� ���������� ������ ������ � �������
    
    
    n=length(A);               %����� ����� ����������� � ������� ����������
    fail=0;                    %���������� �������
    
    Q_amount=[0];              %������ ����� ���������� � ������� - ��������� ��� �������
    S_amount=[0];              %������ ����� ���������� � ������� - ��������� ��� �������
    dn=[];                     %������ �������� ����� �������� ������ � ������� - ��������� ��� �������
    sn=[];                     %������ �������� ����� ���������� ������ � ������� - ��������� ��� �������
    p_current=[0];             %������ ������� ������������� ������� - ��������� ��� �������
    
    
    U_condition(1,:)=[U];      %������ ��������� ��������� - ��������� ��� ������������
     
    i=1;                       %���������� ����������� ������ ������� ������
    
    disp('������ ������ �������');
    disp('����������� ������ � �������');
    while i<=n
    %%%%%%%����������� ���������� �������: ����������� ����� ������(�(i)) ���
    %%%%%%%���������� ������� (S_MIN)
        %
        %
        % ���������� ������������� �������� ����� ���� ��������������� ��������
        S_MIN = max([A,S])+1;

        % ���� �����-�� �� ��������� ������...
        if ~isempty(U(U>0))
           S_MIN = min(U(U>0));
        end

        %��������� S_MIN � ������� ����������� ����� ������
        
        
        if S_MIN < A(i)  %��������� ������� - ���������� ��������� ������           
            %��������� �������� �������
            Int(end+1)=S_MIN;
            T(end+1)=T(end)+S_MIN;
            
            %������� ������� ��������� ��������� ������
            A(i)=A(i)-S_MIN;
            
            %���� ���������� d
            for k = 1:1:length(Q_current)
                d(Q_current(k))=d(Q_current(k))+S_MIN;
            end
            
            %����� ������ ����������, �� ������� ���������� ������
            j = find(U==min(U(U>0)));
            
            %��������� ����������
            U_priority(j(1))=0;
            
            %��������� ������� �� ���� �����������
            for k = 1:1:length(U)
                 if U(k)>0 & (length(Int)>1)
                     U(k)=U(k)-S_MIN;
                     %���� ���������� p
                     p(k)=p(k)+S_MIN;
                 end
            end
            %disp(sprintf('������ ��������� �� ���������� %g', j(1)));
            
            %��������� ����� ���������� � ������� - ����� �����������:
            S_amount(end+1) = S_amount(end)-1;
            
            %�������� �������
            %���� ������� �� ����� - ���������� ������ �� ��������������
            %����������
            if ~isempty(Q)
                U(j(1))=Q(1);
                
                U_priority(j(1))=Q_priority(1);
                %disp(sprintf('������ �� ������� ���������� �� ���������� %g',j(1)));
                
                
                %������� �������
                Q = Q(2:length(Q));
                Q_priority= Q_priority(2:length(Q_priority));
                Q_current = Q_current(2:length(Q_current));
               
                [Q, Q_priority, Q_current] = sortQueue(Q, Q_priority, Q_current);                
                
                %��������� ����� ���������� � ������� - ����� �����������
                Q_amount(end+1) = Q_amount(end)-1;
                
            else
                %����� ���������� � ������� �� ��������:
                Q_amount(end+1) = Q_amount(end);
            end
           
            %������� �������� ������������ ������������� �������
            p_current(end+1) = sum(p/T(end))/length(p);
            
            
            %������������ ��������� �������
            U_condition(end+1,:)=U_priority;

        else  %��������� ������� - ����������� ����� ������
            
            %��������� ���������� d
            for k = 1:1:length(Q_current)
                d(Q_current(k))=d(Q_current(k))+A(i);
            end

            %��������� ������� �� ���� �����������
            for k = 1:1:length(U)
                 if U(k)>0 
                     U(k)=U(k)-A(i);
                     
                     %���� ���������� p
                     p(k)=p(k)+A(i);
                 end
            end                              
            %disp('��� ���������� ����������')
            if length(Q) < queue_max %�������� �������

                %���������� ������ � �������(���������� � ������)
                Q=[S(i),Q];
                Q_current=[i,Q_current];
                Q_priority=[Pr(i),Q_priority];
                [Q, Q_priority, Q_current] = sortQueue(Q, Q_priority, Q_current);                
                %disp(sprintf('������ c ����� ������ ����������� ���������� � �������. �������� ���� � �������: %g', queue_max-length(Q)))


                %���������� ������ ������ �� ����������
                %U(k(1))=S(i);
                %U_priority(k(1))=Pr(i);

                %���� ���������� d - ���������� ������ �������� � ������
                d(i)=0;

                %��������� ����� ���������� � ������� - ����� �������������:
                S_amount(end+1) = S_amount(end)+1;

                %��������� ����� ���������� � ������� - ����� �������������:
                Q_amount(end+1) = Q_amount(end)+1;
            else
                %disp('������� �����������. ������ ����� ���������� � ������');


                %���������� ������ ������ �� ����������

                %U(k(1))=S(i);
                %U_priority(k(1))=Pr(i);

                %���� ���������� fail - ���������� �������
                fail=fail+1;

                %���� ���������� d - ���������� ������ �������� � ������
                d(i)=0;

                %����� ���������� � ������� �� ��������:
                S_amount(end+1) = S_amount(end);

                %����� ���������� � ������� �� ��������:
                Q_amount(end+1) = Q_amount(end);

            end%�������� �������

            %%�������� ��������� ���������
            if ~all(U) %���� ���� ���� ���� 0 � ������� U - ��������� ��������
                
                %����� ���������� ����������
                k = find(U==min(U));
                U(k(1))=Q(1);
                U_priority(k(1))=Q_priority(1);
                
                Q = Q(2:length(Q));
                Q_current = Q_current(2:length(Q_current));
                Q_priority= Q_priority(2:length(Q_priority));

                [Q, Q_priority, Q_current] = sortQueue(Q, Q_priority, Q_current);
                
                %disp(sprintf('���� ��������� ����������! ������ ���������� �� ���������� %g.', k(1)));

                %���� ���������� d - ���������� ������ �������� � ������
                d(i)=0;
                
                %��������� ����� ���������� � ������� - ����� �������������:
                S_amount(end) = S_amount(end);
                
                %����� ���������� � ������� �� ��������:
                Q_amount(end) = Q_amount(end) - 1;
                
                %������� � ��������� ������
                %i=i+1;
                
            end
            
            %������� � ��������� ������
            i=i+1;                                   
        
            %������������ ��������� �������
            
            U_condition(end+1,:)=U_priority;
            
            %������� �������� ������������ ������������� �������
            p_current(end+1) = sum(p/T(end))/length(p);
            
            %��������� ���������� �������
            T(end+1)=T(end)+A(i-1);
            Int(end+1)=A(i-1);


        end %�������
    end% ����� �����
    disp('��������� ���������� ������� - ���������� ����������� ������ � �������');
    
    %��������� ���������� ������ � �������:
    disp('��������� ���������� ������ � �������:');

    while max(U)>0 %���� ���� ��������� ����������
        
        %����� ������������ ������� ����������
        S_MIN = min(U(U>0));
        
        %��������� ���������� �������
        Int(length(Int)+1)=S_MIN;
        T(length(T)+1)=T(length(T))+S_MIN;
        
        %��������� ���������� d
        for k = 1:1:length(Q_current)
            d(Q_current(k))=d(Q_current(k))+S_MIN;
        end
        
        %����� ������ ����������, �� ������� ���������� ������
        j = find(U==min(U(U>0)));
            
        %��������� ����������
        U_priority(j(1))=0;

        %��������� ������� �� ���� �����������
        for k = 1:1:length(U)
                 if U(k)>0 & (length(Int)>1)
                     U(k)=U(k)-Int(length(Int));
                     %���� ���������� p
                     p(k)=p(k)+Int(length(Int));
                 end
        end
        
        %disp(sprintf('������ ��������� �� ���������� %g', j(1)));
        
        %��������� ����� ���������� � ������� - ����� �����������:
        S_amount(end+1) = S_amount(end)-1;

        %�������� �������
        %���� ������� �� ����� - ���������� ������ �� ��������������
        %����������
        if ~isempty(Q)
            U(j(1))=Q(1);
                
            U_priority(j(1))=Q_priority(1);
            
            %disp(sprintf('������ �� ������� ���������� �� ���������� %g',j(1)));
                
            %������� �������
            Q = Q(2:length(Q));
            Q_current = Q_current(2:length(Q_current));
            Q_priority= Q_priority(2:length(Q_priority));
            
            [Q, Q_priority, Q_current] = sortQueue(Q, Q_priority, Q_current);
            
            %��������� ����� ���������� � ������� - ����� �����������
            Q_amount(end+1) = Q_amount(end)-1;
            
        else
            
            %����� ���������� � ������� �� ��������:
            Q_amount(end+1) = Q_amount(end);
            
        end
        
        %������������ ��������� �������
        U_condition(end+1,:)=U_priority;
        
        
        %������� �������� ������������ ������������� �������
        p_current(end+1) = sum(p/T(end))/length(p);

    end
    disp('���������� ������ �������');
    %U_condition
    disp('=======================================');
    disp('��������� �����������');
    disp('=======================================');
    
    
    up=p/(T(end));                                                   %������������� ��������� ���������
    factor_p = sum(up)/length(up);                                   %����������� ������������� �������
    factor_Tq = sum(d)/(length(A)-fail);                             %������� ����� �������� ����� � �������
    factor_Ts = factor_Tq + mean(S);                                 %������� ����� ���������� ����� � �������
    factor_Nq = factor_Tq/mean(A);                 %������� �� ������� ����� ���������� � �������
    factor_Ns = factor_Ts/mean(A);  %������� �� ������� ����� ���������� � �������
    factor_Ca = (length(A)-fail)/T(end);                             %���������� ���������� ����������� �������
    factor_Cr = (length(A)-fail)/length(A);                          %������������� ���������� ����������� �������        
    
    disp(sprintf('����� ����� �������������: � = %g ������',T(end)));
    
    disp(sprintf('����������� �������: %g',factor_p));
    disp(sprintf('������� ����� �������� ����� � �������: %g',factor_Tq));
    disp(sprintf('������� ����� ���������� ����� � �������: %g',factor_Ts));
    disp(sprintf('������� �� ������� ����� ���������� � �������: %g',factor_Nq));
    disp(sprintf('������� �� ������� ����� ���������� � �������: %g',factor_Ns));
    disp(sprintf('���������� ���������� ����������� �������: %g',factor_Ca));
    disp(sprintf('������������� ���������� ����������� �������: %g',factor_Cr));
    
    disp(sprintf('�������������� �������� �: %g',(sum(A)/length(A))));
    disp(sprintf('�������������� �������� S: %g',(sum(S)/length(S))));
   
    %�������
    
    %����� ���������� � �������   
    Qn=[];    
%     for i=1:1:length(T)
%         Qn(i)=sum(Q_amount(1:i))/i;
%     end
            
    %����� ���������� � �������   
    Sn=[];
%     for i=1:1:length(T)
%        Sn(i)=sum(S_amount(1:i))/i;
%     end
            
    %������� ����� �������� ������ � �������
    for i=1:1:n
        dn(i)=sum(d(1:i))/i;
    end   
    
    if(round(factor_Ns - factor_Nq) > device_number)
        while(device_number ~= ceil(factor_Ns - factor_Nq))
            factor_Ns = factor_Ns - 0.1;
        end
    end    
    
    %������� ����� ���������� ������ � �������
    for i=1:1:n
       sn(i)=dn(i)+sum(S(1:i))/i;
    end            
    
    global g_Qn g_T g_Sn g_dn g_n g_sn g_p_current visualize;
    g_Sn = S_amount;   
    g_Qn = Q_amount;
    g_T = T;    
    g_dn = dn;
    g_n = n;
    g_sn = sn;
    g_p_current = p_current;
    visualize = true;        
end   