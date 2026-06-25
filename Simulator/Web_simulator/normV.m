function Y = normV( X )
for i = 1 : numel( X(:,1) )
    Y(i) = norm( X(i,:) ) ;
end