function lines = pext( source , str1 , off1 , str2 , off2 , KDr , unit )

str1_i = regexp( source , str1 ) ; %  may have multple return for radii
str2_i = regexp( source , str2 ) ;

if numel( str1_i ) > 1
    for i = 1 : numel( str1_i ) - 1
        srt1_s{i} = source(str1_i(i)+numel(str1)+off1:str1_i(i+1)+off2);
        srt1_s{i} = strrep(srt1_s{i},'(','');
        srt1_s{i} = strrep(srt1_s{i},',','');
        srt1_s{i} = strrep(srt1_s{i},')',' 0');
        
        str1_p{i} = textscan(srt1_s{i},'%d');
        str1_p{i} = str1_p{i}{1};
    end
    i = i + 1;
else
    i = 1;
end
    
srt1_s{i} = source(str1_i(i)+numel(str1)+off1:str2_i+off2);
srt1_s{i} = strrep(srt1_s{i},'(','');
srt1_s{i} = strrep(srt1_s{i},',','');
srt1_s{i} = strrep(srt1_s{i},')',' 0');

str1_p{i} = textscan(srt1_s{i},'%f');
str1_p{i} = str1_p{i}{1};

n_l = 0; % n of prev lines
for j = 1 : i
    for i_l = 1 : numel( str1_p{j} ) / 3 - 1
        lines{n_l+i_l}.name = 'LINE' ;
        lines{n_l+i_l}.type = 110 ;
        lines{n_l+i_l}.p1 = unit * cast( str1_p{j}((i_l-1)*3+1:i_l*3) ,'like' , 0.1 ) ;
        lines{n_l+i_l}.p2 = unit * cast( str1_p{j}(i_l*3+1:(i_l+1)*3) ,'like' , 0.1 ) ;
        lines{n_l+i_l}.KDr = KDr ;
    end
    n_l = numel( lines ) ;
end













