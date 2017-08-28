voc_dir = 'F:\ImageDatabase\shipdetection\VOC\';
% voc_dir = '/home/haoyou/ImageDB/VOCdevkit/';

plane_dir = [voc_dir,'plane/'];
ship_dir = [voc_dir,'ship/'];
ship_plane_dir = [voc_dir,'ship_plane/'];

anno_subdir='Annotations/';
img_subdir='JPEGImages/';

anno_subdir_croped='Annotations_croped/';
img_subdir_croped='JPEGImages_croped/';

train_listfile = 'ImageSets/Main/trainval.txt';
test_listfile = 'ImageSets/Main/test.txt';

[il, xl] = LoadList(ship_dir,train_listfile,anno_subdir,img_subdir);

for i=1:length(il)
    img = imread(il{i});
    xml = xml2struct(xl{i});
    boxes = getBBsFromXml(xml);
    
    showImgWithBBs(img,boxes,'r');
    [imgs_croped, boxes_croped] = CropFull(img,boxes);
    
    for i_img=1:size(imgs_croped,1)        
        xml_croped{i_img} = getXmlFromBBs(boxes_croped{i_img},xml);
        saveCroped(voc_dir,imgs_croped{i_img},xml_croped{i_img});
    end
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

function showImgWithBBs(img,boxes,c)
    
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

function [bbs] = getBBsFromXml(xml)
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


function xml_croped = getXmlFromBBs(boxes_croped, xml_model)
    object_model = xml_model.annotation.object{1};
    if isnull(boxes_croped)
       xml_croped=[];
    elseif size(boxes_croped,1)==1
        tempbox
        xml_croped.annotation.object=
    else
        
    end        
end

function saveCroped(voc_dir,imgs_croped,xml_croped)

end

function [imgRes,xmlRes] = CropRandom(img,xml)
    
end

function [imgs_croped,boxes_croped] = CropFull(img,boxes)
    
    [h,w,~]=size(img);
    
    mean_h = mean(boxes(:,4)-boxes(:,2));
    mean_w = mean(boxes(:,3)-boxes(:,1));

    CROP_SIZE_H = min(round((min(h/2,mean_h*10) + min(w/2,mean_w*10))/2), min(h,w));
    CROP_SIZE_W = CROP_SIZE_H;

%     CROP_SIZE_H = 256;
%     CROP_SIZE_W = 256;
    
    if h<=CROP_SIZE_H || w<=CROP_SIZE_W
        [imgs_croped,boxes_croped] = CropRandom(img,boxes);
        return;
    end
    
    [rects_croped] = GridImg(img, CROP_SIZE_H, CROP_SIZE_W);    
    showImgWithBBs(img,rects_croped,'r');  
    
    boxes_cx=(boxes(:,3)+boxes(:,1))/2;
    boxes_cy=(boxes(:,4)+boxes(:,2))/2;
    
    for i=1:size(rects_croped,1)
        boxes_croped{i,1}=[];
    end
    
    for i=1:size(boxes,1)
        idx = find(rects_croped(:,1)<boxes_cx(i) & rects_croped(:,3)>boxes_cx(i) & ...
            rects_croped(:,2)<boxes_cy(i) & rects_croped(:,4) > boxes_cy(i));
        for j=1:size(idx)
            boxes_croped{idx(j),1}=[boxes_croped{idx(j),1};boxes(i,:)];
        end
    end
    
    idx_null=logical(size(rects_croped,1));
    
    for i=1:size(rects_croped,1)
        idx_null(i) = isempty(boxes_croped{i});
        if ~idx_null(i)   

            boxes_croped{i}(:,1) = boxes_croped{i}(:,1) - rects_croped(i,1) + 1; 
            boxes_croped{i}(:,3) = boxes_croped{i}(:,3) - rects_croped(i,1) + 1;
            boxes_croped{i}(:,2) = boxes_croped{i}(:,2) - rects_croped(i,2) + 1;
            boxes_croped{i}(:,4) = boxes_croped{i}(:,4) - rects_croped(i,2) + 1;
            
            boxes_croped{i}(boxes_croped{i}(:,1)<1,1) = 1;
            boxes_croped{i}(boxes_croped{i}(:,2)<1,2) = 1;
            boxes_croped{i}(boxes_croped{i}(:,3)>CROP_SIZE_W,3) = CROP_SIZE_W;            
            boxes_croped{i}(boxes_croped{i}(:,4)>CROP_SIZE_H,4) = CROP_SIZE_H;
            
        end
    end
    
    for i=1:size(rects_croped,1)
        imgs_croped{i} = imcrop(img,[rects_croped(i,1),rects_croped(i,2),CROP_SIZE_W,CROP_SIZE_H]);
        imshow(imgs_croped{i});
        showImgWithBBs(imgs_croped{i},boxes_croped{i},'b');
        pause;
    end
    
end

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
%             imgs{i_img} = imcrop(img,temp_rect);
%             imshow(imgs{i_img});
            i_img = i_img+1;            
        end
    end
%     bbs2=[];
%     bbs2(:,1)=bbs(:,1)+round((w-CROP_SIZE_W)/(num_w-1))/2;
%     bbs2(:,3)=bbs(:,3)+round((w-CROP_SIZE_W)/(num_w-1))/2;
%     bbs2(:,2)=bbs(:,2)+round((h-CROP_SIZE_H)/(num_h-1))/2;
%     bbs2(:,4)=bbs(:,4)+round((h-CROP_SIZE_H)/(num_h-1))/2;
%     
%     i_img=1;
%     for i_x=1:num_w-1
%         for i_y=1:num_h-1
%             temp_rect = [x_start(i_x) y_start(i_y) x_end(i_x) y_end(i_y)];
%             bbs2(i_img,1) = x_start(i_x)+round((w-CROP_SIZE_W)/(num_w-1))/2;
%             bbs2(i_img,2) = y_start(i_y)+round((h-CROP_SIZE_H)/(num_h-1))/2;
%             bbs2(i_img,3) = x_end(i_x)+round((w-CROP_SIZE_W)/(num_w-1))/2;
%             bbs2(i_img,4) = y_end(i_y)+round((h-CROP_SIZE_H)/(num_h-1))/2;
% %             imgs{i_img} = imcrop(img,temp_rect);
% %             imshow(imgs{i_img});
%             i_img = i_img+1;            
%         end
%     end
end

function [imgRes,xmlRes] = RotateWithBB(img,xml,angle)

end

function [imgRes,xmlRes] = RotateWithRBB(img,xml,angle)

end

function [bb] = getBBofRBB(rbb,width,height)

end