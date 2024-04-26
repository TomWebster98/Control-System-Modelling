%% Series Hybrid Electric Vehicle Supervisory Control Strategy Model

% Control strategy implementation with the objective of maximum efficiency

%% Read Laptime Simulation Data

Cadwell_BattPower = readtable("Battery_Power_Cadwell.csv");

%% Define ICE Parameters

P_psMax = 121;  % kW
P_psOpt = 121;   % kW

%% Define Battery/Motor Parameters

P_ssMax = 650; % kW

SOCu = 1;  % Upper SOC Limit
SOCl = 0.8;  % Lower SOC Limit

SOC_initial = 1;

GenCon_Efficiency = 0.76; % Ratio of generator output into battery charge

% BatWght = 250; % kg
% BatEnrgyDensity = 160; % Wh/kg
BatCapacity = 8900; %BatWght * BatEnrgyDensity; %Wh
BatCapacity_kWs = (BatCapacity*60*60)/1000;      %kWs

%% Thermostat Control Strategy Implementation

% Generate Demand Signal
% Prand = rand(1,10);
% Pdemand = zeros(1,100);
% 
% for i = 10:10:100
%     Pdemand(i) = Prand(i/10);
% end
% 
% while nnz(Pdemand) ~= length(Pdemand)
%     for i = 1:length(Pdemand)
%         if Pdemand(i) ~= 0 && Pdemand(i-1) == 0
%             Pdemand(i-1) = Pdemand(i);
%         end
%     end
% end
% Psignal = Pdemand .* (P_ssMax); % Power Demand kW

Psignal = Cadwell_BattPower{1:height(Cadwell_BattPower),"P_battery_kW"};
timeSignal = Cadwell_BattPower{1:height(Cadwell_BattPower),"Time"};
timeStep = Cadwell_BattPower{1:height(Cadwell_BattPower),"Time_step"};

% Initialise SOC and Power Output Arrays
SOC = [SOC_initial,zeros(1,length(Psignal)-1)];

P_PS = zeros(1,length(Psignal));
P_SS = zeros(1,length(Psignal));

% Define charging/discharging rates

%timePerStep = 1; % seconds between each Psignal input val
engine_hold = 0;

% Loop over Psignal and Calculate Power Split
for i = 1:length(Psignal)
    if SOC(i) >= 1
        SOC(i) = 1;
    elseif SOC(i) <= 0
        SOC(i) = 0;
    end

    if engine_hold == 1
        P_PS(i) = 0;
        P_SS(i) = Psignal(i);
        if SOC(i) <= 0.8*SOCu
            engine_hold = 0;
        end
    elseif SOC(i) <= SOCl
        P_PS(i) = P_psOpt;
        if Psignal(i) > 0.5*P_psOpt
            P_SS(i) = 0.4*P_psOpt;
        else 
            P_SS(i) = Psignal(i);
        end
    elseif SOC(i) > SOCl && SOC(i) < SOCu
        P_PS(i) = P_psOpt;
        P_SS(i) = Psignal(i);
    elseif SOC(i) >= SOCu && engine_hold ~= 1
        P_PS(i) = 0;
        P_SS(i) = Psignal(i);
        engine_hold = 1;
    end

    SOC(i+1) = SOC(i) + (((P_PS(i) * GenCon_Efficiency) - P_SS(i))*timeStep(i))/BatCapacity_kWs;

end

% Remove extra SOC value
SOC(end) = [];

% Calculate Power Share Factor u
u = P_PS ./ Psignal; % Ratio of power demand delivered by ICE.

%% Plot Results

% iterations = 1:length(Psignal);

figure(1)
plot(timeSignal,SOC.*100)
grid on
title('State of Charge')
xlabel('Time (s)')
ylabel('Battery % Charge')

figure(2)
plot(timeSignal,Psignal,"b--")
hold on
plot(timeSignal,P_PS)
plot(timeSignal,P_SS,"k:","LineWidth",1)
yline(P_psOpt,"k:")
yline(0,"k--")
hold off
title('Power Delivery')
xlabel('Time (s)')
ylabel('Power (kW)')
legend('Demand', 'ICE Delivery', 'Battery Delivery')

% figure(3)
% plot(iterations,u)
% hold on
% yline(1,"k:")
% hold off
% grid on
% title('Ratio of Power Demand Delivered by ICE')
% xlabel('Time Step')
% ylabel('Power Share Factor u')

