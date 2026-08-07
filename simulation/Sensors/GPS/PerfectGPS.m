classdef PerfectGPS < GPSModel
    
    properties (SetAccess = public, GetAccess = public)

    end

    methods (Access = public)

        function this = PerfectGPS()
            this.PositionSigma = [0 0 0];
            this.VelocitySigma = [0 0 0];
            this.Rmatrix = this.calculateRMatrix();
            this.ValidTimeRange = [0, inf];
        end

        %% Getters

        %% Setters

        %% Helpers

    end

end