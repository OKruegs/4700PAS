% Define grid size
nx = 50;     % Number of grid points 
ny = 50;     % Number of grid points 

% Initialize matrices
V = zeros(nx,ny);       % Matrix to store electric potential 
G = sparse(nx*ny,nx*ny);% Matrix represents system of equations

%Represents any included obstacles or materials
Inclusion = 0;

% Populate the matrix G
for i = 1:nx
    for j = 1:ny
        n = j + (i - 1) * nx; %2D to 1D 
        
        % Diagonal elements of G 
        if i > 10 && i < 20 && j > 10 && j < 20
            G(n,n) = -2 - Inclusion; % Specified region
        else
            G(n,n) = -4 - Inclusion; % Outside the specified region
        end
        
        % Neighboring elements
        if i > 1
            G(n,nx*(i-2)+j) = 1; % left neighbour
        else
            % Boundary condition at i=1
            G(n,n) = G(n,n) - 1; % Modify diagonal element
        end
        if i < nx
            G(n,nx*i+j) = 1; % right neighbour
        else
            % Boundary condition at i=nx
            G(n,n) = G(n,n) - 1;
        end
        if j > 1
            G(n,n-1) = 1; % lower neighbour
        else
            % Boundary condition at j=1
            G(n,n) = G(n,n) - 1;
        end
        if j < ny
            G(n,n+1) = 1; % upper neighbour
        end

        % Set boundary conditions to 0
        if i == 1 || i == nx || j == 1 || j == ny
            G(n,:) = 0; % Set the entire row to 0
            G(n,n) = 1; % Set the diagonal element to 1
        end
    end
end

% Plot of the matrix G
figure('name', 'Matrix')
spy(G)

% Calculate eigenvalues and eigenvectors
nmodes = 20;
[E,D] = eigs(G,nmodes,'SM');

% Plot eigenvalues
figure('name', 'Eigenvalues')
plot(diag(D),'*');

% Plot modes
np = ceil(sqrt(nmodes));
figure('name','Modes')
for k = 1:nmodes
    M = E(:,k);
    for i = 1:nx
        for j = 1:ny
            n = j + (i - 1) * nx; % 2D to 1D index
            V(i,j) = M(n); % Values from eigenvector
        end
    end
    subplot(np,np,k), surf(V,'LineStyle','none')
    title(['Ev = ' num2str(D(k,k))]) 
end
