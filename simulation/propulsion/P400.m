classdef P400 < JetCatEngine

    properties (SetAccess = public, GetAccess = public)

    end

    methods (Access = public)
        function this = P400()
            this@JetCatEngine('P400');
            this.PressureRatio = 3.8;
            jetADensity = 0.804; % kg/L
            this.AirMassFlowMax = 0.67;
            this.FuelConsumptionMax = 1392/1000 * jetADensity / 3600; % kg/s
            this.FuelConsumptionMin = 200/1000 * jetADensity / 3600;
            this.Mass = 4010/1000; % kg
            this.MinRPM = 30000; 
            this.MaxRPM = 98000; 
            this.MinThrust = 14; % N
            this.MaxThrust = 425; % N
            this.SFC = 0.157; % kg/N/h 
            this.Pi_d = 0.95;
        end

    end

end