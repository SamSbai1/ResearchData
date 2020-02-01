m=5000;
p=0.2;

N=zeros(1,m);
A=geornd(1-p,1,m);

for n=2:m
N(n)=N(n-1)+A(n)-(N(n-1)+A(n)>=1);
end

stairs((0:m-1),N);

%figure(2)
%stairs(cumsum(N));













