function map = generarMapa1() 
% GENERARMAPA Genera un mapa logístico de 500x500 celdas
% Representa racks, estación de carga y pasillos para SLAM 

    % Dimensiones del mapa 
     N = 500; 
     M = 500; 
    
     % Crear figura oculta para dibujar y rasterizar 
     f = figure('Visible','off'); 
     ax = axes(f); 
     hold(ax, 'on'); 
     axis(ax, [0 N 0 M]); 
     axis(ax, 'ij'); % (0,0) esquina superior izquierda 
     
     % Fondo libre (blanco) 
     fill([0 N N 0], [0 0 M M], [1 1 1], 'Parent', ax); 
%---------------------------- 
% Racks verticales (ocupados) 
%---------------------------- 
     rackWidth = 15; 
     rackHeight = 350; 
     xStart = 80; spacing = 70; 
     for i = 0:4 
         xRack = xStart + i*spacing; 
         coords = [xRack, 80; 
                   xRack+rackWidth, 80;
                   xRack+rackWidth, 80+rackHeight; 
                   xRack, 80+rackHeight]; 
         fill(coords(:,1), coords(:,2), [0 0 0], 'Parent', ax); 
     end 
 %---------------------------- 
 % Estación de carga 
 %----------------------------
      station = [30, 450; 
                 60, 450; 
                 60, 480; 
                 30, 480]; 
      fill(station(:,1), station(:,2), [0 0 0], 'Parent', ax); 
      
 %---------------------------- 
 % Pasillos libres (ya son blancos por defecto) 
 %---------------------------- 
 %---------------------------- 
 % Rasterizar imagen 
 %---------------------------- 
     frame = getframe(ax); 
     img = rgb2gray(frame.cdata); 
     img = imresize(img, [M N]); 
     
 % Binarizar: fondo blanco (255) → 1 libre, negro (0) → 0 ocupado 
     map = ~imbinarize(img); 
 %----------------------------
 %  % Visualización del mapa 
 %---------------------------- 
    figure; 
    hold on; 
    image(100*map); 
    colormap(sky(100)); 
    axis([0 N 0 M]); 
    xlabel('X'); ylabel('Y'); 
    title('Mapa del Entorno Logístico (SLAM)'); 
end