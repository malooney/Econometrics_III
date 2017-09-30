
clc
clear
%options = optimoptions('fminunc')

data= xlsread('data.xlsx');
x1=data(:,2);
x2=data(:,3);

m=100;
n=size(x1,1);
beta0=[4; 5; 3; 10; 0];
i=1;
betamle=[];

tic
while i <= m
    
e= sqrt(exp(-2+ 0.25*x1)).* randn(n,1);

y= 10+ 1* x1+ 1* x2+ e;
   
lnl=@(beta)0.5*n*log(2*pi)+0.5*sum(beta(4)+beta(5)*x1)...
    +0.5*sum(((y-beta(1)-beta(2)*x1-beta(3)*x2).^2)./(exp(beta(4)+beta(5)*x1)));

options= optimoptions('fminunc', 'Algorithm','quasi-newton',...
    'Display','notify-detailed', 'MaxIterations',1500,...
    'MaxFunctionEvaluations',2000);

betamle(:, i)= fminunc(lnl, beta0, options);

Betamle=[betamle, betamle(:, i)];

i=i+1;

end
toc

BetaMLE = Betamle(:, 1:m);
betahat=mean(BetaMLE');
betastd=std(BetaMLE);
%hist(BetaMLE(2,:))

betahat




