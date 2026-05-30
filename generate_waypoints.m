clc; close all; clear;

% 1. Selecciona y lee la imagen
[archivo, ruta] = uigetfile({'*.jpg;*.png;*.bmp;*.jpeg', 'Imágenes (*.jpg, *.png, *.bmp)'});
if archivo == 0
    error('No hay ninguna imagen.');
end
img = imread(fullfile(ruta, archivo));

% Obtener la altura de la imagen para voltear el eje Y después
altura_imagen = size(img, 1);

% 2. Configurar la ventana gráfica
hFig = figure('Name', 'Marcador de Waypoints EN VIVO', 'NumberTitle', 'off', 'WindowState', 'maximized');
imshow(img);
hold on;
axis on; % Muestra los ejes de coordenadas de la imagen

% Título con instrucciones
hTitle = title({'\bfMarcador de Waypoints', ...
               '\rm\color{blue}Haz Clic Izquierdo para añadir puntos.', ...
               '\rm\color{red}Haz Clic Derecho (o Ctrl+Clic) en el último punto para TERMINAR.'}, ...
               'FontSize', 12);

% Inicializar variables para guardar los puntos
x = [];
y = [];
hPlotPoints = []; % Variable para guardar los gráficos de los puntos y líneas
hPlotText = [];   % Variable para guardar los números

button = 1; % Inicializar indicando clic izquierdo

% 3. Bucle de captura EN VIVO
while button == 1
    try
        [x_n, y_n, button] = ginput(1);
    catch
        break;
    end
    if isempty(x_n)
        break;
    end
    
    %dibujar
    if button == 1
        x = [x; x_n];
        y = [y; y_n];
        k = length(x); % Número del punto actual
        
        if ~isempty(hPlotPoints)
            delete(hPlotPoints);
            delete(hPlotText);
        end
        
        hPlotPoints = plot(x, y, 'r-o', 'LineWidth', 2, 'MarkerSize', 8, 'MarkerFaceColor', 'y');
        
        hPlotText = text(x + 5, y - 5, cellstr(num2str((1:k)')), ...
            'Color', 'cyan', 'FontSize', 12, 'FontWeight', 'bold', 'Clipping', 'on');
        
        drawnow; 
    end
end

% 4. Finalización y exportación
if isempty(x)
    title('No se seleccionaron puntos.');
    return;
end

title('Puntos capturados con éxito!', 'Color', [0 0.5 0], 'FontSize', 14);

y_corregido = altura_imagen - y;
waypoints = [x, y_corregido];

% 5. IMPRIMIR EN CONSOLA 
fprintf('waypoints = [\n');
for i = 1:size(waypoints, 1)
    if i < size(waypoints, 1)
        fprintf('  %.13f, %.13f;\n', waypoints(i, 1), waypoints(i, 2));
    else
        fprintf('  %.13f, %.13f\n', waypoints(i, 1), waypoints(i, 2));
    end
end
fprintf('];\n');
