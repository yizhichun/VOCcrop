voc_dir = 'F:\ImageDatabase\shipdetection\VOC\';
% voc_dir = '/home/haoyou/ImageDB/VOCdevkit/';

xml_model_filepath = [voc_dir,'xml_model.xml'];

plane_dir = [voc_dir,'plane/'];
ship_dir = [voc_dir,'ship/'];
ship_plane_dir = [voc_dir,'ship_plane/'];

ship_dir_croped = [voc_dir,'ship_croped/'];
ship_dir_rotated = [voc_dir,'ship_rotated/'];

anno_subdir='Annotations/';
img_subdir='JPEGImages/';

% anno_subdir_croped='Annotations_croped/';
% img_subdir_croped='JPEGImages_croped/';
% 
% anno_subdir_rotated='Annotations_rotated/';
% img_subdir_rotated='JPEGImages_rotated/';

train_listfile = 'ImageSets/Main/trainval.txt';
test_listfile = 'ImageSets/Main/test.txt';

[path_list, name_list, xml_list] = LoadVOCList(ship_dir,train_listfile,anno_subdir,img_subdir);
% crop_SaveForList(path_list, name_list, xml_list,ship_dir_croped,xml_model_filepath);
rotate_Crope_Scale_SaveForList(path_list, name_list, xml_list,ship_dir_rotated,xml_model_filepath);

function crop_SaveForList(path_list, name_list, xml_list,save_dir,xml_model_filepath)
    for i=1:length(path_list)
        img = imread(path_list{i});
        xml = xml2struct(xml_list{i});
        [boxes,labels] = getBBsFromXml(xml);
        disp(['Process ',num2str(i),' images...']);
    %     showImgWithBBs(img,boxes,'r');
        [imgs_croped, boxes_croped] = CropFull(img,boxes,labels);

        for i_img=1:size(imgs_croped,1)
            disp(['Process ',num2str(i),' images, ',num2str(i_img),' croped...']);
            xml_croped{i_img,1} = getXmlFromBBs(boxes_croped{i_img},xml2struct(xml_model_filepath));  
            if ~isempty(xml_croped{i_img})
                argument_str=['_croped_',num2str(i_img)];
                saveCroped(save_dir,'JPEGImages/','Annotations/',name_list{i},argument_str,imgs_croped{i_img},xml_croped{i_img});
            end
        end
    end
end

function rotate_Crope_Scale_SaveForList(path_list, name_list, xml_list,save_dir,xml_model_filepath)
    for i=1:length(path_list)
        img = imread(path_list{i});
        xml = xml2struct(xml_list{i});

    %     [boxes,labels] = getBBsFromXml(xml);
    %     disp(['Process ',num2str(i),' images...']);
    %     showImgWithBBs(img,boxes,'r');

        [roboxes,labels] = getRBBsFromXml(xml);
        disp(['Process ',num2str(i),' images...']);
        if isempty(roboxes) continue; end    
    %     showImgWithRBBs(img,roboxes,'r');
        angle_interval=60;
        for angle=0:angle_interval:359
            [imgRes,rbbsRes] = RotateRBBs(img,roboxes,angle);
        %     figure;
        %     showImgWithRBBs(imgRes,rbbsRes,'r');hold on;
            boxes = getBBSofRBBS(rbbsRes);
        %     showImgWithBBs(img,bbs,'g');hold off;

            [imgs_croped, boxes_croped] = CropFull(imgRes,boxes,labels);

            for i_img=1:size(imgs_croped,1)
                disp(['Process ',num2str(i),' images, ', num2str(angle),' rotated,', num2str(i_img),' croped...']);
                xml_croped{i_img,1} = getXmlFromBBs(boxes_croped{i_img},xml2struct(xml_model_filepath));  
                if ~isempty(xml_croped{i_img})
                    argument_str=['_rotated_',num2str(angle),'_croped_',num2str(i_img),'_scaled_10'];
                    saveCroped(save_dir,'JPEGImages/','Annotations/',name_list{i},argument_str,imgs_croped{i_img},xml_croped{i_img});

                    scale_list = [1.2,0.8];
                    for i_scale=1:length(scale_list)
                        argument_str=['_rotated_',num2str(angle),'_croped_',num2str(i_img),'_scaled_',num2str(scale_list(i_scale)*10)];
                        [img_croped_scale1, boxes_croped_scale1] = reScaleImageAndBBs(imgs_croped{i_img},boxes_croped{i_img},scale_list(i_scale));
                        xml_croped_scale1 = getXmlFromBBs(boxes_croped_scale1,xml2struct(xml_model_filepath));
                        saveCroped(save_dir,'JPEGImages/','Annotations/',name_list{i},argument_str,img_croped_scale1,xml_croped_scale1);
                    end
                end
            end

        end
    end
end

function [path_list, name_list, xml_list]=LoadVOCList(root_dir,listfile,anno_subdir,img_subdir)
    if exist([root_dir, listfile],'file')
        dbinfo = textread([root_dir, listfile],'%s');
    else
        disp('Can not find file!');
        return;
    end
    for i=1:length(dbinfo)
        path_list{i,:} = [root_dir,img_subdir,dbinfo{i},'.jpg'];
        name_list{i,:} = dbinfo{i};
        xml_list{i,:} = [root_dir,anno_subdir,dbinfo{i},'.xml'];
    end
end

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

function [bbs,labels] = getBBsFromXml(xml)
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
            labels{1} = xml.annotation.object.name.Text;
        end
    else    
        i=1;
        for o=1:length(xml.annotation.object)  
            if isfield(xml.annotation.object{o},'type') && ...
                    strcmp(xml.annotation.object{o}.type.Text,'bndbox') || ...
                    ~isfield(xml.annotation.object{o},'type')
%                 bbs{i,:} = xml.annotation.object{o}.bndbox;
                bbs(i,1) = str2num(xml.annotation.object{o}.bndbox.xmin.Text);
                bbs(i,2) = str2num(xml.annotation.object{o}.bndbox.ymin.Text);
                bbs(i,3) = str2num(xml.annotation.object{o}.bndbox.xmax.Text);
                bbs(i,4) = str2num(xml.annotation.object{o}.bndbox.ymax.Text);
                labels{i} = xml.annotation.object{o}.name.Text;
                i=i+1;
            end
        end                
    end
end


function [rbbs,labels] = getRBBsFromXml(xml)
    % judge if object is 'robndbox'.
    rbbs=[];
    labels=[];
    if length(xml.annotation.object)==1
        if isfield(xml.annotation.object,'type') && ...
                strcmp(xml.annotation.object.type.Text,'robndbox') || ...
                ~isfield(xml.annotation.object,'type')
%             bbs{1,:} = xml.annotation.object.bndbox;
            rbbs(1,1) = str2num(xml.annotation.object.robndbox.cx.Text);
            rbbs(1,2) = str2num(xml.annotation.object.robndbox.cy.Text);
            rbbs(1,3) = str2num(xml.annotation.object.robndbox.w.Text);
            rbbs(1,4) = str2num(xml.annotation.object.robndbox.h.Text);
            rbbs(1,5) = str2num(xml.annotation.object.robndbox.angle.Text);
            labels{1} = xml.annotation.object.name.Text;
        end
    else    
        i=1;
        for o=1:length(xml.annotation.object)  
            if isfield(xml.annotation.object{o},'type') && ...
                    strcmp(xml.annotation.object{o}.type.Text,'robndbox') || ...
                    ~isfield(xml.annotation.object{o},'type')
%                 bbs{i,:} = xml.annotation.object{o}.bndbox;
                rbbs(i,1) = str2num(xml.annotation.object{o}.robndbox.cx.Text);
                rbbs(i,2) = str2num(xml.annotation.object{o}.robndbox.cy.Text);
                rbbs(i,3) = str2num(xml.annotation.object{o}.robndbox.w.Text);
                rbbs(i,4) = str2num(xml.annotation.object{o}.robndbox.h.Text);
                rbbs(i,5) = str2num(xml.annotation.object{o}.robndbox.angle.Text);
                labels{i} = xml.annotation.object{o}.name.Text;
                i=i+1;
            end
        end                
    end
end


function xml_croped = getXmlFromBBs(boxes_croped, xml_model)
    xml_croped = xml_model;
    xml_croped.annotation.object=[];
    object_model = xml_model.annotation.object{1};
    object_model.bndbox=[];
    if isempty(boxes_croped.bndboxes)
       xml_croped=[];
    elseif size(boxes_croped.bndboxes,1)==1
        tempbox.xmin.Text = num2str(boxes_croped.bndboxes(1,1));
        tempbox.ymin.Text = num2str(boxes_croped.bndboxes(1,2));
        tempbox.xmax.Text = num2str(boxes_croped.bndboxes(1,3));
        tempbox.ymax.Text = num2str(boxes_croped.bndboxes(1,4));
        object_model.name.Text=boxes_croped.labels{1};
        object_model.bndbox=tempbox;
        xml_croped.annotation.object=object_model;
    else        
        for i=1:size(boxes_croped.bndboxes,1)
            tempbox.xmin.Text = num2str(boxes_croped.bndboxes(i,1));
            tempbox.ymin.Text = num2str(boxes_croped.bndboxes(i,2));
            tempbox.xmax.Text = num2str(boxes_croped.bndboxes(i,3));
            tempbox.ymax.Text = num2str(boxes_croped.bndboxes(i,4));
            object_model.name.Text=boxes_croped.labels{i};
            object_model.bndbox=tempbox;
            xml_croped.annotation.object{i}=object_model;
        end
    end        
end

function saveCroped(voc_dir,img_subdir_croped,anno_subdir_croped,img_name,...
    argument_str,img_croped,xml_croped)
    % Finally, create the folder if it doesn't exist already.
    if ~exist([voc_dir,img_subdir_croped], 'dir')
        mkdir([voc_dir,img_subdir_croped]);
    end
    if ~exist([voc_dir,anno_subdir_croped], 'dir')
        mkdir([voc_dir,anno_subdir_croped]);
    end
    imwrite(img_croped,[voc_dir,img_subdir_croped,img_name,argument_str,'.jpg']);
    struct2xml(xml_croped,[voc_dir,anno_subdir_croped,img_name,argument_str,'.xml']); 
    
    % write file list
    if ~exist([voc_dir,'ImageSets/Main/'], 'dir')
        mkdir([voc_dir,'ImageSets/Main/']);
    end
    fid = fopen([voc_dir,'ImageSets/Main/filelist.txt'], 'a');
    fprintf(fid, [img_name,argument_str,'\n']);
    fclose(fid);
end

function [imgRes,xmlRes] = CropRandom(img,xml)
    
end

function [imgs_croped,boxes_croped] = CropFull(img,boxes,labels)
    
    [h,w,~]=size(img);
    
    mean_h = mean(boxes(:,4)-boxes(:,2));
    mean_w = mean(boxes(:,3)-boxes(:,1));

    CROP_SIZE_H = min(round((min(h/2,mean_h*10) + min(w/2,mean_w*10))/2), min(h,w));
    CROP_SIZE_W = CROP_SIZE_H;

%     CROP_SIZE_H = 256;
%     CROP_SIZE_W = 256;
    
    if h<CROP_SIZE_H || w<CROP_SIZE_W
        [imgs_croped,boxes_croped] = CropRandom(img,boxes);
        return;
    end
    
    [rects_croped] = GridImg(img, CROP_SIZE_H, CROP_SIZE_W);    
%     showImgWithBBs(img,rects_croped,'r');  
    
    boxes_cx=(boxes(:,3)+boxes(:,1))/2;
    boxes_cy=(boxes(:,4)+boxes(:,2))/2;
    
    for i=1:size(rects_croped,1)
        boxes_croped{i,1}.bndboxes=[];
        boxes_croped{i,1}.labels=[];
    end
    
    for i=1:size(boxes,1)
        idx = find(rects_croped(:,1)<boxes_cx(i) & rects_croped(:,3)>boxes_cx(i) & ...
            rects_croped(:,2)<boxes_cy(i) & rects_croped(:,4) > boxes_cy(i));
        for j=1:size(idx)
            boxes_croped{idx(j),1}.bndboxes=[boxes_croped{idx(j),1}.bndboxes;boxes(i,:)];
            boxes_croped{idx(j),1}.labels{end+1,1}=labels{i};
        end
    end
    
    idx_null=logical(size(rects_croped,1));
    
    for i=1:size(rects_croped,1)
        idx_null(i) = isempty(boxes_croped{i}.bndboxes);
        if ~idx_null(i)   

            boxes_croped{i}.bndboxes(:,1) = boxes_croped{i}.bndboxes(:,1) - rects_croped(i,1) + 1; 
            boxes_croped{i}.bndboxes(:,3) = boxes_croped{i}.bndboxes(:,3) - rects_croped(i,1) + 1;
            boxes_croped{i}.bndboxes(:,2) = boxes_croped{i}.bndboxes(:,2) - rects_croped(i,2) + 1;
            boxes_croped{i}.bndboxes(:,4) = boxes_croped{i}.bndboxes(:,4) - rects_croped(i,2) + 1;
            
            boxes_croped{i}.bndboxes(boxes_croped{i}.bndboxes(:,1)<1,1) = 1;
            boxes_croped{i}.bndboxes(boxes_croped{i}.bndboxes(:,2)<1,2) = 1;
            boxes_croped{i}.bndboxes(boxes_croped{i}.bndboxes(:,3)>CROP_SIZE_W,3) = CROP_SIZE_W;            
            boxes_croped{i}.bndboxes(boxes_croped{i}.bndboxes(:,4)>CROP_SIZE_H,4) = CROP_SIZE_H;
            
        end
    end
    
    for i=1:size(rects_croped,1)
        imgs_croped{i,1} = imcrop(img,[rects_croped(i,1),rects_croped(i,2),CROP_SIZE_W,CROP_SIZE_H]);
%         imshow(imgs_croped{i});
%         showImgWithBBs(imgs_croped{i},boxes_croped{i}.bndboxes,'b');
%         pause;
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
            i_img = i_img+1;            
        end
    end
end

function img_rotated = RotateImageWithCornerFilled(im, angle)
%     s   = ceil(size(im)/2);
    s   = ceil(size(imrotate(im, angle))/2);
    imP = padarray(im, s(1:2), 'replicate', 'both');
    imR = imrotate(imP, angle);
    S   = ceil(size(imR)/2);
    img_rotated = imR(S(1)-s(1):S(1)+s(1)-1, S(2)-s(2):S(2)+s(2)-1, :); 
end

function [imgRes,rbbs] = RotateRBBs(img,rbbs,angle)
    imgRes = RotateImageWithCornerFilled(img,-angle);
    cx = size(img,2)/2;
    cy = size(img,1)/2;
    cxRes = size(imgRes,2)/2;
    cyRes = size(imgRes,1)/2;
    angle = angle*pi/180;
    XY = [cos(angle) -sin(angle);sin(angle) cos(angle)]*[rbbs(:,1)'-cx;rbbs(:,2)'-cy]+[cxRes;cyRes];
    rbbs(:,1)=XY(1,:)';
    rbbs(:,2)=XY(2,:)';
    rbbs(:,5)=rbbs(:,5)+angle;
end

function [imgRes,bbsRes] = RotateBBs(img,bbs,angle)

end

function [bbs] = getBBSofRBBS(rbbs)
    bbs=[];
    for i=1:size(rbbs,1)
        bbs(i,:)=getBBofRBB(rbbs(i,:));
    end
end

function [bb] = getBBofRBB(rbb)
    XY = getPathOfRBBs(rbb(1,1),rbb(1,2),rbb(1,3),rbb(1,4),rbb(1,5));
    xmin = floor(min(XY(1,:)));
    xmax = floor(max(XY(1,:)));
    ymin = floor(min(XY(2,:)));
    ymax = floor(max(XY(2,:)));
    bb = [xmin,ymin,xmax,ymax];
end

function [XY] = getPathOfRBBs(cx,cy,w,h,angle)
    x1=cx-w/2;
    x2=cx+w/2;
    
    y1=cy-h/2;
    y2=cy+h/2;
    xv=[x1 x2 x2 x1 x1];yv=[y1 y1 y2 y2 y1];
%     R(1,:)=xv;R(2,:)=yv;
%     XY=R;
    XY=[cos(angle) -sin(angle);sin(angle) cos(angle)]*[xv-cx;yv-cy]+[cx;cy];
end

function [imgRes, bbs] = reScaleImageAndBBs(img,bbs,scale)
    w=size(img,2);
    h=size(img,1);
    imgRes = imresize(img,[w*scale, h*scale]);
    bbs.bndboxes = floor(bbs.bndboxes*scale);
end