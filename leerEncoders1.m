function [NL, NR] = leerEncoders1(nombreArchivo)
% LEERENCODERS  Carga datos de encoders desde un archivo .mat
% Entradas:
%   nombreArchivo -> nombre del archivo .mat con los datos de encoders
% Salidas:
%   NL -> cuentas del encoder izquierdo
%   NR -> cuentas del encoder derecho

    %----------------------------
    % 1) Archivo por defecto
    %----------------------------
    if nargin < 1 || isempty(nombreArchivo)
        nombreArchivo = 'Encoder.mat'; % archivo por defecto
    end

    %----------------------------
    % 2) Cargar archivo
    %----------------------------
    datos = load(nombreArchivo);

    %----------------------------
    % 3) Extraer matriz de encoders
    %----------------------------
    % Se espera que el archivo contenga una variable llamada 'Enc'
    % con dos columnas: [NL, NR]
    if isfield(datos, 'Enc')
        NL = datos.Enc(:,1);
        NR = datos.Enc(:,2);
    else
        error('El archivo %s no contiene la variable "Enc".', nombreArchivo);
    end
end
