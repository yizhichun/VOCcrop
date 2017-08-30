function [bbs] = GridImg(img, CROP_SIZE_H, CROP_SIZE_W)
    [h,w,~]=size(img);
    num_h = ceil(h/CROP_SIZE_H)*2;
    num_w = ceil(w/CROP_SIZE_W)*2;
    for i=1:num_h
        y_end(i) = CROP_SIZE_H + round((i-1)*(h-CROP_SIZE_H)/(num_h-1));
        y_start(i) = y_end(i) - CROP_SIZE_H + 1;
    end
    
    for i=1:num_w
        x_end(i) = CROP_SIZE_W + round((i-1)*(w-CROP_SIZE_W)/(num_w-1));
        x_start(i) = x_end(i) - CROP_SIZE_W + 1;
    end
    
    i_img=1;
    for i_x=1:num_w
        for i_y=1:num_h
            temp_rect = [x_start(i_x) y_start(i_y) x_end(i_x) y_end(i_y)];
            bbs(i_img,1) = x_start(i_x);
            bbs(i_img,2) = y_start(i_y);
            bbs(i_img,3) = x_end(i_x);
            bbs(i_img,4) = y_end(i_y);
            i_img = i_img+1;            
        end
    end
end