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