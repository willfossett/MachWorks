classdef P1000 < JetCatEngine

    properties (SetAccess = public, GetAccess = public)

    end

    methods (Access = public)
        function this = P1000()
            this@JetCatEngine('P1000');
            this.PressureRatio = 4;
            jetADensity = 0.804; % kg/L
            this.AirMassFlowMax = 1.8;
            this.FuelConsumptionMax = 2900/1000 * jetADensity / 3600; % kg/s
            this.FuelConsumptionMin = 5500/1000 * jetADensity / 3600;
            this.Mass = 11000/1000; % kg
            this.MinRPM = 19000; 
            this.MaxRPM = 615000; 
            this.MinThrust = 45; % N
            this.MaxThrust = 11000; % N
            this.SFC = 0.127; % kg/N/h 
            this.Pi_d = 0.95;
        end

    end

end