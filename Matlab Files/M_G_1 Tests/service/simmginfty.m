function [jumptimes, systsize] = simmginfty(tmax, lambda)
% SIMMGINFTY simulate a M/G/infinity queueing system. Arrivals are
% a homogeneous Poisson process of intensity lambda. Service times
% Pareto distributed (can be modified).  
% 
% [jumptimes, systsize] = simmginfty(tmax, lambda)
%
% Inputs: tmax - simulation interval
%         lambda - arrival intensity 
%
% Outputs: jumptimes - times of state changes in the system
%	   systsize - number of customers in system
%
% See SIMSTMGINFTY, SIMGEOD1, SIMMM1, SIMMD1, SIMMG1.

% Authors: R.Gaigalas, I.Kaj
% v2.0 Created 07-Oct-02
%      Modified 22-Nov-05: 
%       a much more optimal method to generate Poisson arrivals 

  % set default parameter values if ommited
  if (nargin==0)
    tmax=1500;
    lambda=1; 
  end

  % generate Poisson arrivals
  % the number of points is Poisson-distributed
  npoints = poissrnd(lambda*tmax);

  % conditioned that number of points is N,
  % the points are uniformly distributed
  if (npoints>0)
    arrt = sort(rand(npoints, 1)*tmax);
  else
    arrt = [];
  end

% uncomment if not available POISSONRND
% generate Poisson arrivals
% arrt=-log(rand)/lambda;      
% i=1;                  
%   while (min(arrt(i,:))<=tmax)
%     arrt = [arrt; arrt(i, :)-log(rand)/lambda];  
%     i=i+1;
%   end
% npoints=length(arrt);        % arrival times t_1,...,t_n         

%  servt=50.*rand(n,1);          % uniform service times s_1,...,s_k

  alpha = 1.5;                   % Pareto service times
  servt = rand^(-1/(alpha-1))-1; % stationary renewal process
  servt = [servt; rand(npoints-1,1).^(-1/alpha)-1];  
  servt = 10.*servt;             % arbitrary choice of mean

  dept = arrt+servt;            % departure times 

  % Output is system size process N. 
  B = [ones(npoints, 1) arrt; -ones(npoints, 1) dept]; 
  Bsort = sortrows(B, 2);                 % sort jumps in order
  jumps = Bsort(:, 1);
  jumptimes = [0; Bsort(:, 2)];
  systsize = [0; cumsum(jumps)];         % M/G/infinity system size
                                         % process 

  stairs(jumptimes, systsize);
  xmax = max(systsize)+5;
  axis([0 tmax 0 xmax]);
  grid

