function [sample] = simgeom(npoints, p)
% SIMGEOM random numbers from geometric distribution
%  pdf p(k)=p(1-p)^k,   k=0,1,...
% 
% [sample] = simgeom(npoints, p)
%
% Inputs: npoints - sample size
%         p - parameter of the distribution
%
% Outputs: sample - vector of random numbers
%
% See also SIMBINOM, SIMDISCR, SIMEXP, SIMPARETO

% Authors: R.Gaigalas, I.Kaj
% v1.2 04-Oct-02

  % generate a sample of Exp(lambda) with lambda=-log(1-p)
  % and take the largest integer less than or equal to the result 
  sample = floor(log(rand(1, npoints))./log(1-p));
