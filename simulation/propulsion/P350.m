classdef P350 < JetCatEngine

    properties (SetAccess = public, GetAccess = public)

    end

    methods (Access = public)
        function this = P350()
            this@JetCatEngine('P350');
            this.PressureRatio = 3.8;
            jetADensity = 0.804; % kg/L
            this.AirMassFlowMax = 0.65;
            this.FuelConsumptionMax = 1185/1000 * jetADensity / 3600; % kg/s
            this.FuelConsumptionMin = 148/1000 * jetADensity / 3600;
            this.Mass = 2890/1000; % kg
            this.MinRPM = 30000; 
            this.MaxRPM = 105000; 
            this.MinThrust = 15.5; % N
            this.MaxThrust = 360; % N
            this.SFC = 0.158; % kg/N/h 
            this.Pi_d = 0.95;
        end

    end

end