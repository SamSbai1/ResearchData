function [sample] = simlinear(M, N)
%
% [sample] = simlinear(M, N)
%
% Generate a matrix of random numbers from the "linear"
% distribution with 
%
% pdf      f(x) = 2-2*x,  0<=x<=1,
%
%                 /0,       x<=0
% cdf      F(x) = |2*x-x^2, 0<=x<=1
%                 \1,       x>=1
%
% It is the stationary distribution for the uniform (0, 1)
% distribution:
%         F(x) = 1/mu * int_0^x (1-F_U(y)) dy
%
% Inputs:
%        M - number of rows in the output matrix
%        N - number of columns in the output matrix
%
% Outputs:
%        sample - MxN matrix of random numbers
%

% Authors: R.Gaigalas, I.Kaj
% v1.0 15-Nov-05

  sample = 1-(1-rand(M, N)).^0.5;
