function interpolated_values = modified(spatial_coordinates,function_values, ...
    predicted_coordinates, R)
   
    %create and draw OcTree
    OT = OcTree(spatial_coordinates,'binCapacity',100);
    %draw octree
    figure
    boxH = OT.plot;
    cols = lines(OT.BinCount);
    doplot3 = @(p,varargin)plot3(p(:,1),p(:,2),p(:,3),varargin{:});

    
    for i = 1:OT.BinCount
    set(boxH(i),'Color',cols(i,:),'LineWidth', 1+OT.BinDepths(i))
    doplot3(spatial_coordinates(OT.PointBins==i,:),'.','Color',cols(i,:))
    end
    axis image, view(3)

    Q = size(predicted_coordinates,1); % Number of interpolation points
    % Inverse distance weight output
    interpolated_values = zeros(Q,1);
    
    bins_count = OT.BinCount ();
    
    %create cell array 
    bin_matrixes_x = cell(bins_count, 1);
    bin_matrixes_y = cell(bins_count, 1);
    bin_matrixes_z = cell(bins_count, 1);
    function_values_bin = cell(bins_count, 1);
    %create a matrix for each bin which contains all points in this bin.
    N = size(spatial_coordinates,1); 
    for i = 1 : N
        xyz = spatial_coordinates(i ,:  );
        x = spatial_coordinates(i , 1); 
        y = spatial_coordinates(i, 2);
        z = spatial_coordinates(i, 3);
        
        bin_i = OT.query(xyz);
        %add in cell point in the end
        bin_matrixes_x{bin_i} = [bin_matrixes_x{bin_i}, x];
        bin_matrixes_y{bin_i} = [bin_matrixes_y{bin_i}, y];
        bin_matrixes_z{bin_i} = [bin_matrixes_z{bin_i}, z];
        function_values_bin{bin_i} = [function_values_bin{bin_i}, function_values(i)];

    end

    for i = 1:Q
        % point to be interpelated
        xp = predicted_coordinates(i , 1); 
        yp = predicted_coordinates(i, 2);
        zp = predicted_coordinates(i, 3);     
        
        bin_index = OT.query([xp, yp, zp]);
        x_vector = bin_matrixes_x{bin_index};
        y_vector = bin_matrixes_y{bin_index};
        z_vector = bin_matrixes_z{bin_index};
        
        % if inece == same indance calulate nearest neighbourR
        %caluclate distance
        distance = sqrt((x_vector-xp).^2 + (y_vector-yp).^2 + (z_vector-zp).^2);
        
        % caluclate weights - modefied shepard's method
        w = ((max(0, R - distance))./(R * distance)).^2 ;
        
        %Interpolation
        interpolated_values(i) = sum(w.*function_values_bin{bin_index})/sum(w);
    end
end