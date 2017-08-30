
function rotate_Crope_Scale_SaveForList(path_list, name_list, xml_list,save_dir,xml_model_filepath)
    for i=1:200%length(path_list)
        img = imread(path_list{i});
        xml = xml2struct(xml_list{i});

    %     [boxes,labels] = getBBsFromXml(xml);
    %     disp(['Process ',num2str(i),' images...']);
    %     showImgWithBBs(img,boxes,'r');

        [roboxes,labels] = getRBBsFromXml(xml);
        disp(['Process ',num2str(i),' images...']);
        if isempty(roboxes) continue; end    
    %     showImgWithRBBs(img,roboxes,'r');
        angle_interval=60;
        for angle=0:angle_interval:359
            [imgRes,rbbsRes] = RotateRBBs(img,roboxes,angle);
        %     figure;
        %     showImgWithRBBs(imgRes,rbbsRes,'r');hold on;
            boxes = getBBSofRBBS(rbbsRes);
        %     showImgWithBBs(img,bbs,'g');hold off;

            [imgs_croped, boxes_croped] = CropFull(imgRes,boxes,labels);

            for i_img=1:size(imgs_croped,1)
                disp(['Process ',num2str(i),' images, ', num2str(angle),' rotated,', num2str(i_img),' croped...']);
                xml_croped{i_img,1} = getXmlFromBBs(boxes_croped{i_img},xml2struct(xml_model_filepath));  
                if ~isempty(xml_croped{i_img})
                    argument_str=['_rotated_',num2str(angle),'_croped_',num2str(i_img),'_scaled_10'];
                    saveCroped(save_dir,'JPEGImages/','Annotations/',name_list{i},argument_str,imgs_croped{i_img},xml_croped{i_img});

                    scale_list = [1.2,0.8];
                    for i_scale=1:length(scale_list)
                        argument_str=['_rotated_',num2str(angle),'_croped_',num2str(i_img),'_scaled_',num2str(scale_list(i_scale)*10)];
                        [img_croped_scale1, boxes_croped_scale1] = reScaleImageAndBBs(imgs_croped{i_img},boxes_croped{i_img},scale_list(i_scale));
                        xml_croped_scale1 = getXmlFromBBs(boxes_croped_scale1,xml2struct(xml_model_filepath));
                        saveCroped(save_dir,'JPEGImages/','Annotations/',name_list{i},argument_str,img_croped_scale1,xml_croped_scale1);
                    end
                end
            end

        end
    end
end
