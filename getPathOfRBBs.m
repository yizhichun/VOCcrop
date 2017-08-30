function [XY] = getPathOfRBBs(cx,cy,w,h,angle)
    x1=cx-w/2;
    x2=cx+w/2;
    
    y1=cy-h/2;
    y2=cy+h/2;
    xv=[x1 x2 x2 x1 x1];yv=[y1 y1 y2 y2 y1];
%     R(1,:)=xv;R(2,:)=yv;
%     XY=R;
    XY=[cos(angle) -sin(angle);sin(angle) cos(angle)]*[xv-cx;yv-cy]+repmat([cx;cy],[1,5]);
end