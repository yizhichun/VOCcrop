function [imgRes,rbbs] = RotateRBBs(img,rbbs,angle)
    imgRes = RotateImageWithCornerFilled(img,-angle);
    cx = size(img,2)/2;
    cy = size(img,1)/2;
    cxRes = size(imgRes,2)/2;
    cyRes = size(imgRes,1)/2;
    angle = angle*pi/180;
    XY = [cos(angle) -sin(angle);sin(angle) cos(angle)]*[rbbs(:,1)'-cx;rbbs(:,2)'-cy]+repmat([cxRes;cyRes],[1,size(rbbs,1)]);
    rbbs(:,1)=XY(1,:)';
    rbbs(:,2)=XY(2,:)';
    rbbs(:,5)=rbbs(:,5)+repmat(angle,[size(rbbs,1),1]);
end