function [sample] = simparetonrm(M, N, alpha, gamma)

% SIMPARETONRM Generate a matrix of random numbers from the
% normalized Pareto distribution with
%
% pdf      f(x) = alpha*gamma/(1+gamma*x)^(1+alpha),  x>0,
% cdf      F(x) = 1-(1+gamma*x)^(-alpha).
%
% The additional parameter gamma allows to control the expected
% value. For alpha>1 the expected value exists and is equal to
% 1/(gamma*(alpha-1)).
%
% [sample] = simparetonrm(M, N, alpha, gamma)
%
% Inputs:
%        M - number of rows in the output matrix
%        N - number of columns in the output matrix
%        alpha - tail parameter of the distribution
%        gamma - parameter of the distribution
%
% Outputs:
%        sample - MxN matrix of random numbers
%
% See also SIMBINOM, SIMDISCR, SIMGEOM, SIMEXP, SIMPARETO

% Authors: R.Gaigalas, I.Kaj
% v2.0 17-Oct-05

  sample = ((1-rand(M, N)).^(-1/alpha)-1)./gamma;
