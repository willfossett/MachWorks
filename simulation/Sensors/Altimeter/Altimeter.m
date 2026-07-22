classdef Altimeter < SensorModel

    properties (SetAccess = public, GetAccess = public)
        AltitudeSigma = zeros(1,0); % uncertainty in altitude measurement
    end

    methods (Access = public)

        function this = Altimeter()
            this@SensorModel('Altimeter')
            this.UpdateRate = 1; % 1 Hz by default
            this.AltitudeSigma = 0; % 0 meter uncertainty by default
            this.Hmatrix = zeros(1, 15); % needs to map our state to the measurement which is altitude agl/msl (radar/barometer)
            this.Rmatrix = 0; % 1x1
            % measurement model is: h(x) = eci2lla(x); dh/dx is not closed
            % form, so approximate using finite difference:
            % dh/dx = [h(x+eps)-h(x-eps)]/2eps then evaluate at xi
        end

        %% Getters

        %% Setters
        function this = setHMatrix(this, estPosECI, tUTC)
            this.Hmatrix = calculateHMatrix(this, estPosECI, tUTC);
        end

        function this = setRMatrix(this)
            this.Rmatrix = this.AltitudeSigma;
        end

        %% Helpers
        function altitude = estimateAltitude(this, posECI, curTimeJD)
            lla = eci2lla_fast(posECI, curTimeJD);
            altitude = lla(3)+this.AltitudeSigma*randn();
            this.setHMatrix(posECI, curTimeJD);
        end

        function Hmatrix = calculateHMatrix(~, estPosECI, curTimeJD)
            % use finite difference to calculate jacobian of how altitude
            % changes when position eci changes
            eps = 1e-3; % 1 mm perturbation is plenty for this resolution
            Hmatrix = zeros(1, 15);
            % dh/dX_i
            for ii=1:3
                upperECI = estPosECI;
                lowerECI = estPosECI;
                upperECI(ii) = estPosECI(ii) + eps;
                lowerECI(ii) = estPosECI(ii) - eps;
                upperLLA = eci2lla_fast(upperECI, curTimeJD);
                lowerLLA = eci2lla_fast(lowerECI, curTimeJD);
                Hmatrix(ii) = (upperLLA(3)-lowerLLA(3))/(2*eps); % slightly perturb specific axis and see how altitude changes
            end
        end

        function innovation = calculateInnovation(~, measurement, estPosECI, curTimeJD)
            lla = eci2lla_fast(estPosECI, curTimeJD);
            innovation = measurement - lla(3); 
        end

    end


end