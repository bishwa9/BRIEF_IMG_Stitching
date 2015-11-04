function locs_out = getLocalExtrema(DoG_P, DoG_L, P_C, th_c, th_r)
    max = imregionalmax(DoG_P, 26);
    [r,c,l] = ind2sub(size(max),find(max == 1));
    min = imregionalmin(DoG_P, 26);
    [r_,c_,l_min] = ind2sub(size(min),find(min == 1));
    l_ = [r c l;
          r_ c_ l_min];
    N = 0;
    for i = 1:size(l_,1)
        location = l_(i,:);
        row = location(1,1);
        col = location(1, 2);
        scale = location(1,3);
        if( ( abs( DoG_P( row, col, scale ) ) > th_c ) ...
            & (  (P_C(row, col, scale)  < th_r)  & ...
            (P_C(row, col, scale)  > 0) )  )
            N = N+1;
            locs(N, :) = location;
            locs(N, 3) = DoG_L(scale);
        end
    end
    locs_out = locs;
    locs_out(:,1) = locs(:,2);
    locs_out(:,2) = locs(:,1);
end