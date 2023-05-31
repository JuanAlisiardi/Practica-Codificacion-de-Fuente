% a)
lena=imread('thumbnail_lena.jpg');
figure(1)
imshow(lena)
title('Original')

figure(2)
lenaG=rgb2gray(lena);
subplot(2, 2, 1);
imshow(lenaG)
title('Gris')

canalR = lena(:, :, 1); % Extrae el canal rojo (primer plano) de la imagen
lenaR = cat(3, canalR, zeros(size(canalR)), zeros(size(canalR))); % Crea una imagen solo con la componente de rojo
subplot(2, 2, 2);
imshow(lenaR)
title('Rojo')

canalV = lena(:, :, 2); % Extrae el canal verde de la imagen
lenaV = cat(3, zeros(size(canalV)), canalV, zeros(size(canalV))); % Crea una imagen solo con la componente de verde
subplot(2, 2, 3);
imshow(lenaV)
title('Verde')

canalA = lena(:, :, 3); % Extrae el canal azul de la imagen
lenaA = cat(3, zeros(size(canalA)), zeros(size(canalA)), canalA); % Crea una imagen solo con la componente de azul
subplot(2, 2, 4);
imshow(lenaA)
title('Azul')


% b)
% Amplificar la componente de color rojo
amp = 2; % amplificación
canalRAmp = canalR * amp;

% Reconstructir la imagen con la componente de rojo amplificada
lenaAmpR = uint8(cat(3, canalRAmp, canalV, canalA));
figure(3);
imshow(lenaAmpR);
title('Componente de Rojo Amplificada');


% c)
% Calcular el histograma de los niveles de grises
[histograma, nivelesG] = imhist(lenaG);
figure(4);
bar(nivelesG, histograma);
title('Histograma de Niveles de Grises');
xlabel('Niveles de Grises');
ylabel('Frecuencia');


% d)
% Divido la imagen en bloques de 8x8
[m, n] = size(lenaG);
bloques = mat2cell(lenaG, 8*ones(1, m/8), 8*ones(1, n/8));
numFilas = size(bloques, 1);
numColumnas = size(bloques, 2);

% Aplico la transformada coseno discreta a cada bloque
bloquesDCT = cell(size(bloques));
for i = 1:numFilas
    for j = 1:numColumnas
        bloquesDCT{i, j} = dct2(bloques{i, j});
    end
end

% Defino dos matrices de cuantización para comparar
matrizCuantizacion = [16 11 10 16 24 40 51 61;
                      12 12 14 19 26 58 60 55;
                      14 13 16 24 40 57 69 56;
                      14 17 22 29 51 87 80 62;
                      18 22 37 56 68 109 103 77;
                      24 35 55 64 81 104 113 92;
                      49 64 78 87 103 121 120 101;
                      72 92 95 98 112 100 103 99];

matrizCuantizacion2 = [1 2 3 4 5 6 7 8;
                       2 3 4 5 6 7 8 9;
                       3 4 5 6 7 8 9 10;
                       4 5 6 7 8 9 10 11;
                       5 6 7 8 9 10 11 12;
                       6 7 8 9 10 11 12 13;
                       7 8 9 10 11 12 13 14;
                       8 9 10 11 12 13 14 15];

% Aplico la cuantización a cada bloque de la DCT utilizando estas matrices
bloquesCuantizados = cell(size(bloquesDCT));
bloquesCuantizados2 = cell(size(bloquesDCT));
for i = 1:numFilas
    for j = 1:numColumnas
        bloquesCuantizados{i, j} = round(bloquesDCT{i, j} ./ (matrizCuantizacion));
        bloquesCuantizados2{i, j} = round(bloquesDCT{i, j} ./ (matrizCuantizacion2));
    end
end

% Reconstruyo la imagen aplicando la inversa de la DCT a cada bloque
lenaReconstruida = zeros(m, n);
lenaReconstruida2 = zeros(m, n);
for i = 1:numFilas
    for j = 1:numColumnas
        lenaReconstruida((i-1)*8+1:i*8, (j-1)*8+1:j*8) = idct2(bloquesCuantizados{i, j});
        lenaReconstruida2((i-1)*8+1:i*8, (j-1)*8+1:j*8) = idct2(bloquesCuantizados2{i, j});
    end
end
lenaReconstruida = uint8(lenaReconstruida);
lenaReconstruida2 = uint8(lenaReconstruida2);

figure(5)
subplot(1, 2, 1);
imshow(lenaReconstruida);
title('Imagen Reconstruida (DCT) 1');
subplot(1, 2, 2);
imshow(lenaReconstruida2);
title('Imagen Reconstruida (DCT) 2');
