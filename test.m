% voc_dir = 'F:\ImageDatabase\shipdetection\VOC\';
voc_dir = '/home/haoyou/ImageDB/VOCdevkit/';

plane_dir = [voc_dir,'plane/'];
ship_dir = [voc_dir,'ship/'];
ship_plane_dir = [voc_dir,'ship_plane/'];

anno_subdir='Annotations/';
img_subdir='JPEGImages/';

train_listfile = 'ImageSets/Main/trainval.txt';
test_listfile = 'ImageSets/Main/test.txt';

[il, xl] = LoadList(ship_dir,train_listfile,anno_subdir,img_subdir);

for i=1:length(il)
    img = imread(il{i});
    xml = xml2struct(xl{i});
    boxes = getBBs(xml);
    
    showImgWithBBs(img,boxes);
%     CropFull(img,boxes);
end


function [img_list, xml_list]=LoadList(root_dir,listfile,anno_subdir,img_subdir)
    if exist([root_dir, listfile],'file')
        dbinfo = textread([root_dir, listfile],'%s');
    else
        disp('Can not find file!');
        return;
    end
    for i=1:length(dbinfo)
        img_list{i,:} = [root_dir,img_subdir,dbinfo{i},'.jpg'];
        xml_list{i,:} = [root_dir,anno_subdir,dbinfo{i},'.xml'];
    end
end

function showImgWithBBs(img,boxes)
    
    if size(img,3)==1
        img=cat(3, img, img, img);
    end
    image(img);
    axis image;
    axis off;
%     set(gcf, 'Gray', 'white');

    if ~isempty(boxes)
      x1 = boxes(:, 1);
      y1 = boxes(:, 2);
      x2 = boxes(:, 3);
      y2 = boxes(:, 4);
      c = 'r';
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

function [bbs] = getBBs(xml)
    % judge if object is 'bndbox'.
    if length(xml.annotation.object)==1
        if isfield(xml.annotation.object,'type') && ...
                strcmp(xml.annotation.object.type.Text,'bndbox') || ...
                ~isfield(xml.annotation.object,'type')
%             bbs{1,:} = xml.annotation.object.bndbox;
            bbs(1,1) = str2num(xml.annotation.object.bndbox.xmin.Text);
            bbs(1,2) = str2num(xml.annotation.object.bndbox.ymin.Text);
            bbs(1,3) = str2num(xml.annotation.object.bndbox.xmax.Text);
            bbs(1,4) = str2num(xml.annotation.object.bndbox.ymax.Text);
        end
    else    
        i=1;
        for o=1:length(xml.annotation.object)  
            if isfield(xml.annotation.object{o},'type') && ...
                    strcmp(xml.annotation.object{o}.type.Text,'bndbox') || ...
                    ~isfield(xml.annotation.object,'type')
%                 bbs{i,:} = xml.annotation.object{o}.bndbox;
                bbs(i,1) = str2num(xml.annotation.object{o}.bndbox.xmin.Text);
                bbs(i,2) = str2num(xml.annotation.object{o}.bndbox.ymin.Text);
                bbs(i,3) = str2num(xml.annotation.object{o}.bndbox.xmax.Text);
                bbs(i,4) = str2num(xml.annotation.object{o}.bndbox.ymax.Text);
                i=i+1;
            end
        end                
    end
end

function [imgRes,xmlRes] = CropRandom(img,xml)

end

function [imgs,xmls] = CropFull(img,xml)
    CROP_SIZE_H = 256;
    CROP_SIZE_W = 256;
    [h,w,~]=size(img);
    if h<=CROP_SIZE_H || w<=CROP_SIZE_W
        [imgs,xmls] = CropRandom(img,xml);
        return;
    end
    
    num_h = ceil(h/256);
    num_w = ceil(w/256);
    for i=1:num_h
        y_end(i) = round(h/num_h);
        y_start(i) = y_end(i) - 256 + 1;
    end
    
    for i=1:num_w
        x_end(i) = round(w/num_w);
        x_start(i) = x_end(i) - 256 + 1;
    end
    
    i_img=1;
    for i_x=1:num_w
        for i_y=1:num_h
            temp_rect = [x_start(i_x) y_start(i_y) x_end(i_y) y_end(i_y)];
            imgs{i_img} = imcrop(img,temp_rect);
            imshow(imgs{i_img});
            i_img = i_img+1;            
        end
    end
    
end

function [imgRes,xmlRes] = RotateWithBB(img,xml,angle)

end

function [imgRes,xmlRes] = RotateWithRBB(img,xml,angle)

end

function [bb] = getBBofRBB(rbb,width,height)

end