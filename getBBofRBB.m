function [bb] = getBBofRBB(rbb)
    XY = getPathOfRBBs(rbb(1,1),rbb(1,2),rbb(1,3),rbb(1,4),rbb(1,5));
    xmin = floor(min(XY(1,:)));
    xmax = floor(max(XY(1,:)));
    ymin = floor(min(XY(2,:)));
    ymax = floor(max(XY(2,:)));
    bb = [xmin,ymin,xmax,ymax];
end