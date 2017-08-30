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