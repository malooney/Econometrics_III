% Question 1.a
 
% Import the design matrix
 
clc
clear
%options = optimoptions('fminunc')

data= xlsread('data.xlsx');
X1=data(:,2);
X2=data(:,3);

 
% Assign table values to vectors
 
% C = A(:,1);
% X1 = A(:,2);
% X2 = A(:,3);
% n = size(X1, 1);
%  
% save data
%  
% % Question 1.a)
%  
%  
% load data
%  
X = [ones(20,1) X1 X2]; 
 
% Generate 100 samples of y each of 20
 
m=100;
n=20;
C=ones(20,1);
 
 
X1 = repmat(X1, 1, m); % 1 is for asking Matlab not to repeat rows
X2 = repmat(X2, 1, m);
 
e = sqrt(exp(-2 + 0.25* X1)).*randn(n,m);
y = 10 + X1 + X2 + e;
 
 
for i=1:m 
   
    X = [ones(20,1) X1(:,i) X2(:,i)];    
    betaols(:,i) = inv(X'*X)*X'*y(:,i);
    ehat = y(:,i) - X*betaols(:,i);
 
end
 
b=mean(betaols,2)
 
newehat = mean(ehat,2);
 
k=3
sigma2 = (newehat'*newehat)/n-k;
covb = sigma2*inv(X'*X);
 
seb = sqrt(diag(covb));
t = b./seb;
 




% Question 1.c
 
 
for i=1:m 
   
    ehat = y(:,i) - X*betaols(:,i);
    ehat_sq = ehat.*ehat;
     
    % We can approximate ehat_sq to sigma_sq. Thus, sigma_sq=ehat.*ehat
    
    lnsigma_sq(:,i) = log(ehat_sq);
    
    Z = [C X1(:,i)]; 
    
    alpha(:,i) = inv(Z'*Z)*Z'*lnsigma_sq(:,i);
    
 
end
 
alpha_hat=mean(alpha,2)
 
 
 
for i=1:n
    for j=1:n
        if i==j
            omega(i,j)=exp(alpha_hat(1) + alpha_hat(2)* X1(i));
        else
            omega(i,j)=0;
        end
    end
end
 
for i=1:m 
    
    X = [C X1(:,i) X2(:,i)];
    
    betagls(:,i) = inv(X'*inv(omega)*X)*X'*inv(omega)*y(:,i);
 
    ehat_gls = y(:,i) - X*betagls(:,i);
end
 
b_gls=mean(betagls,2)
 
newehat_gls = mean(ehat_gls,2);
 
 
sigma2_gls = (newehat_gls'*newehat_gls)/n-k;
covb_gls = sigma2_gls*inv(X'*inv(omega)*X);
 
seb_gls = sqrt(diag(covb_gls));
t = b_gls./seb_gls;




 
% Question 1.c2
 
%This is for 1 sample. There's no need of computing omega for 100 samples
%as you'll get the same becuase rho and sigmasq_v don't change. 
 
 
for i=1:n
    for j=1:n
        if i==j
            omega(i,j)=exp(-2 + 0.25* X1(i));
        else
            omega(i,j)=0;
        end
    end
end
 
for i=1:m 
    
    X = [C X1(:,i) X2(:,i)];
    
    betagls(:,i) = inv(X'*inv(omega)*X)*X'*inv(omega)*y(:,i);
 
    ehat_gls = y - X*betagls(:,i);
end
 
b_gls=mean(betagls,2)
 
newehat_gls = mean(ehat_gls,2);
 
 
sigma2_gls = (newehat_gls'*newehat_gls)/n-k;
covb_gls = sigma2_gls*inv(X'*inv(omega)*X);
 
seb_gls = sqrt(diag(covb_gls));
t = b_gls./seb_gls;
 