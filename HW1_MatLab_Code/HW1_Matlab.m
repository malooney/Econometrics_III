

tic

i=1;
n=20;
rep=1e2;
temp= zeros([rep 3]);

data= xlsread('data.xlsx');
x1=data(:,2);
x2=data(:,3);

for i= 1:rep
    
    %x1= 100+ 7* randn(n, 1);
    %x2= 1000+ 10* randn(n, 1);
    %e= 0+ 5*randn(n, 1);
    e= sqrt(exp(-2+ 0.25*x1)).* randn(n,1);

    y= 10+ 1* x1+ 1* x2 +e;

    X=[ones(n, 1) x1 x2];

    b_ols= (X'*X) \ (X'*y);

    temp(i,1:3)= b_ols;
 
end

mu_betas= mean(temp);
mu_betas= mu_betas'

ehat= y-X*mu_betas;

sigma2= (ehat'*ehat)/(n-3);

covb= sigma2.* inv(X'*X);

se_betas= sqrt(diag(covb));

t_val= mu_betas ./ se_betas







toc