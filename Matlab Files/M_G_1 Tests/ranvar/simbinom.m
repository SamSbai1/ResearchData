function [sample] = simbinom(npoints, n, p)
% SIMBINOM random numbers from binomial distribution
%
% [sample] = simbinom(npoints, n, p)
%
% Inputs: npoints - sample size
%         n - parameter of the distribution, number of trials
%         p - parameter of the distribution, probability of success
%
% Outputs: sample - vector of random numbers
%
% See also SIMDISCR, SIMEXP, SIMGEOM, SIMPARETO

% Authors: R.Gaigalas, I.Kaj
% v1.2 04-Oct-02

  % generate n samples from Bernoulli and sum up
  sample = sum(rand(n, npoints)<p);  

