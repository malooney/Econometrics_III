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
 

% Question 1.d
 
clear
 
 
A = xlsread('Copy of Design Matrix X.xlsx')
 
C = A(:,1);
X1 = A(:,2);
X2 = A(:,3);
n = size(X1, 1);
 
save data
 
load data
 
 
X = [C X1 X2]; 
Z = [C X1];
 
m=100;
 
theta0=[4; 5; 3; 10; 0]; % Guessing initial values of parameters; estimated solution of the minimization problem (o/p) will be in theta
i=1;
betamle=[];
 
 
tic
while i<=m
    
   e=sqrt(exp(-2+0.25*X1)).*randn(n,1);
   y = 10 + X1 + X2 + e;
 
    %% @ sign is to create a handle for a function, so that, later, you can call that handle instead of the function
lnl=@(theta)0.5*n*log(2*pi)+0.5*n*sum(theta(4)+theta(5)*X1)... % @ symbol creates a handle named lnl to the function 0.5*n*log(2*pi)+........./(exp(theta(4)+theta(5)*X1))). theta contains arguments or inputs to the function. three dots are for the line continuation
    +0.5*sum(((y-theta(1)-theta(2)*X1-theta(3)*X2).^2)./(exp(theta(4)+theta(5)*X1)));

options = optimoptions('fminunc','Algorithm','quasi-newton');
betamle(:,i)=fminunc(lnl,theta0,options);
Betamle=[betamle, betamle(:,i)];
i=i+1
end
 
BetaMLE=Betamle(:,1:m); % This is because at the end of the while loop, it creates a matrix of 5*(m+1), but we need only upto m
betahat=mean(BetaMLE'); % since the transpose of BetaMLE has taken here, we can get the mean as this. otherwise, it should be written as betahat=mean(BetaMLE,2)
bbb=mean(betamle'); % This way also, we can get the paramter matrix.
 
betastd=std(BetaMLE');
 
hist(BetaMLE(2,:)) % Draw the histogram of the BetaMLE matrix for the 2nd row by considering all columns
 
for i=1:n
    for j=1:n
        if i==j
            omega(i,j)=exp(-2 + 0.25* X1(i));
        else
            omega(i,j)=0;
        end
    end
end
 
% Obtaining the var-covariance matrix
 
covb_mle1=inv(X'*inv(omega)*X);
covb_mle2=2.*inv(Z'*Z);
m1=zeros(3,2);
m2=zeros(2,3);
covb_mle=[covb_mle1 m1; m2 covb_mle2];
 
 
toc

% Question 2.a
 
 
A = xlsread('Copy of Design Matrix X.xlsx')
 
C = A(:,1);
X1 = A(:,2);
X2 = A(:,3);
n = size(X1, 1);
 
save data
 
load data
 
X = [C X1 X2]; 
 
m=100;
 
X1 = repmat(X1, 1, m); 
X2 = repmat(X2, 1, m);
 
v = sqrt(6.4)*randn(n,m);
 
e=[];
 
for i=1:m
    for j=1:n
        if j==1
    e(j,i) = 5*randn(1,1);
        else
    e(j,i)=0.8.*e(j-1,i)+v(j,i);
        end
    end
end
 
 
y = 10 + X1 + X2 + e;
 
 
for i=1:m 
   
    X = [C X1(:,i) X2(:,i)]; 
    
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

% Question 2.c
 
%This is for 1 sample. There's no need of computing omega for 100 samples
%as you'll get the same becuase rho and sigmasq_v don't change. 
 
 
for i=1:m 
   
    ehat = y(:,i) - X*betaols(:,i);
    
    for j=1:n
        if j==1
    ehat_t_1(j) = 5*randn(1,1);
        else
    ehat_t_1(j)=ehat(j-1);
        end
    end
    
    Z= [C ehat_t_1']
   
    auto_beta(:,i) = inv(Z'*Z)*Z'*ehat;
    
end
 
auto_beta=mean(auto_beta,2)
 
rho_hat=auto_beta(2)
 
 
%sigmasq_v=6.4;
 
%sigmasq_et=xx
 
xx=(6.4^2)/(1-rho_hat^2);
 
k=1;
omega=[];
 
while k<=n
      for j=1:n
       p=abs(j-k); 
       omega(j,k)=xx*rho_hat^p;
      end
      k=k+1;
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
 
 
 
% Question 2.c2
 
%rho=0.8;
%sigmasq_v=6.4;
%sigmasq_et=xx
 
xx=(6.4^2)/(1-0.8^2);
 
k=1;
omega=[];
 
while k<=n
      for j=1:n
       p=abs(j-k); 
       omega(j,k)=xx*0.8^p;
      end
      k=k+1;
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
 
 








 
% Question 1.d
 
clear
 
 
A = xlsread('Copy of Design Matrix X.xlsx')
 
C = A(:,1);
X1 = A(:,2);
X2 = A(:,3);
n = size(X1, 1);
 
 
save data
 
load data
 
 
X = [C X1 X2]; 
Z = [C X1];
 
m=100;
 
theta0=[4; 5; 3; 10; 0]; % Guessing initial values of parameters; estimated solution of the minimization problem (o/p) will be in theta
i=1;
betamle=[];
 
 
 
tic
while i<=m
    
    v = sqrt(6.4)*randn(n,1);
 
    e=[];
 
    for j=1:n
        if j==1
    e(j) = 5*randn(1,1);
        else
    e(j)=0.8.*e(j-1)+v(j);
        end
    end
    
 
    
    
y = 10 + X1 + X2 + e';
 
   
    %% @ sign is to create a handle for a function, so that, later, you can call that handle instead of the function
lnl=@(theta)0.5*n*log(2*pi)+0.5*n*sum(theta(4)+theta(5)*X1)... % @ symbol creates a handle named lnl to the function 0.5*n*log(2*pi)+........./(exp(theta(4)+theta(5)*X1))). theta contains arguments or inputs to the function. three dots are for the line continuation
    +0.5*sum(((y-theta(1)-theta(2)*X1-theta(3)*X2).^2)./(exp(theta(4)+theta(5)*X1)));
options = optimoptions('fminunc','Algorithm','quasi-newton');

betamle(:,i)=fminunc(lnl,theta0,options);

Betamle=[betamle, betamle(:,i)];
 
i=i+1
end
 
BetaMLE=Betamle(:,1:m); % This is because at the end of the while loop, it creates a matrix of 5*(m+1), but we need only upto m
betahat=mean(BetaMLE'); % since the transpose of BetaMLE has taken here, we can get the mean as this. otherwise, it should be written as betahat=mean(BetaMLE,2)
bbb=mean(betamle'); % This way also, we can get the paramter matrix.
 
betastd=std(BetaMLE');
 
hist(BetaMLE(2,:)) % Draw the histogram of the BetaMLE matrix for the 2nd row by considering all columns
 
 
xx=(6.4^2)/(1-0.8^2);
 
 
n=20;
k=1;
omega=[];
 
while k<=n
      for j=1:n
       p=abs(j-k); 
       omega(j,k)=xx*0.8^p;
      end
      k=k+1;
end
 
 
covb_mle1=inv(X'*inv(omega)*X);
covb_mle2=2.*inv(Z'*Z);
m1=zeros(3,2);
m2=zeros(2,3);
covb_mle=[covb_mle1 m1; m2 covb_mle2];
 
toc


 



