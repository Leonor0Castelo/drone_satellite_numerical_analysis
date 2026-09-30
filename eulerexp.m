function [t,y] = eulerexp(t0,T,f,u0,n)
%[t0,T] = intervalo a considerar
%f = função que caracteriza o PVI
%u0 = valor inicial
%n = nº de subintervalos

h=(T-t0)/n;
t=linspace(t0,T,n+1);  
y=zeros(length(u0),n+1); %resultado; cada coluna é uma iterada
y(:,1)=u0;
for i=2:n+1
    y(:,i)=y(:,i-1)+h*f(t(i-1),y(:,i-1));
end
end