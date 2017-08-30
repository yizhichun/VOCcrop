function [imgRes, bbs] = reScaleImageAndBBs(img,bbs,scale)
    w=size(img,2);
    h=size(img,1);
    imgRes = imresize(img,[w*scale, h*scale]);
    bbs.bndboxes = floor(bbs.bndboxes*scale);
end
