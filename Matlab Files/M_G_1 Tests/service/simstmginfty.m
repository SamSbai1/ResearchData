function [jmptimes, syssize] = simstmginfty(maxtime, lambda, servdist, ...
                                            servpar, b_verb) 

% SIMSTMGINFTY generate the system size process in a stationary
% M/G/infinity queueing system. Arrivals are a homogeneous Poisson
% process of intensity lambda. Distribution of service times is
% arbitrary. It is passed into the function as a MATLAB function
% handle to an external random number generator together
% with a cell-array containing distribution parameters.
% 
% [jmptimes, syssize] = simstmginfty(maxtime, lambda, servdist,
% servpar, b_verb) 
%
% Example:
%   [jmptimes, syssize] = simstmginfty(5, 2, @randn, {1, 0.5}, 1);  
% generates the process on the interval [0, 5) with arrival
% intensity lambda and normaly distributed service times, mu=1, 
% sigma=0.5. 
%
% Inputs: 
%         maxtime - simulation interval
%         lambda - arrival intensity 
%         servdistr - distribution of the service times: a handle to
%           the external function generating random numbers from the
%           desired distribution:
%                @rand: uniform in (0,1)
%                @simexp: Exp(lambda)
%                @simparetonrm: Pareto(alpha, gamma) (see SIMPARETONRM)
%                @randn: standard normal
%         servpar - a cell array of parameters to the distribution
%           of the service times
%          
%
% Outputs: jmptimes - times of state changes in the system
%	   syssize - number of customers in system
% 
% See SIMGEOD1, SIMMM1, SIMMD1, SIMMG1, SIMMGINFTY.

% Authors: R.Gaigalas, I.Kaj
% v1.0 06-Oct-05 Modified simmginfty to generate a stationary system

  % default parameter values
  if (nargin==0)
    maxtime = 1;
    lambda = 5; 

    alpha = 1.4;
    servmu = 1;
    servdist = @simparetonrm;
    servpar = {alpha, 1/(servmu*(alpha-1))};
    
    b_verb = 1;
  end

  if (b_verb==1)
    fprintf('##Generating an M\\G\\infinity queue\n');
    fprintf('  Time window: %.2f\n', maxtime);    
    fprintf('  Arrival intensity: %.2f\n', lambda);
    fprintf('  Service distribution: %s\n', func2str(servdist));
    fprintf('    distr. params: %.2f\n', servpar{:});
    fprintf('\n');
  end

  
  % extract the expected value of the service times
  servmu = distrmu(servdist, servpar);

  % a stationary system is assumed to be working from the time
  % "-infinity": at time zero there is a Poisson number of
  % customers in the system with stationary service times
  nstart = poissrnd(lambda*servmu); % a Poisson r.v.
  if (nstart>0)
    % a handle to the stationary distribution
    [statdist, statpar] = distrstat(servdist, servpar);
    % parameters for the random number generator
    rndpar1 = {nstart, 1, statpar{:}};
    % stationary service times
    stattimes = feval(statdist, rndpar1{:});
    % the customers who arrived before t=0 have arrival time zero  
    arrtimes = zeros(size(stattimes));
  else
    stattimes = [];
    arrtimes = [];
  end

  if b_verb % print info
    fprintf(1, '##Customers at time zero: %i\n', nstart);
  end  

  % generate Poisson arrivals for the new customers
%  arrtimes = [arrtimes; genpoispp(maxtime, lambda)];

  % generate Poisson arrivals for the new customers
  % the number of points is Poisson-distributed
  npoints = poissrnd(lambda*maxtime);

  % conditioned that number of points is N,
  % the points are uniformly distributed
  if (npoints>0)
    arrtimes = [arrtimes; sort(rand(npoints, 1)*maxtime)];
  end
    
  % total number of customers
  ntotal = length(arrtimes);

  
  % parameters for the random number generator
  rndpar2 = {ntotal-nstart, 1, servpar{:}};
  % generate service times for the new customers
  servtimes = [stattimes; feval(servdist, rndpar2{:})];
  
  % departure times
  deptimes = arrtimes+servtimes;
  
  % sort all the arrivals and departures together with the arrival
  % rate process
  arrate = [arrtimes ones(ntotal, 1); deptimes -ones(ntotal, 1)];
  arrate = sortrows(arrate, 1);
  jmptimes = arrate(:, 1);
  syssize = cumsum(arrate(:, 2));
  
  % cut the counting process not to exceed the time window 
  % and delete the zero times in the beginning from the "negative"
  % arrivals, leave only one 
  ci = find((jmptimes>0) & (jmptimes<=maxtime));
  if (~isempty(ci))
    fc = max(ci(1)-1, 1);
    lc = ci(end);
    jmptimes = jmptimes(fc:lc);
    syssize = syssize(fc:lc);
    % set the last value to maxtime  
    jmptimes = [jmptimes; maxtime];
    syssize = [syssize; syssize(end)];
  end

  if b_verb % print info
    fprintf(1, '##Events generated: %i\n', size(jmptimes, 1));
    fprintf(1, '##Expected number of events lambda*(1+1/mu)*T: %.2f\n', ...
	    lambda*(1+1/servmu)*maxtime);
  end  

