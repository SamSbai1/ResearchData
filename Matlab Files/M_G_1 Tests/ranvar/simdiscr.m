function [sample] = simdiscr(npoints, pdf, val)
% SIMDISCR random numbers from a discrete random
% variable X which attains values x1,...,xn with probabilities
% p1,...,pn 
% [sample] = simdiscr(n_points, pdf [, val])
%
% Inputs: npoints - sample size
%         pdf - vector of probabilities (p1, ...,  pn). They should
%            sum up to 1.
%         val - optional, vector of values (x1, ... xn). Default is
%            assumed (1, ..., n).
%
% Outputs: sample - vector of random numbers
%
% See also SIMBINOM, SIMEXP, SIMGEOM, SIMPARETO

% Authors: R.Gaigalas, I.Kaj
% v1.2 04-Oct-02

  % check arguments
  if (sum(pdf) ~= 1)
    error('Probabilities does not sum up to 1');
  end
  
  n = length(pdf);
  
  % if the last argument omitted
  % assign (1, ..., n) to the value vector
  if (nargin==2)
    val = [1:n];
  end
    
  cumprob = [0 cumsum(pdf)]; % the jump points of cdf
  
  runi = rand(1, npoints); % random uniform sample

  sample = zeros(1, npoints);
  for j=1:n
    % if the value of U(0,1) falls into the interval (p_j, p_j+1) 
    % assign the value xj to X 
    ind = find((runi>cumprob(j)) & (runi<=cumprob(j+1)));
    sample(ind) = val(j);
  end
