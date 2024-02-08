set(0,'DefaultFigureWindowStyle','docked')

nx = 100;
ny = 100;
ni = 10000;
v = zeros(nx,ny);

% Boundary Conditions
v(:,1) = 1;  % Left boundary
v(:,end) = 1; % Right boundary
v(1,:) = 0; %v(2,:);   % Top boundary
v(end,:) = 0; %v(end-1,:); % Bottom boundary

SidesToZero = 1;

for k=1:ni
    %previous iteration values
    v_old = v;

    % Iteration
    for m = 2:nx-1
        for n = 2:ny-1
            %Laplace equation
            v(m,n) = 0.25 * (v_old(m-1,n) + v_old(m+1,n) + v_old(m,n-1) + v_old(m,n+1));
        end
    end


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