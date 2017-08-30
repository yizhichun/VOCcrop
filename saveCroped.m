function saveCroped(voc_dir,img_subdir_croped,anno_subdir_croped,img_name,...
    argument_str,img_croped,xml_croped)
    % Finally, create the folder if it doesn't exist already.
    if ~exist([voc_dir,img_subdir_croped], 'dir')
        mkdir([voc_dir,img_subdir_croped]);
    end
    if ~exist([voc_dir,anno_subdir_croped], 'dir')
        mkdir([voc_dir,anno_subdir_croped]);
    end
    imwrite(img_croped,[voc_dir,img_subdir_croped,img_name,argument_str,'.jpg']);
    struct2xml(xml_croped,[voc_dir,anno_subdir_croped,img_name,argument_str,'.xml']); 
    
    % write file list
    if ~exist([voc_dir,'ImageSets/Main/'], 'dir')
        mkdir([voc_dir,'ImageSets/Main/']);
    end
    fid = fopen([voc_dir,'ImageSets/Main/filelist.txt'], 'a');
    fprintf(fid, [img_name,argument_str,'\n']);
    fclose(fid);
end