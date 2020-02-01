function [sample] = simexp(M, N, lambda)

% SIMEXP random numbers from exponential distribution
%   pdf f(x)=lambda exp(-lambda*x), x>0
%
% [sample] = simexp(M, N, lambda)
%
% Inputs: 
%        M - number of rows in the output matrix
%        N - number of columns in the output matrix
%         lambda - parameter of the distribution
%
% Outputs: 
%        sample - a matrix of random numbers
%
% See also SIMBINOM, SIMDISCR, SIMGEOM, SIMPARETO

% Authors: R.Gaigalas, I.Kaj
% v1.3 Created 04-Oct-02
%      Modified 02-Dec-05 to generate a matrix

  % generate a sample of U(0, 1) and apply the inverse cgf
  sample = -log(rand(M, N))./lambda;
