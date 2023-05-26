# High-Performance Motorsport Powertrain (Control) Modelling

*Project Start Date: May 2023*

Welcome to my High-Performance Motorsport Powertrain Modelling repository! This project aims to develop representations and models for high-performance motorsport powertrains, focusing on Formula 1 and British Touring Car (BTCC) hybrid engine modelling. The project utilises Python, Capella, MATLAB, and Simulink for modelling and simulation.

## Features

- Hybrid engine modelling for Formula 1 and British Touring Car Championship vehicles.
- Python-based implementation for engine mode control based on driver (user) input.
- Capella model diagrams to represent system functionality and data flow.
- MATLAB & Simulink models to simulate the control system response for engine mode inputs.
- Hybrid engine modelling for Formula 1 (F1) and British Touring Car Championship (BTCC)

## Formula 1 Powertrain:

**V6 Turbo Hybrid Power Unit:**
- Internal Combustion Engine - 1.6L V6 operating at a maximum of 15,000 RPM via the 4-stroke cycle, with 2 inlet and exhaust valves per cylinder.

- Turbocharger - Exhaust gas passes through a turbine, spinning a shaft connected to a compressor. Compressing air into the engine enables more combustion and boosts the overall power. Operatess at a maximum 100,000 RPM.

- Motor Generator Unit (Heat) - Waste heat energy drives the generator and produces electricity. Below certain thresholds, the MGU-H acts a a motor, providing additional power to alleviate turbo lag. For the 2026 regulation change, it is expected that this component will be removed.

- Motor Generator Unit (Kinetic) - Driving the generator using kinteic energy, which would have been dissipated as heat on the brakes, to assist in slowing the car, produces electricity which is later deployed to provide additional power under acceleration. Operates with maximum harvest and deployment of 2 MJ/lap and 4 MJ/lap respectively, with a power rating of 120 kW.

- Energy Storage Unit - 20 kg lithium ion battery stores electrical energy produced by the generator units, deployed via motors for additional power under acceleration. 

- Control Electronics - Receives sensor information inputs and calculates appropriate control response output signals to various components.

## BTCC Powertrain:

**Cosworth Hybrid System:**
- Internal Combustion Engine - 
- Hybrid System - 
