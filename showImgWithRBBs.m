function showImgWithRBBs(img,roboxes,c)
    
    if size(img,3)==1
        img=cat(3, img, img, img);
    end
    image(img);
    axis image;
    axis off;
%     set(gcf, 'Gray', 'white');

    if ~isempty(roboxes)
        X=[];
        Y=[];
        for i=1:size(roboxes,1)
            XY = getPathOfRBBs(roboxes(i,1),roboxes(i,2),roboxes(i,3),roboxes(i,4),roboxes(i,5));
            X = [X;XY(1,:)];
            Y = [Y;XY(2,:)];
        end
%       x1 = boxes(:, 1);
%       y1 = boxes(:, 2);
%       x2 = boxes(:, 3);
%       y2 = boxes(:, 4);
%       c = 'r';
      s = '-';
      line(X', Y', ...
           'color', c, 'linewidth', 2, 'linestyle', s);
%       for i = 1:size(boxes, 1)
%         text(double(x1(i)), double(y1(i)) - 2, ...
%              sprintf('%.3f', boxes(i, end)), ...
%              'backgroundcolor', 'r', 'color', 'w');
%       end
    end
    pause;
end