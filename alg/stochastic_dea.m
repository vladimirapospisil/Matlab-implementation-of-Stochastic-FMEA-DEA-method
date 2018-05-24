function [ result ] = stochastic_dea( mu_OSD_in, sigma_OSD_in, beta_s_in, alpha_s_in, x0_in )

global mu_OSD sigma_OSD beta_s alpha_s
global K_s 
global size_x size_u size_v size_gamma0

% input variables
mu_OSD = mu_OSD_in;
sigma_OSD = sigma_OSD_in; 
beta_s = beta_s_in;
alpha_s = alpha_s_in;

% sizes
size_x = 5;
size_u = 1;
size_v = 3;
size_gamma0 = 1;

nmb_DMU = size(mu_OSD,1);

% fill K_s
K_s = zeros(nmb_DMU,1);
for i = 1:nmb_DMU
    K_s(i) = norminv(1-alpha_s(i));
end    

% lower and upper bound
lb =  zeros(size_x,1);
ub =  inf*ones(size_x,1);
ub(end) = 1;

% run algorithm
global id0

result_mu = zeros(size(mu_OSD,1),1);
result_sigma = zeros(size(mu_OSD,1),1);
for id0 = 1:size(mu_OSD,1)
    options = optimoptions(@fmincon,'Algorithm','sqp','Display','none');
    %options = optimoptions('fmincon','Algorithm','interior-point');
    [x_sol,fval] = fmincon(@objfun,x0_in,[],[],[],[],lb,ub,@confuneq2,options);
    %[x_sol,fval] = fmincon(@objfun,x0_in,[],[],[],[],lb,ub,@confuneq,options);

    u = x_sol(1);
    v = x_sol(2:4);
    result_mu(id0) = get_mu(mu_OSD(id0,:), u, v);
    result_sigma(id0) = get_sigma( sigma_OSD(id0,:), mu_OSD(id0,:), u, v );

%    (beta_s(id0) - result_mu(id0))/result_sigma(id0)
%    mu_OSD(id0,1)*mu_OSD(id0,2)*mu_OSD(id0,3)/dot(mu_OSD(id0,:),v)
end

% store output values
result.mu = result_mu;
result.sigma = result_sigma;

end

function [c,ceq] = confuneq2(x)
% x = [ u, v, nu, gamma0]

% global variables
global mu_OSD sigma_OSD beta_s
global K_s
global id0

% Nonlinear inequality constraints
u = x(1);
v = x(2:4);
gamma0 = x(end);

c = zeros(1 + size(mu_OSD,1),1);

sigma = get_sigma( sigma_OSD(id0,:), mu_OSD(id0,:), u, v );
mu = get_mu( mu_OSD(id0,:), u, v );
c(1) = norminv(gamma0)*sigma - beta_s(id0) + mu;

for j=1:size(mu_OSD,1)
   sigma = get_sigma( sigma_OSD(j,:), mu_OSD(j,:), u, v );
   mu = get_mu( mu_OSD(j,:), u, v );
   c(j+1) = K_s(j)*sigma - beta_s(j) + mu; 
end


% Nonlinear equality constraints
ceq = [];

end


function f = objfun(x)
 %x = [ u, v, nu, gamma0]

f = -x(end); % = gamma0

end

function mu_out = get_mu( mu, u, v )

mu_out = (u*mu(1)*mu(2)*mu(3))/dot(v,mu);

end


function sigma_out = get_sigma( sigma, mu, u, v )
%GET_SIGMA Summary of this function goes here
%   Detailed explanation goes here

if false %dot(v,mu) == 0
    sigma_out = 0;
else
    sigma_out = 0;
    sigma_out = sigma_out + ((u*(v(2)*mu(2)^2*mu(3) + v(3)*mu(3)^2*mu(2)))/(dot(v,mu))^2)^2*sigma(1)^2;
    sigma_out = sigma_out + ((u*(v(1)*mu(1)^2*mu(3) + v(3)*mu(3)^2*mu(1)))/(dot(v,mu))^2)^2*sigma(2)^2;
    sigma_out = sigma_out + ((u*(v(1)*mu(1)^2*mu(2) + v(2)*mu(2)^2*mu(1)))/(dot(v,mu))^2)^2*sigma(3)^2;
    sigma_out = sqrt(sigma_out);
end

%keyboard

end


