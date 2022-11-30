close all;
clearvars;
delete(timerfindall);
SetupLidar;
addpath(genpath('..'));
sp = serial_port_start('COM3');
pioneer_init(sp);

figure(1)
hold on;
axis([-1 15 -1 15]);
daspect([1 1 1]);


%% Inicialização
Odometria = [];
Sonares = [];
Laser = [];
Doors =[];
%% Construção da trajetoria
xinicial = 3.3;
yinicial = 3.5;
lado = 14.2;
Y1 = [ 0*ones(1,5) linspace(0.5,yinicial-0.2,5)];
X1 = [ linspace(0,2.8,5) (xinicial-0.2)*ones(1,5)];
Y2 = [yinicial*ones(1,20), linspace(yinicial, lado+yinicial, 20), (lado+3.8)*ones(1,20) linspace(lado+3.8, 3.8, 20)];
X2 = [linspace(xinicial, lado+xinicial, 20) (lado+xinicial)*ones(1,20) linspace(lado+xinicial, xinicial, 20) xinicial*ones(1,20)]; 
X = [X1 X2 X1(length(X1):-1:1)];
Y = [Y1 Y2 Y1(length(Y1):-1:1)];
%% Ganhos do controlador
K1=2;
K2=0.2;
K3=2.5;
%% Timers
controling=true;
tmr = timer('TimerFcn', 'controling=true;');
tmr.Period = 0.4;
tmr.ExecutionMode = 'fixedRate';
start(tmr);
sonar=false;
tmr2 = timer('TimerFcn', 'sonar=true;');
tmr2.Period = 0.6;
tmr2.ExecutionMode = 'fixedRate';
start(tmr2);
scan=false;
tmr = timer('TimerFcn', 'scan=true;');
tmr.Period = 0.2;
tmr.ExecutionMode = 'fixedRate';
start(tmr3);

%% Inicialização de variáveis
k=1; %Contador de pontos de referência
thd = 0; %Threshold do lado direito
the = 0; %Threshold do lado esquerdo
FC = 15; %Fator de correção
vmax = 0.15; %Velocidade máxima
ODOM2RAD = pi/2048; %Fator de conversão da leitura da odometria para radianos
while 1
    if(sonar)
        aux =  pioneer_read_sonars();
        Sonares = [Sonares aux'];
        sonar=false;
        
        [X, Y]=correct_trajectory(Sonares, X, Y, Odometria(3,size(Odometria,2)), FC, thd, the);
    end
    if(controling)
        odom=pioneer_read_odometry()';
        Odometria = [Odometria odom];
        [v, w, e] = controlo(X(k), Y(k), odom(1)/1000, odom(2)/1000 , ODOM2RAD*odom(3) , K1, K2, K3, vmax);
        w = round(rad2deg(w));
        v = round(v*1000);
        controling=false;
        pioneer_set_controls(sp, v, w);
    end
    if(scan)
        scan = LidarScan(lidar);
        Laser = [Laser scan']; 
        v=0;
        for a=linspace(-120,120,682);
           v=v+1;
           reconstruct(:,v)=[cos(deg2rad(a)) ; sin(deg2rad(a))]*scan(v);
        end
        
        left_door=detect_left(scan, reconstruct(1,:), reconstruct(2,:));
        if(left_door)
            Doors=[Doors rotz(Odometria(3,size(Odmetria,2)))*left_door];
        end
        right_door=detect_right(scan, reconstruct(1,:), reconstruct(2,:));
        if(left_door)
            Doors=[Doors rotZ(Odometria(3,size(Odmetria,2)))*right_door+Odometria(1:2,size(Odmetria,2))];
        end        
    
    end
      
    %%Plots
    figure(1);
    clf;
    hold on;
    plot(Odometria(1,:)/1000, Odometria(2,:)/1000, 'r');
    plot(X,Y, '+');
    plot(Doors(1,:),Doors(2,:), 'ko');
    drawnow;
    
    if(e<0.4 )
        if(k~=length(X))
            k=k+1;
       else
            k=1;
        end
        controling=true;
        
        if (90 >= k && k >=14)
            vmax = 0.3;
        end
        
        if (90 >= k && k >=12)
            thd = 400;
            the = 700;
        end
        
        if (k>90)
            thd = 400;
            the = 400;
            vmax = 0.15;
        end
    end
    
end

    