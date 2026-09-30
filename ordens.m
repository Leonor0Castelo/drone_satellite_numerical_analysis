function [res] = ordens(h1,h2,f,t0,T,u0)
%h1 e h2 são os valores de passo a testar; assume-se length(h1)=length(h2)
%f,t0,T,u0 são os parâmetros do PVI 

m=length(h1);
res=zeros(3,m); %inicialização do resultado
yreal=ode45(f,[t0 T],u0,odeset('RelTol',1e-12,'AbsTol',1e-14)); %sol exata do PVI

for i=1:m

    %calcular erros para h1
    N1=round((T-t0)/h1(i));
    [t1,y11]=eulerexp(t0,T,f,u0,N1);
    [~,y12]=heun(t0,T,f,u0,N1);
    [~,y13]=RK4(t0,T,f,u0,N1);
    yref1=deval(yreal,t1); %calcula yreal nos pontos aproximados
    E11=max(vecnorm(y11-yref1));
    E12=max(vecnorm(y12-yref1));
    E13=max(vecnorm(y13-yref1));

    %calcular erros para h2
    N2=round((T-t0)/h2(i));
    [t2,y21]=eulerexp(t0,T,f,u0,N2);
    [~,y22]=heun(t0,T,f,u0,N2);
    [~,y23]=RK4(t0,T,f,u0,N2);
    yref2=deval(yreal,t2);
    E21=max(vecnorm(y21-yref2));
    E22=max(vecnorm(y22-yref2));
    E23=max(vecnorm(y23-yref2));

    %calcular resultado 
    res(1,i)=log(E11/E21)/log(h1(i)/h2(i));
    res(2,i)=log(E12/E22)/log(h1(i)/h2(i));
    res(3,i)=log(E13/E23)/log(h1(i)/h2(i));

end
end