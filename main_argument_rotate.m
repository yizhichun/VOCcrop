%voc_dir = 'F:\ImageDatabase\shipdetection\VOC\';
voc_dir = '/home/haoyou/ImageDB/VOCdevkit/';

xml_model_filepath = [voc_dir,'xml_model.xml'];

plane_dir = [voc_dir,'plane/'];
ship_dir = [voc_dir,'ship/'];
ship_plane_dir = [voc_dir,'ship_plane/'];

ship_dir_croped = [voc_dir,'ship_croped/'];
ship_dir_rotated = [voc_dir,'ship_rotated/'];

anno_subdir='Annotations/';
img_subdir='JPEGImages/';

% anno_subdir_croped='Annotations_croped/';
% img_subdir_croped='JPEGImages_croped/';
% 
% anno_subdir_rotated='Annotations_rotated/';
% img_subdir_rotated='JPEGImages_rotated/';

train_listfile = 'ImageSets/Main/trainval.txt';
test_listfile = 'ImageSets/Main/test.txt';

[path_list, name_list, xml_list] = LoadVOCList(ship_dir,train_listfile,anno_subdir,img_subdir);
% crop_SaveForList(path_list, name_list, xml_list,ship_dir_croped,xml_model_filepath);
rotate_Crope_Scale_SaveForList(path_list, name_list, xml_list,ship_dir_rotated,xml_model_filepath);

