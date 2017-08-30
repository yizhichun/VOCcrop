function [path_list, name_list, xml_list]=LoadVOCList(root_dir,listfile,anno_subdir,img_subdir)
    if exist([root_dir, listfile],'file')
        dbinfo = textread([root_dir, listfile],'%s');
    else
        disp('Can not find file!');
        return;
    end
    for i=1:length(dbinfo)
        path_list{i,:} = [root_dir,img_subdir,dbinfo{i},'.jpg'];
        name_list{i,:} = dbinfo{i};
        xml_list{i,:} = [root_dir,anno_subdir,dbinfo{i},'.xml'];
    end
end