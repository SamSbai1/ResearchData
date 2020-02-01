function [tjump, systsize] = simmm1(n, lambda, mu)
% SIMMM1 simulate a M/M/1 queueing system. Poisson arrivals of
% intensity lambda. Poisson service times S of intensity mu.
% 
% [tjump, systsize] = simmm1(n, lambda, mu)
%
% Inputs: n - number of jumps
%         lambda - arrival intensity 
%         mu - intensity of the service times  
%
% Outputs: tjump - cumulative jump times
%          systsize - system size

% Authors: R.Gaigalas, I.Kaj
% v1.2 07-Oct-02

  % set default parameter values if ommited
  if (nargin==0)
    n=500;
    lambda=0.8;
    mu=1;
  end

  i=0;     %initial value, start on level i
  tjump(1)=0;  %start at time 0
  systsize(1)=i;  %at time 0: level i

  for k=2:n
     if i==0
       mutemp=0;
     else 
       mutemp=mu;
     end
      
     time=-log(rand)/(lambda+mutemp);   % Inter-step times:
                                        % Exp(lambda+mu)-distributed
     if rand<lambda/(lambda+mutemp)
       i=i+1;     %jump up: a customer arrives
     else
       i=i-1;     %jump down: a customer is departing
     end          %if

     systsize(k)=i;      %system size at time i
     tjump(k)=time;      
  end             %for i

  tjump=cumsum(tjump);    %cumulative jump times
  stairs(tjump,systsize);    


