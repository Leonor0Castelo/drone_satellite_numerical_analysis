t = [0 3 7 11 14 18 22 25 30 36];
x = [0 12 28 45 62 78 88 95 110 125];
y = [0 7 18 25 22 15 8 3 7 12];
n = length(t);

% Calcular segundas derivadas
S_linha_linha_x = spline_segunda_derivada(t, x);
S_linha_linha_y = spline_segunda_derivada(t, y);
% Calcular primeiras derivadas
dx = spline_primeira_derivada(t, x, S_linha_linha_x);
dy = spline_primeira_derivada(t, y, S_linha_linha_y);

% Construir polinómios e avaliar para gráfico
t_plot = linspace(t(1), t(end), 1000);
x_plot = zeros(size(t_plot));
y_plot = zeros(size(t_plot));

t_tabela=(t(1):1:t(end));
x_tabela=zeros(size(t_tabela));
y_tabela=zeros(size(t_tabela));

for i = 1:n-1
    ti = t(i); ti1 = t(i+1);
    fi_x = x(i); fi1_x = x(i+1);
    fi_y = y(i); fi1_y = y(i+1);
    Mi_x = S_linha_linha_x(i); Mi1_x = S_linha_linha_x(i+1);
    Mi_y = S_linha_linha_y(i); Mi1_y = S_linha_linha_y(i+1);
    % Construir polinómios simbólicos
    Sx = construir_spline(ti, ti1, fi_x, fi1_x, Mi_x, Mi1_x);
    Sy = construir_spline(ti, ti1, fi_y, fi1_y, Mi_y, Mi1_y);
    % Converter para funções MATLAB
    Sx_fun = matlabFunction(Sx);
    Sy_fun = matlabFunction(Sy);
    % Avaliar nos pontos do intervalo
    idx=(t_plot>=ti)&(t_plot<=ti1);
    x_plot(idx)=Sx_fun(t_plot(idx));
    y_plot(idx)=Sy_fun(t_plot(idx));
    idx_tabela=find((t_tabela>=ti) & (t_tabela<=ti1));
    if ~isempty(idx_tabela)
        x_tabela(idx_tabela)=Sx_fun(t_tabela(idx_tabela));
        y_tabela(idx_tabela)=Sy_fun(t_tabela(idx_tabela));
    end
end

% Gráfico de x em função do tempo
figure;
plot(t_plot, x_plot, 'r', 'LineWidth', 2); hold on;
plot(t, x, 'ko', 'MarkerFaceColor', 'k');
xlabel('Tempo (s)'); ylabel('x (m)');
title('x(t) - Coordenda x ao longo do tempo');
grid on;

% Gráfico de y em função do tempo
figure;
plot(t_plot, y_plot, 'g', 'LineWidth', 2); hold on;
plot(t, y, 'ko', 'MarkerFaceColor', 'k');
xlabel('Tempo (s)'); ylabel('y (m)');
title('y(t) - Coordenada y ao longo do tempo');
grid on;

% Gráfico do percurso
figure;
plot(x_plot, y_plot, 'b', 'LineWidth', 2); hold on;
plot(x, y, 'ro', 'MarkerSize', 6, 'MarkerFaceColor', 'r');
xlabel('x (m)'); ylabel('y (m)');
title('Percurso do drone com splines cúbicos naturais');
grid on; axis equal;

t_tabela = t_tabela(:);
x_tabela = x_tabela(:);
y_tabela = y_tabela(:);
disp('Tabela de coordenadas entre t=0 e t=36 segundos:');
disp(table(t_tabela,x_tabela,y_tabela, 'VariableNames',{'t(s)','x(t)','y(t)'}));



function S_linha_linha = spline_segunda_derivada(t, f)
    n = length(t);
    h = diff(t);
    A = zeros(n);
    lado_direito_da_equacao = zeros(n,1);
    A(1,1) = 1;
    A(n,n) = 1;
    lado_direito_da_equacao(1) = 0;
    lado_direito_da_equacao(n) = 0;
    for i = 2:n-1
        A(i,i) = (h(i-1)+h(i))/3;
        A(i,i-1) = h(i-1)/6;
        A(i,i+1) = h(i)/6;
        lado_direito_da_equacao(i) = ((f(i+1) - f(i))/h(i) - (f(i) - f(i-1))/h(i-1));
    end
    S_linha_linha = A \ lado_direito_da_equacao;
end

function d = spline_primeira_derivada(t, f, S_linha_linha)
    n = length(t);
    h = diff(t);
    d = zeros(n,1);
    d(1) = (f(2) - f(1))/h(1) - (h(1)/3)*S_linha_linha(1) - (h(1)/6)*S_linha_linha(2);
    for i = 1:n-1
        d(i+1) = (f(i+1) - f(i))/h(i) - (h(i)/3)*S_linha_linha(i+1) - (h(i)/6)*S_linha_linha(i);
    end
end

function S = construir_spline(ti, ti1, fi, fi1, Mi, Mi1)
    syms t
    h = ti1 - ti;
    S = (Mi/(6*h))*(ti1 - t)^3 + (Mi1/(6*h))*(t - ti)^3 + (fi/h - Mi*h/6)*(ti1 - t) + (fi1/h - Mi1*h/6)*(t - ti);
    S = simplify(S);
end
