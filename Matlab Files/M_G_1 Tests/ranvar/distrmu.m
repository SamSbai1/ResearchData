function [mu] = distrmu(distr, dpar)
 
% DISTRMU a table-lookup function. For a given handle to an external
% random number generator extracts the expected value from its
% parameter list.  
%
% [mu] = distrmu(distr, dpar)
%
% Inputs:
%      distr - pointer to an external function generating random
%        numbers from the desired distribution:
%                @rand: uniform in (0,1)
%                @simexp: Exp(lambda)
%                @simparetonrm: Pareto(alpha, gamma) (see SIMPARETONRM) 
%                @randn: standard normal
%       dpar - a cell array of the distribution parameters 
%
% Outputs:
%      mu - the expected value
%
% See also DISTRSTAT.

% Author: R.Gaigalas
% v1.0 06-Oct-05


  switch func2str(distr)
%  switch distr
   case 'ones' % degenerate=1 wp1 - counting process
      mu = 1;
        
   case 'rand' % uniform (0,1)
      mu = 0.5;
      
   case 'simexp' % Exp(lambda)
      mu = 1/dpar{1};
      
   case 'simparetonrm' % Pareto(alpha, gamma)
      mu = 1/(dpar{2}*(dpar{1}-1)); 

      
    otherwise
      error('Bad parameter <distr>');
      return;
 
  end  
