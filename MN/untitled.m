X=9;
Y=7;

powerup = 0;

Xg1=20;
Yg1=5;

Xg2=90;
Yg2=1;

Xg3=1;
Yg3=100;

Xg4=12;
Yg4=8;

Xc=10; %cherry x,y, on the board
Yc=10;

Cherry = 1;


R1 = X-Xg1;
L1 = -R1;
D1 = Y-Yg1;
U1 = -D1;

R2 = X-Xg2;
L2 = -R2;
D2 = Y-Yg2;
U2 = -D2;

R3 = X-Xg3;
L3 = -R3;
D3 = Y-Yg3;
U3 = -D3;

R4 = X-Xg4;
L4 = -R4;
D4 = Y-Yg4;
U4 = -D4;

Rc = -(X-Xc);
Lc = -Rc;
Dc = -(Y-Yc);
Uc = -Dc;


I=3;
if Cherry == 1
    Ic = 2;
else
    Ic = 0;
end

if powerup == 1
R1 = -R1;
L1 = -L1;
D1 = -D1;
U1 = -U1;

R2 = -R2;
L2 = -L2;
D2 = -D2;
U2 = -U2;

R3 = -R3;
L3 = -L3;
D3 = -D3;
U3 = -U3;

R4 = -R4;
L4 = -L4;
D4 = -D4;
U4 = -U4;
end


IR = I*W(R1) + I*W(R2) + I*W(R3) + I*W(R4) + Ic*W(Rc);
IL = I*W(L1) + I*W(L2) + I*W(L3) + I*W(L4) + Ic*W(Lc);
IU = I*W(U1) + I*W(U2) + I*W(U3) + I*W(U4) + Ic*W(Uc);
ID = I*W(D1) + I*W(D2) + I*W(D3) + I*W(D4) + Ic*W(Dc);

b = 0.2;
c = -65;
q = b*c;
T = 200;  % Total simulation time (milliseconds)

% Initial conditions v, u, dv, du, Iin, Iout, spike timer
IC1 = [c q 0 0 IL 0 0];
IC2 = [c q 0 0 IR 0 0];
IC3 = [c q 0 0 IU 0 0];
IC4 = [c q 0 0 ID 0 0];

values = zeros(4,7);

values(1,:) = IC1(1,:);
values(2,:) = IC2(1,:);
values(3,:) = IC3(1,:);
values(4,:) = IC4(1,:);

vv = zeros(4,T); 



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


a = sum(vv,2);
if (a(1,1)>a(2,1))&&(a(1,1)>a(3,1))&&(a(1,1)>a(4,1))
    output = 3; %assuming LEFT is 3
elseif (a(2,1)>a(1,1))&&(a(2,1)>a(3,1))&&(a(2,1)>a(4,1))
    output = 2; %assuming RIGHT is 2
elseif (a(3,1)>a(1,1))&&(a(3,1)>a(2,1))&&(a(3,1)>a(4,1))
    output = 1; %assuming UP is 1
elseif (a(4,1)>a(1,1))&&(a(4,1)>a(2,1))&&(a(4,1)>a(3,1))
    output = 4; %assuming DOWN is 4
elseif output == 10
    output = 10;
end


output

function [vf,uf,dvf,duf,Ii,Iout,st] = neuron(x)

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
            vf = c;  % Reset membrane potential
            uf = uf + d;  % Reset recovery variable
            st = 40;
        end
        
        if st>0
            st = st-1;
            Iout = 10;
        else
            Iout = 0;
        end
       
             
end

function [weight] = W(x)
    if x>0
        weight = (-x+160)/10;
    else
        weight = 0;
    end
end