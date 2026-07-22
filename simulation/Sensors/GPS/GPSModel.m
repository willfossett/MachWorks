classdef GPSModel < SensorModel

    properties (SetAccess = public, GetAccess = public)
        PositionSigma = double.empty(3,0); % position error sigma
        VelocitySigma = double.empty(3,0);
        StopGPSDistance = double.empty(1,0); % distance at which to stop GPS
    end

    methods (Access = public)

        function this = GPSModel()
            this@SensorModel('GPS')
            this.ValidTimeRange = [0, inf]; % gps between 0 and N sec
            this.StopGPSDistance = 0 * 1852; % stop GPS at N nmi, nmi to m
            this.PositionSigma = [1 1 1];
            this.VelocitySigma = [0.1 0.1 0.1];
            this.UpdateRate = 1; % update every n seconds
            H = zeros(6, 15);
            H(1:3, 1:3) = eye(3, 3);
            H(4:6, 4:6) = eye(3, 3);
            this.Hmatrix = H;
            this.Rmatrix = this.calculateRMatrix();
        end

        %% Getters

        %% Setters

        %% Helpers
        function position = estimatePosition(this, truePosECI)
            position = truePosECI + this.PositionSigma .* randn(1,3);
        end

        function velocity = estimateVelocity(this, trueVelECI)
            velocity = trueVelECI + this.VelocitySigma .* randn(1,3);
        end

        function innovation = calculateInnovation(~, measPosECI, estPosECI, measVelECI, estVelECI)
            innovation = [measPosECI - estPosECI, measVelECI - estVelECI];
        end

        function Rmatrix = calculateRMatrix(this)
            Rmatrix = zeros(6, 6);
            Rmatrix(1:3, 1:3) = diag(this.PositionSigma.^2);
            Rmatrix(4:6, 4:6) = diag(this.VelocitySigma.^2);
        end

        function useGPS = checkGPSRange(this, vehPos, tgtPos)
            dist = norm(tgtPos - vehPos);
            if dist > this.StopGPSDistance
                useGPS = true;
            else
                useGPS = false;
            end
        end

    end

end