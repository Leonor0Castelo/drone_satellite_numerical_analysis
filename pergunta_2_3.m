mu=0.012277471;
T=17.065216560158;
D1=@(u1,u2)sqrt(((u1+mu)^2+u2^2)^3);
D2=@(u1,u2)sqrt(((u1-1+mu)^2+u2^2)^3);
f=@(t,u)[u(3);
    u(4);
    u(1)+2*u(4)-(1-mu)*(u(1)+mu)/D1(u(1),u(2))-mu*(u(1)-1+mu)/D2(u(1),u(2));
    u(2)-2*u(3)-(1-mu)*u(2)/D1(u(1),u(2))-mu*u(2)/D2(u(1),u(2))];

%problema original
u0=[0.994;
    0;
    0;
    -2.001585106379];
[t01,d01]=eulerexp(0,T,f,u0,30000);
[t02,d02]=eulerexp(0,3*T,f,u0,100000);

%problemas perturbados
eps=[0.0005 0.0001 0.00001];
tiledlayout(length(eps),2, 'TileSpacing', 'compact', 'Padding', 'compact');

for i=1:length(eps)
    ui=[0.994+eps(i);
    0;
    0;
    -2.001585106379];
    [ti1,di1]=eulerexp(0,T,f,ui,30000);
    [ti2,di2]=eulerexp(0,3*T,f,ui,100000);

    nexttile
    hold on
    plot(t01,d01(1,:),t01,d01(2,:))
    plot(ti1,di1(1,:),ti1,di1(2,:))
    title("Original vs. \epsilon = " + num2str(eps(i)) + ", em [0,T]");
    hold off

    nexttile
    hold on
    plot(t02,d02(1,:),t02,d02(2,:))
    plot(ti2,di2(1,:),ti2,di2(2,:))
    title("Original vs. \epsilon = " + num2str(eps(i)) + ", em [0,3T]")
    hold off
    
end
legend("$x(t)$","$y(t)$","$\tilde{x}(t)$","$\tilde{y}(t)$",...
    "Interpreter","latex","Location","northeastoutside")