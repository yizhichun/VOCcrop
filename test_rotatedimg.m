% A = imread('~/lena.jpg');
% angle = 10;
% T = @(I) imrotate(I,angle,'bilinear','crop');
% %// Apply transformation
% TA = T(A);
% mask = T(ones(size(A)))==1;
% A(mask) = TA(mask);
% %%// Show image
% imshow(A);
% 
% 
im  = imread('~/lena.jpg'); %// You can also read a color image 
s   = ceil(size(im)/2);
imP = padarray(im, s(1:2), 'replicate', 'both');
imR = imrotate(imP, 30);
S   = ceil(size(imR)/2);
imF = imR(S(1)-s(1):S(1)+s(1)-1, S(2)-s(2):S(2)+s(2)-1, :); %// Final form
figure, 
subplot(1, 2, 1)
imshow(im); 
title('Original Image')
subplot(1, 2, 2)
imshow(imF);
title('Rotated Image')


% I = imread('~/lena.jpg');
% % roi=[60 80 100 90];
% roi=[1 1 500 500];
% J = imrotate(imcrop(I,roi),-21,'bilinear','crop');
% [K x y w h] = roirotate(I,roi,-21,'bilinear');
% figure, subplot(1,3,1), imshow(I), title('roi')
% rectangle('Position',roi,'EdgeColor','red');
% rectangle('Position',[x y w h],'EdgeColor','green');
% subplot(1,3,2), imshow(J), title('imrotate')
% subplot(1,3,3), imshow(K), title('roirotate')


