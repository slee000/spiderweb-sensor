function lines = pmat( source , KDr , unit )

n_l = 0; % n of prev lines
for i_l = 1 : numel( source(:,1) ) - 1
    lines{n_l+i_l}.name = 'LINE' ;
    lines{n_l+i_l}.type = 110 ;
        lines{n_l+i_l}.p1 = unit * [ source((i_l-1)+1,:) , 0 ]' ;
        lines{n_l+i_l}.p2 = unit * [ source(i_l+1,:) , 0 ]' ;
    lines{n_l+i_l}.KDr = KDr ;
end
n_l = numel( lines ) ;













