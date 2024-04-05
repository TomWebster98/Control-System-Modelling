%% Series Hybrid Electric Vehicle Supervisory Control Strategy Model

% Control strategy implementation with the objective of maximum efficiency

%% Define ICE Parameters

P_psMax = 170;  % kW
P_psMin = 5;   % kW
P_psOpt = 170;   % kW

%% Define Battery/Motor Parameters

P_ssMax = 288; % kW

SOCu = 0.85;  % Upper SOC Limit
SOCl = 0.45;  % Lower SOC Limit

SOC_initial = 0.5;

GenCon_Efficiency = 0.4; % Ratio of generator output into battery charge

% BatWght = 250; % kg
% BatEnrgyDensity = 160; % Wh/kg
BatCapacity = 52000; %BatWght * BatEnrgyDensity; %Wh
BatCapacity_kWs = (BatCapacity*60*60)/1000;      %kWs

%% OPSS Control Strategy

% Generate Demand Signal
Prand = rand(1,10);
Pdemand = zeros(1,100);

for i = 10:10:100
    Pdemand(i) = Prand(i/10);
end

while nnz(Pdemand) ~= length(Pdemand)
    for i = 1:length(Pdemand)
        if Pdemand(i) ~= 0 && Pdemand(i-1) == 0
            Pdemand(i-1) = Pdemand(i);
        end
    end
end
Psignal = Pdemand .* (P_ssMax); % Power Demand kW

% Initialise SOC and Power Output Arrays
SOC = [SOC_initial,zeros(1,length(Psignal)-1)];

P_PS = zeros(1,length(Psignal));
P_SS = zeros(1,length(Psignal));

% Define charging/discharging rates

timePerStep = 100; % seconds between each Psignal input val

% Loop over Psignal and Calculate Power Split
for i = 1:length(Psignal)
    if SOC(i) >= 1
        SOC(i) = 1;
    elseif SOC(i) <= 0
        SOC(i) = 0;
    end
    if SOC(i) <= SOCl 
        if Psignal(i) > P_psMax
            P_PS(i) = P_psMax;
        elseif Psignal(i) < P_psOpt
            P_PS(i) = P_psOpt;
            P_SS(i) = Psignal(i) - P_PS(i);
        else
            P_PS(i) = Psignal(i);
            P_SS(i) = 0;
        end
    elseif SOC(i) > SOCl && SOC(i) < SOCu
        if Psignal(i) > P_psMin && Psignal(i) < P_ssMax + P_psOpt
            P_PS(i) = P_psOpt;
            P_SS(i) = Psignal(i) - P_PS(i);
        elseif Psignal(i) > P_ssMax + P_psOpt
            P_SS(i) = P_ssMax;
            P_PS(i) = Psignal(i) - P_SS(i);
        end
    elseif SOC(i) >= SOCu
        if Psignal(i) > P_ssMax
            P_SS(i) = P_ssMax;
            P_PS(i) = Psignal(i) - P_SS(i);
        else
            P_PS(i) = P_psOpt;
            P_SS(i) = Psignal(i) - P_PS(i);
        end
    end    
    if P_SS(i) <= 0
        SOC(i+1) = SOC(i) + (-1*(P_SS(i) * GenCon_Efficiency)*timePerStep)/BatCapacity_kWs;
    else
        SOC(i+1) = SOC(i) - (0.1*P_SS(i)*timePerStep)/BatCapacity_kWs; 
    end

end

% Remove extra SOC value
SOC(end) = [];

% Calculate Power Share Factor u
u = P_PS ./ Psignal; % Ratio of power demand delivered by ICE.

%% Plot Results

iterations = 1:length(Psignal);

figure(1)
plot(iterations,SOC.*100)
grid on
title('State of Charge')
xlabel('Time Step')
ylabel('Battery % Charge')

figure(2)
plot(iterations,Psignal)
hold on
plot(iterations,P_PS)
plot(iterations,P_SS)
yline(P_psOpt,"k:")
yline(0,"k--")
hold off
title('Power Delivery')
xlabel('Time Step')
ylabel('Power (kW)')
legend('Demand', 'ICE Delivery', 'Battery Delivery')

figure(3)
plot(iterations,u)
hold on
yline(1,"k:")
hold off
grid on
title('Ratio of Power Demand Delivered by ICE')
xlabel('Time Step')
ylabel('Power Share Factor u')

