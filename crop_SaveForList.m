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
