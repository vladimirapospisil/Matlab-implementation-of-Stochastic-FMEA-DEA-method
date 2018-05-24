function [ DEA ] = deterministic_dea( values )

% dea
x = values; % input
y = values(:,1).*values(:,2).*values(:,3); % output

% solve optimisation problem
% max f'*x s.t Ax<=b, Aeq x = beq, lb <= x <= ub
% w = [v u]

%f = -[zeros(size(v));y];
%I = eye(length(v)/3);
%A = [-x', y'; -I I I zeros(size(I))];
%b = [0; zeros(size(I,1),1)];

%Aeq = [x;zeros(size(u))]';
%beq = 1;

%my_eps = 0;
%lb = my_eps*ones(length(v)+length(u),1);
%ub = Inf*ones(size(lb));
%[w,fval,exitflag,output] = linprog(f,A,b,Aeq,beq,lb,ub);

% vyries optimalizacny problem
% max f'*x s.t Ax<=b, Aeq x = beq, lb <= x <= ub

%v = ones(3); % x
%u = ones(1); % y

DEA = zeros(size(values,1),1);
for DMU_id = 1:size(values,1);
    x0 = values(DMU_id,:);
    y0 = y(DMU_id);

    f = [0 0 0 -y0];
    Aeq = [x0 0];
%    Aeq = [hodnoty zeros(size(hodnoty,1),1)];
    beq = ones(size(Aeq,1),1);
    
%    A = [-hodnoty(DMU_id,:) y(DMU_id); -1 1 1 0];
%    A = [-values y; 1 1 1 -1];
%    b = zeros(size(A,1),1);

    A = [-values y];
    b = zeros(size(A,1),1);
    
    my_eps = 0;
    lb = my_eps*ones(length(x0)+length(y0),1);
    ub = inf*ones(size(lb));
    options = optimoptions(@linprog,'Display','none');
    [w,fval,exitflag,output] = linprog(f,A,b,Aeq,beq,lb,ub,0.5*ones(size(lb)),options);

    if exitflag ~= 1
        disp('Problem in optimization')
        keyboard
    end
    v = w(1:3); 
    u = w(4);

    h0 = -fval;

    DEA(DMU_id) = dot(u,y0)/dot(x0,v);
end


end