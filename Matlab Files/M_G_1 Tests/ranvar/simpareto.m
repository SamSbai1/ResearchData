function [sample] = simpareto(M, N, alpha)

% SIMPARETO random numbers from Pareto distribution:
%   pdf   f(x)=alpha/(1+x)^(1+alpha), x>0
%   cdf   F(x)=1-1/(1+x)^alpha, x>0
%   inverse cdf G(y)=(1-y)^(-1/alpha)-1, 0<y<1
%
% [sample] = simpareto(M, N, alpha)
%
% Inputs: 
%        M - number of rows in the output matrix
%        N - number of columns in the output matrix
%        alpha - parameter of the distribution. Should be
%           positive. 
%
% Outputs:
%        sample - a matrix of random numbers
%
% See also SIMBINOM, SIMDISCR, SIMEXP, SIMGEOM

% Authors: R.Gaigalas, I.Kaj
% v1.3 04-Oct-02
%      Modified 02-Dec-05 to generate a matrix

  % check arguments
  if (alpha <= 0)
    error('alpha negative or zero');
  end

  % generate a uniform sample and apply the inverse cdf
  sample = (1-rand(M, N)).^(-1/alpha)-1;

