function [statdist, statpar] = distrstat(distr, dpar)
% 
% [statdist, statpar] = distrstat(distr, dpar)
%
% DISTRSTAT a table-lookup function. For a given handle to an
% external random number generator returns a handle to a generator
% from the stationary distribution:
%
%         G(t) = 1/mu * int_0^t (1-F(s)) ds
% 
% Parameters to both distributions are given in cell-arrays.
% 
% Inputs:
%      distr - pointer to the external function generating random
%        numbers from the desired distribution:
%                @rand: uniform in (0,1)
%                @simexp: Exp(lambda)
%                @simparetonrm: Pareto(alpha, gamma) (see function
%                                                     SIMPARETONRM) 
%                @randn: standard normal
%       dpar - a cell array of the distribution parameters 
%
% Outputs:
%      statdist - the stationary distribution
%      statpar - a cell array with the parameters of the stationary
%         distribution 
%
% See also DISTRMU.

% Author: R.Gaigalas
% v1.0 06-Oct-05

  switch func2str(distr)
%  switch distr
   case 'ones' % degenerate=1 wp1 - counting process
      statdist = @ones;
      statpar = {};
      mu = 1;
        
   case 'rand' % uniform (0,1)
      % G(x)=2*x-x^2, 0<=x<=1
      statdist = @simlinear;
      statpar = {};
      
   case 'simexp' % Exp(lambda)
      statdist =  @simexp;
      statpar = dpar;

   case 'simpareto' % Pareto(alpha)
      statdist = @simpareto;
      statpar = {dpar{1}-1, dpar{2}};      
      
   case 'simparetonrm' % Normalized Pareto(alpha, gamma)
      statdist = @simparetonrm;
      statpar = {dpar{1}-1, dpar{2}};

    otherwise
      error('Bad parameter <distr>');
      return;
 
  end  
