
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