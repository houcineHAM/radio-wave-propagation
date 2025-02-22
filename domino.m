clear all;
clc;

% Load the image
img = imread('img.jpg');

% Figure 1
figure(1);

% Subplot 1 - Original image
subplot(1, 3, 1);
imshow(img);
title('Original Image');

% RGB values to detect the domino
r1 = 188; g1 = 189; b1 = 181;
r2 = 141; g2 = 142; b2 = 134;

% Define a tolerance range for each RGB channel
tolerance = 30;

% Create a binary mask for pixels similar to (r1, g1, b1)
mask1 = (img(:,:,1) >= r1-tolerance) & (img(:,:,1) <= r1+tolerance) & ...
        (img(:,:,2) >= g1-tolerance) & (img(:,:,2) <= g1+tolerance) & ...
        (img(:,:,3) >= b1-tolerance) & (img(:,:,3) <= b1+tolerance);

% Create a binary mask for pixels similar to (r2, g2, b2)
mask2 = (img(:,:,1) >= r2-tolerance) & (img(:,:,1) <= r2+tolerance) & ...
        (img(:,:,2) >= g2-tolerance) & (img(:,:,2) <= g2+tolerance) & ...
        (img(:,:,3) >= b2-tolerance) & (img(:,:,3) <= b2+tolerance);

% Combine both masks using logical OR
mask = mask1 | mask2;

% Apply the mask to the image
result = bsxfun(@times, img, cast(mask, 'like', img));

% Convert the masked image to grayscale
gimg = rgb2gray(result);

% Display the masked image and grayscale image
subplot(1, 3, 2);
imshow(result);
title('Masked Image');

subplot(1, 3, 3);
imshow(gimg);
title('Grayscale Image');

% Binarize the grayscale image from the masked image
binary_img1 = imbinarize(gimg);

% Convert the original image to grayscale
gimg1 = rgb2gray(img);

% Binarize the original grayscale image for contour detection
binary_img = imbinarize(gimg1);

% Define the structuring element for erosion and dilation
sel = strel('diamond', 4);

% Apply erosion
er = imerode(gimg1, sel);

% Display the eroded image
figure(2);
subplot(1, 3, 1);
imshow(er);
title('Image after Erosion and Dilation');

% Edge detection using Sobel gradient
[Gmag, ~] = imgradient(gimg1, 'Sobel');

% Remove weak edges
Gmag(Gmag < 35) = 0;

% Complement the gradient image to reduce flash variations
imcomp = imcomplement(Gmag);

% Binarize the complemented image
imc = imbinarize(imcomp);

% Define structuring element for erosion
sel2 = strel('rectangle', [10 5]);

% Apply erosion
erc = imerode(imc, sel2);

% Combine the original binary image and the eroded image using logical AND
an = bitand(binary_img, erc);

% Display the combined binary image
subplot(1, 3, 2);
imshow(an);
title('Binary Combination');

% Structuring element for morphological operations
sel = strel('rectangle', [20 20]);

% Apply opening to remove small objects
er = imopen(an, sel);

% Apply multiple dilations to enhance features
for i = 1:6
    er = imdilate(er, sel);
end

% Apply closing to fill small holes
er = imclose(er, sel);

% Display the processed image after morphological operations
subplot(1, 3, 3);
imshow(er);
title('Support for Logical AND');

% Combine the processed image with the binary masked image using AND
resultat = bitand(er, binary_img1);

% Apply median filtering to reduce noise
resultat = medfilt2(resultat, [10, 10]);

% Display the final result
figure(3);
imshow(resultat);
title('Final Result');
