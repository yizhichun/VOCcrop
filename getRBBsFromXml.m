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