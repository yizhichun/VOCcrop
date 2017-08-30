function showImgWithBBs(img,boxes,c)
    
    if size(img,3)==1
        img=cat(3, img, img, img);
    end
%     image(img);
    axis image;
    axis off;
%     set(gcf, 'Gray', 'white');

    if ~isempty(boxes)
      x1 = boxes(:, 1);
      y1 = boxes(:, 2);
      x2 = boxes(:, 3);
      y2 = boxes(:, 4);
%       c = 'r';
      s = '-';
      line([x1 x1 x2 x2 x1]', [y1 y2 y2 y1 y1]', ...
           'color', c, 'linewidth', 2, 'linestyle', s);
%       for i = 1:size(boxes, 1)
%         text(double(x1(i)), double(y1(i)) - 2, ...
%              sprintf('%.3f', boxes(i, end)), ...
%              'backgroundcolor', 'r', 'color', 'w');
%       end
    end
    pause;
end