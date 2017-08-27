function reStoreXML(root)
    out_root = [root(1:end-1),'_removero\'];
    disp(root);
    disp(out_root);
    
    numoffile=0;
    xmls = dir(fullfile( root, '*.xml'));
    for j=1:length(xmls)% The second dir
        if ~strcmp(xmls(j).name ,'.') && ~strcmp(xmls(j).name,'..')
                numoffile=numoffile+1;
                tempxml = xml2struct([root,xmls(j).name]);
                if mod(numoffile,100)==0
                    fprintf('Process the %d image:%s\n',numoffile, [root,xmls(j).name]);                    
                    disp(length(tempxml.annotation.object));                   
                end               
                
                %save to _removero directory
                struct2xml(tempxml,[out_root,xmls(j).name]);   
        end
    end
end
 