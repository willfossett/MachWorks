classdef P500 < JetCatEngine

    properties (SetAccess = public, GetAccess = public)

    end

    methods (Access = public)
        function this = P500()
            this@JetCatEngine('P500');
            this.PressureRatio = 3.6;
            jetADensity = 0.804; % kg/L
            this.AirMassFlowMax = 0.9;
            this.FuelConsumptionMax = 1550/1000 * jetADensity / 3600; % kg/s
            this.FuelConsumptionMin = 300/1000 * jetADensity / 3600;
            this.Mass = 5400/1000; % kg
            this.MinRPM = 26000; 
            this.MaxRPM = 80000; 
            this.MinThrust = 28; % N
            this.MaxThrust = 492; % N
            this.SFC = 0.151; % kg/N/h 
            this.Pi_d = 0.95;
        end

    end

end