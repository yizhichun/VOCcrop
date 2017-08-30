function img_rotated = RotateImageWithCornerFilled(im, angle)
%     s   = ceil(size(im)/2);
    s   = ceil(size(imrotate(im, angle))/2);
    imP = padarray(im, s(1:2), 'replicate', 'both');
    imR = imrotate(imP, angle);  
    S   = ceil(size(imR)/2);
    img_rotated = imR(S(1)-s(1):S(1)+s(1)-1, S(2)-s(2):S(2)+s(2)-1, :); 
end