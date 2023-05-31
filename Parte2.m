unzip('Minions-gif-jpg.zip');

% Leo las imágenes de los fotogramas
numFrames = 21;  % Número de imágenes
frames = cell(numFrames, 1);
for i = 0:numFrames-1
    filename = sprintf('frame_%02d_delay-0.1s.jpg', i);
    frames{i+1} = imread(filename);
end

% Realizo la resta de los cuadros adyacentes
result = frames{1};
for i = 2:numFrames
    result = imsubtract(result, frames{i});
end

figure;
imhist(result);
title('Histograma del cuadro resultante');

