t = 0:10;

x = [3.6274 4.7839 12.2002 15.6936 21.4540 23.2871 ...
     28.9799 33.1312 39.0343 39.6250 40.1570];
y = [1.454 1.858 3.872 7.444 10.397 14.350 ...
     15.266 18.313 19.616 20.102 24.915];
z = [11.907 14.9641 14.1788 16.9027 19.2841 16.8510 ...
     27.8011 28.4035 30.1432 39.9430 41.9723];

epsilon = 1;   % parâmetro ε
% Calcular derivadas usando a função derivada_filtrada
xprime = derivada_filtrada(t, x, epsilon);
yprime = derivada_filtrada(t, y, epsilon);
zprime = derivada_filtrada(t, z, epsilon);


% Mostrar resultados 
disp('--------------------------------------------');
disp('Derivadas aproximadas (ε = 1)');
disp(table(t', xprime', yprime', zprime', ...
    'VariableNames', {'t','xprime','yprime','zprime'}));
