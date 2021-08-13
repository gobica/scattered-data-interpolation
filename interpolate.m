function [] = interpolate (input, output, method, parameter, min_x, min_y, min_z, max_x, ...
max_y, max_z, res_x, res_y, res_z)

    fileID = fopen(input,'r');
    formatSpec = '%f';
    sizeA = [4 Inf];
    A = fscanf(fileID,formatSpec, sizeA); 
    A = A';
    spatial_coordinates = A(1:end,1:3);
    function_values = A(:, end);

 
    %calculate steps 
    step_z = (max_z - min_z) / (res_z-1); 
    step_y = (max_y - min_y) / (res_y-1); 
    step_x = (max_x - min_x) / (res_x-1); 
    idx = 1;

    % this is just a bad code for a counter (to allocate array)
    predctiors_count = res_x*res_y*res_z;
    %prelocated for speed
    predicted_coordinates = zeros(predctiors_count,3);

  
    for x = min_x:step_x:max_x
        for y = min_y:step_y:max_y
            for z = min_z:step_z:max_z
                predicted_coordinates(idx, :) = [x, y, z];
                idx = idx + 1;
            end
        end
    end

    Q = size(predicted_coordinates,1); % Number of interpolation points
    
    %pick method
    if method=="basic"
        interpolated_values = basic (spatial_coordinates,function_values, ...
        predicted_coordinates, parameter);
    end
    
     if method=="modified"
        interpolated_values = modified (spatial_coordinates,function_values, ...
        predicted_coordinates, parameter);
    end


    fileID = fopen(output,'w');
    for l = 1:Q
        fprintf  (fileID,'%f \n', interpolated_values(l));
    end
end