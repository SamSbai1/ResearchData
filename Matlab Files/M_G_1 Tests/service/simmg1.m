function [jumptimes, systsize, systtime] = simmg1(tmax, lambda)
% SIMMG1 simulate a M/G/1 queueing system. Poisson arrivals 
% of intensity lambda, uniform service times.
% 
% [jumptimes, systsize, systtime] = simmd1(tmax, lambda)
%
% Inputs: tmax - simulation interval
%         lambda - arrival intensity 
%
% Outputs: jumptimes - time points of arrivals or departures
%          systsize - system size in M/G/1 queue
%	       systtime - system times


% Authors: R.Gaigalas, I.Kaj
% v1.2 07-Oct-02

% set default parameter values if ommited
if (nargin==0)
  tmax=1500;                  % simulation interval 
  lambda=0.99;                 % arrival intensity 
end

arrtime=-log(rand)/lambda;  % Poisson arrivals
i=1;                  
  while (min(arrtime(i,:))<=tmax)
    arrtime = [arrtime; arrtime(i, :)-log(rand)/lambda];  
    i=i+1;
  end
n=length(arrtime);           % arrival times t_1,...,t_n         

servtime=2.*rand(1,n);          % service times s_1,...,s_k
cumservtime=cumsum(servtime);

arrsubtr=arrtime-[0 cumservtime(:,1:n-1)]';           % t_k-(k-1)
arrmatrix=arrsubtr*ones(1,n);        
deptime=cumservtime+max(triu(arrmatrix));  % departure times 
                                        % u_k=k+max(t_1,..,t_k-k+1)   

% Output is system size process N and system waiting 
% times W.
B=[ones(n,1) arrtime ; -ones(n,1) deptime']; 
Bsort=sortrows(B,2);                 % sort jumps in order
jumps=Bsort(:,1);
jumptimes=[0;Bsort(:,2)];
systsize=[0;cumsum(jumps)];          % size of M/G/1 queue
systtime=deptime-arrtime';            % system times 

figure(1)
stairs(jumptimes,systsize);
xmax=max(systsize)+5;
axis([0 tmax 0 xmax]);
grid

figure(2)
hist(systtime,20);

