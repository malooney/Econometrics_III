
tic

clc;
clear;
load data;
X=[c x1 x2];
e=0+5*randn(n,1);
y=5+4*x1+0.7*x2+e;
b_ols = (X'*X) \ X'*y;

m=1e5;
x1=repmat(x1, 1, m);
x2=repmat(x2,1,m);
e=5*randn(n,m);
y=5+4*x1+0.7*x2+e;

for i=1:m
    X=[c x1(:,i) x2(:,i)];
    beta_ols(:,i)= inv(X'*X) *X'* y(:,i);
end

betas_mu= mean((beta_ols)')

toc