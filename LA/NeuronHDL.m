function output = detect_direction(X, Y, Xg, Yg)
    % Define constants
    I = 10;
    b = 0.2;
    c = -65;
    q = b*c;
    T = 200;  % Total simulation time (milliseconds)

    % Calculate movement direction
    R = X - Xg;
    L = -R;
    U = -Y + Yg;
    D = -U;

    % Calculate weights
    IR = I * W(R);
    IL = I * W(L);
    IU = I * W(U);
    ID = I * W(D);

    % Initial conditions v, u, dv, du, Iin, Iout, spike timer
    IC1 = [c q 0 0 IL 0 0];
    IC2 = [c q 0 0 IR 0 0];
    IC3 = [c q 0 0 IU 0 0];
    IC4 = [c q 0 0 ID 0 0];

    values = zeros(4, 7);
    values(1,:) = IC1(1,:);
    values(2,:) = IC2(1,:);
    values(3,:) = IC3(1,:);
    values(4,:) = IC4(1,:);

    vv = zeros(4, T); 

    % Simulation loop
    for i = 1:T 
        [vt, ut, dvt, dut, It, Iot, st] = neuron(values(1,:));
        values(1,:) = [vt, ut, dvt, dut, It, Iot, st];
        if values(1,1) > 0
            vv(1,i) = 1;
        end

        [vt, ut, dvt, dut, It, Iot, t] = neuron(values(2,:));
        values(2,:) = [vt, ut, dvt, dut, It, Iot, t];
        if values(2,1) > 0
            vv(2,i) = 1;
        end

        [vt, ut, dvt, dut, It, Iot, t] = neuron(values(3,:));
        values(3,:) = [vt, ut, dvt, dut, It, Iot, t];
        if values(3,1) > 0
            vv(3,i) = 1;
        end

        [vt, ut, dvt, dut, It, Iot, t] = neuron(values(4,:));
        values(4,:) = [vt, ut, dvt, dut, It, Iot, t];
        if values(4,1) > 0
            vv(4,i) = 1;
        end
    end

    % Determine the predominant direction
    a = sum(vv,2);
    if (a(1,1)>a(2,1))&&(a(1,1)>a(3,1))&&(a(1,1)>a(4,1))
        output = 3; % Left
    elseif (a(2,1)>a(1,1))&&(a(2,1)>a(3,1))&&(a(2,1)>a(4,1))
        output = 2; % Right
    elseif (a(3,1)>a(1,1))&&(a(3,1)>a(2,1))&&(a(3,1)>a(4,1))
        output = 1; % Up
    elseif (a(4,1)>a(1,1))&&(a(4,1)>a(2,1))&&(a(4,1)>a(3,1))
        output = 4; % Down
    end
end

function [vf,uf,dvf,duf,Ii,Iout, st] = neuron(x)
    a = 0.02;
    b = 0.2;
    c = -65;
    d = 8;
    dtf = 0.1;
    v_threshold = 30;

    vf = x(1,1);
    uf = x(1,2);
    Ii = x(1,5);
    st = x(1,7);

    dvf = (0.04 * vf^2 + 5 * vf + 140 - uf + Ii) * dtf;
    duf = (a * (b * vf - uf)) * dtf;
    vf = vf + dvf;
    uf = uf + duf;

    if vf >= v_threshold         
        vf = c;
        uf = uf + d;
        st = 40;
    end

    if st > 0
        st = st - 1;
        Iout = 10;
    else
        Iout = 0;
    end
end

function [weight] = W(x)
    if x > 0
        weight = (-x + 160) / 10;
    else
        weight = 0;
    end
end
