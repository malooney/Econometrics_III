

tic
n=100000;
rep=1000;
i=1;
temp= zeros([rep 3]);

for i= 1:rep
    
e= 0+ 5*rand(n, 1);
x1= 100+ 7* rand(n, 1);
x2= 1000+ 10* rand(n, 1);

y= 5+ 4* x1+ 0.7* x2 +e;

X=[ones(n, 1) x1 x2];

b_ols= (X'*X) \ (X'*y);

temp(i,1:3)= b_ols;

end

mean(temp)
toc