set(0,'DefaultFigureWindowStyle','docked')

nx = 100;
ny = 100;
ni = 5000;
v = zeros(nx,ny);

% Set initial boundary conditions
v(:,1) = 1;  % Left boundary
v(:,end) = 0; % Right boundary

for k=1:ni
    % Apply insulating boundary conditions on top and bottom (not necessary to set)

    % Update potential using box filtering
    v = imboxfilt(v, 3);

    % Apply boundary conditions after filtering
    v(:,1) = 1;  % Left boundary
    v(:,end) = 0; % Right boundary

    % Visualize every few iterations
    if mod(k,10) == 0
        surf(v')
        pause(0.05)
    end
end

% Calculate electric field
[Ex,Ey] = gradient(v);

% Plot electric field
figure
quiver(-Ey',-Ex',1)
