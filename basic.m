function interpolated_values = basic(spatial_coordinates,function_values, ...
    predicted_coordinates, p)
  
    Q = size(predicted_coordinates,1); % Number of interpolation points
    % Inverse distance weight output
    interpolated_values = zeros(Q,1);

    x_vector = spatial_coordinates(: , 1); 
    y_vector = spatial_coordinates(:, 2);
    z_vector = spatial_coordinates(:, 3);

    for i = 1:Q
        xp = predicted_coordinates(i , 1); 
        yp = predicted_coordinates(i, 2);
        zp = predicted_coordinates(i, 3);
        %caluclate distance
        distance = sqrt((x_vector-xp).^2 + (y_vector-yp).^2 + (z_vector-zp).^2);
        % caluclate weights
        w = 1./(distance.^p);
        %Interpolation
        interpolated_values(i) = sum(w.*function_values)/sum(w);
    end
end