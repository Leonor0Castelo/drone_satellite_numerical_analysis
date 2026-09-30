% dados
t = [0; 1; 2; 3; 4; 5; 6; 7; 8; 9; 10];
x = [3.6274; 4.7839; 12.2002; 15.6936; 21.4540; 23.2871; 28.9799; 33.1312; 39.0343; 39.6250; 40.1570];
y = [1.454; 1.858; 3.872; 7.444; 10.397; 14.350; 15.266; 18.313; 19.616; 20.102; 24.915];
z = [11.907; 14.9641; 14.1788; 16.9027; 19.2841; 16.8510; 27.8011; 28.4035; 30.1432; 39.9430; 41.9723];

% interpolações das funções formadas com os pontos dos dados
f_x = @(tq) interp1(t, x, tq, 'linear', 'extrap');
f_y = @(tq) interp1(t, y, tq, 'linear', 'extrap');
f_z = @(tq) interp1(t, z, tq, 'linear', 'extrap');

N = length(t);

epsilon=1; % dado no enunciado

% definição das funções g e g_epsilon
g = @(x) (abs(x) < 1) .* (1/6)*(4 - 6*x.^2 + 3*abs(x).^3) + ...
         (abs(x) >= 1 & abs(x) < 2) .* (1/6)*(2 - abs(x)).^3;
g_eps=@(x) (1/epsilon)*g(x/epsilon);

% inicialização dos resultados
x_filtrado = zeros(N,1);
y_filtrado = zeros(N,1);
z_filtrado = zeros(N,1);


% cálculo dos somatórios (convolução discreta)
for i = 1:N
    soma_x = 0;
    soma_y = 0;
    soma_z = 0;
    w = zeros(N,1);

    for j = 1:N
    w(j) = g_eps(t(i) - t(j));
    soma_x = soma_x + x(j) * w(j); 
    soma_y = soma_y + y(j) * w(j);
    soma_z = soma_z + z(j) * w(j);

    end

    % normalização dos resultados
    soma_w = sum(w);
    x_filtrado(i) = soma_x / soma_w;
    y_filtrado(i) = soma_y / soma_w;
    z_filtrado(i) = soma_z / soma_w;

end

% criação da tabela com os resultados
tabela_res = table(t, x_filtrado, y_filtrado, z_filtrado);
disp(tabela_res);

% interpolações das funções formadas com os pontos filtrados
f_x_filtrado = @(tq) interp1(t, x_filtrado, tq, 'linear', 'extrap');
f_y_filtrado = @(tq) interp1(t, y_filtrado, tq, 'linear', 'extrap');
f_z_filtrado = @(tq) interp1(t, z_filtrado, tq, 'linear', 'extrap');


disp('Coordenadas aproximadas via convulação discreta f * g_epsilon:')
disp(table(t', x_filtrado', y_filtrado', z_filtrado', ...
    'VariableNames', {'t','x_filtrado','y_filtrado','z_filtrado'}))
figure('Position', [100, 100, 1200, 800]);

% reconstrução do movimento
subplot(3,1,1)
plot(t, x_filtrado, 'r*-', 'LineWidth', 1.5, 'MarkerSize', 8)
hold on;
% mostrar nós originais
plot(t, x, 'bo', 'MarkerSize', 6, 'MarkerFaceColor', 'b')
legend('x(t) filtrado', 'Nós originais', 'Location', 'best')
xlabel('t'); ylabel('x(t)'); grid on
title('Coordenada x(t) Filtrada')

subplot(3,1,2)
plot(t, y_filtrado, 'r*-', 'LineWidth', 1.5, 'MarkerSize', 8)
hold on;
plot(t, y, 'bo', 'MarkerSize', 6, 'MarkerFaceColor', 'b')
legend('y(t) filtrado', 'Nós originais', 'Location', 'best')
xlabel('t'); ylabel('y(t)'); grid on
title('Coordenada y(t) Filtrada')

subplot(3,1,3)
plot(t, z_filtrado, 'r*-', 'LineWidth', 1.5, 'MarkerSize', 8)
hold on;
plot(t, z, 'bo', 'MarkerSize', 6, 'MarkerFaceColor', 'b')
legend('z(t) filtrado', 'Nós originais', 'Location', 'best')
xlabel('t'); ylabel('z(t)'); grid on
title('Coordenada z(t) Filtrada')

sgtitle('Coordenadas Filtradas via Convolução f * g_{\epsilon}');


% formulação do gráfico
figure('Color','w');
hold on; grid on; axis equal;

% trajetória original (cinzento)
plot3(x, y, z, '-', 'Color', [0.7 0.7 0.7], 'LineWidth', 1.2, 'DisplayName','Trajetória original');

% nós filtrados (azul)
plot3(x_filtrado, y_filtrado, z_filtrado, 'bo', 'MarkerFaceColor','b', 'DisplayName','Nós filtrados');

% interpolação linear entre os nós filtrados
tq = linspace(min(t), max(t), 200);  % malha mais densa para suavizar a curva
x_interp = f_x_filtrado(tq);
y_interp = f_y_filtrado(tq);
z_interp = f_z_filtrado(tq);

plot3(x_interp, y_interp, z_interp, 'r-', 'LineWidth',1.5, 'DisplayName','Interpolação linear');

xlabel('x'); ylabel('y'); zlabel('z');
title('Trajetória 3D - Dados Filtrados e Interpolação Linear');
legend('Location','best');
view(45,30);
