%Queue sorting by priority
function [Q, Q_priority, Q_current] = sortQueue(Q, Q_priority, Q_current)
    for j=1:(length(Q_priority)-2)
        for i=1:(length(Q_priority)-1)
            if Q_priority(i) > Q_priority(i+1)
                buf = Q_priority(i);
                Q_priority(i) = Q_priority(i+1);
                Q_priority(i+1) = buf;

                buf_q = Q(i);
                Q(i) = Q(i+1);
                Q(i+1) = buf_q;

                buf_q_c = Q_current(i);
                Q_current(i) = Q_current(i+1);
                Q_current(i+1) = buf_q_c;
            end
        end
    end       
end