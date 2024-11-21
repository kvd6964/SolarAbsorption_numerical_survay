% Numerical survey for solar absorption and optimal tilt angle analysis

% Parameters and location settings
latitude = 35.9; % Latitude of the study location (Karaj, Iran)
solar_constant = 945; % Average solar constant (W/m^2)
hours = 10.5:1:16.5; % Active hours for solar measurement (10:30 AM to 4:30 PM)
inclination_angles = 10:10:50; % Tested inclination angles (degrees)
efficiency = 0.33; % Estimated solar still efficiency
absorptivity_glass = 0.85; % Glass cover absorptivity factor

% Seasonal settings
day_of_year = 172; % For example June 21 (Summer Solstice)
declination = 23.45 * sind((360 / 365) * (284 + day_of_year)); % Solar declination angle (degrees)

% Arrays to store absorption data
total_absorption = zeros(1, length(inclination_angles)); % Total absorbed radiation (W/m^2)

% Main loop: iterate over inclination angles
for i = 1:length(inclination_angles)
    angle = inclination_angles(i); % Current tilt angle
    daily_absorption = 0; % Reset daily absorption for this angle
    
    % Loop through specified hours of the day
    for h = 1:length(hours)
        hour_angle = 15 * (hours(h) - 12); % Hour angle relative to noon (degrees)
        
        % Solar altitude angle (above horizon)
        altitude_angle = asind(sind(latitude) * sind(declination) + ...
            cosd(latitude) * cosd(declination) * cosd(hour_angle));
        
        % Compute radiation if altitude is above horizon
        if altitude_angle > 0
            radiation = solar_constant * (sind(altitude_angle) * cosd(angle) + ...
                cosd(altitude_angle) * sind(angle));
        else
            radiation = 0; % No radiation for negative altitude angles
        end
        
        % Accumulate absorbed radiation
        absorption = absorptivity_glass * radiation;
        daily_absorption = daily_absorption + absorption;
    end
    
    % Store total absorbed radiation for the current angle
    total_absorption(i) = daily_absorption;
end

% Determine the optimal inclination angle
[~, optimal_index] = max(total_absorption);
optimal_angle = inclination_angles(optimal_index);

% Display results
disp('Total Absorption for Different Inclination Angles (W/m^2):');
for i = 1:length(inclination_angles)
    fprintf('Inclination Angle: %d°, Total Absorption: %.2f W/m^2\n', ...
        inclination_angles(i), total_absorption(i));
end
fprintf('Optimal Inclination Angle for Maximum Absorption: %d°\n', optimal_angle);

