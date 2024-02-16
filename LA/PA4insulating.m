set(0,'DefaultFigureWindowStyle','docked')

nx = 100;
ny = 100;
ni = 5000;
v = zeros(nx,ny);

% Boundary Conditions
%Left 1, Right 0, top bottom insulating
v(:,1) = 1;  % Left boundary
v(:,end) = 0; % Right boundary

SidesToZero = 0;

for k=1:ni
    %previous iteration values
    v_old = v;

    % Iteration
    %starting loops 2:n-1 so we ignore the boundary points, and only
    %iterate interior (exclude border)
    for m = 2:nx-1
        for n = 2:ny-1
            %Laplace equation
            v(m,n) = 0.25 * (v_old(m-1,n) + v_old(m+1,n) + v_old(m,n-1) + v_old(m,n+1));
        end
    end

    %Boundary conditions (insulating on top and bottom)
    v(1,:) = v(2,:);     % Top boundary
    v(end,:) = v(end-1,:); % Bottom boundary
    %to make insulating we need to ensure no flow of potential, so we set
    %the derivative dv/dy to zero

    %50 iteration pause
    if mod(k,50) == 0
        surf(v')
        pause(0.05)
    end
end

% Calculate electric field
[Ex,Ey] = gradient(v);

% Plot electric field
figure
quiver(-Ey',-Ex',1)
