

tic

i=1;
n=1e5;
rep=1e3;
temp= zeros([rep 3]);

for i= 1:rep
    
    x1= 100+ 7* randn(n, 1);
    x2= 1000+ 10* randn(n, 1);
    e= 0+ 5*randn(n, 1);

    y= 5+ 4* x1+ 0.7* x2 +e;

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