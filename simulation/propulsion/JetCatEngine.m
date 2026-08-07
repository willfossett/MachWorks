classdef JetCatEngine < Propulsion

    properties (SetAccess = public, GetAccess = public)
       PressureRatio = double.empty(1,0);
       AirMassFlowMax = double.empty(1,0); % kg/s
       FuelConsumptionMax = double.empty(1,0); % ml/min
       FuelConsumptionMin = double.empty(1,0);
       Mass = double.empty(1,0);
       MinRPM = double.empty(1,0);
       MaxRPM = double.empty(1,0);
       MinThrust = double.empty(1,0);
       MaxThrust = double.empty(1,0);
       SFC = double.empty(1,0);
       Pi_d = double.empty(1,0); % pressure loss over inlet ratio
    end

    methods (Static, Access = protected)
        function simMode = getSimulateUsingImpl
            simMode = 'Interpreted execution';
        end
    end

    methods (Access = protected)

        function this = JetCatEngine(name)
            this@Propulsion(name)
        end

        function [Tnet, mdotAir, mdotFuel] = stepImpl(this, Mach, altitude, throttleRatio)
            Tnet = this.estimateNetThrust(altitude, Mach, throttleRatio);
            mdotAir = this.estimateAirMassFlow(altitude, Mach, throttleRatio);
            mdotFuel = this.estimateFuelMassFlow(altitude, Mach, throttleRatio);
        end

        function shaftRPM = estimateShaftRPM(this, throttleRatio)
            shaftRPM = this.MinRPM + throttleRatio * (this.MaxRPM - this.MinRPM);
        end

        function airMassFlow = estimateAirMassFlow(this, altitude, Mach, throttleRatio)
            rpm = this.estimateShaftRPM(throttleRatio);
            sigma = this.estimateCorrectedFlow(altitude, Mach);
            airMassFlow = sigma * this.AirMassFlowMax * rpm/this.MaxRPM;
        end

        function fuelMassFlow = estimateFuelMassFlow(this, altitude, Mach, throttleRatio)
            sigma = this.estimateCorrectedFlow(altitude, Mach);
            fuelMassFlow = this.FuelConsumptionMin + throttleRatio * (this.FuelConsumptionMax-this.FuelConsumptionMin);
            fuelMassFlow = sigma * fuelMassFlow;
        end
        
        function [Tt2, Pt2] = calculateInletConditions(this, altitude_m, Mach)
            coder.extrinsic('atmosisa');
            T0 = 0.0;
            P0 = 0.0;
            [T0, ~, P0, ~, ~] = atmosisa(altitude_m);
            gamma = 1.4;
            Tt2 = T0 * (1 + (gamma-1)/2*Mach^2);
            Pt0 = P0 * (1 + (gamma-1)/2*Mach^2)^(gamma/(gamma-1));
            Pt2 = this.Pi_d * Pt0;
        end

        function sigma = estimateCorrectedFlow(this, altitude, Mach)
            [Tt2, Pt2] = this.calculateInletConditions(altitude, Mach);
            Pref = 101325;
            Tref = 288.15;
            sigma = Pt2/Pref * sqrt(Tref/Tt2);
        end

        function T_SLS = estimateSLSThrust(this, throttleRatio)
            T_SLS = this.MinThrust + throttleRatio * (this.MaxThrust - this.MinThrust);
        end

        function T_net = estimateNetThrust(this, altitude, Mach, throttleRatio)
            sigma = this.estimateCorrectedFlow(altitude, Mach);
            T_SLS = this.estimateSLSThrust(throttleRatio);
            T_gross = sigma * T_SLS;
            mdotAir = this.estimateAirMassFlow(altitude, Mach, throttleRatio);
            coder.extrinsic('atmosisa');
            a = 0.0;
            [~, a, ~, ~, ~] = atmosisa(altitude);
            V = Mach * a;
            T_ram = mdotAir * V;
            T_net = T_gross - T_ram;
        end

    end

end