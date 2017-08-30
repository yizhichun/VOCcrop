function [bbs] = getBBSofRBBS(rbbs)
    bbs=[];
    for i=1:size(rbbs,1)
        bbs(i,:)=getBBofRBB(rbbs(i,:));
    end
end