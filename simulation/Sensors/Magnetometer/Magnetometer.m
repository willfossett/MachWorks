classdef Magnetometer < SensorModel
% Model for magnetometer class for heading update

    properties (SetAccess = public, GetAccess = public)
        HeadingSigma = double.empty(1,0); % heading angle uncertainty
    end

    methods (Access = public)

        function this = Magnetometer()
            this@SensorModel('Magnetometer')
        end

        %% Getters

        %% Setters

        %% Helpers
        function heading = estimateHeading(trueQuatECI2BDY, truePosECI, curTime)
            lla = eci2lla(truePosECI, curTime);
            dcmECI2ECEF = dcmeci2ecef('IAU-2000/2006', curTime);
            quatECI2ECEF = dcm2quat(dcmECI2ECEF);
            dcmECEF2NED = dcmecef2ned(lla(1), lla(2));
            quatECEF2NED = dcm2quat(dcmECEF2NED);
            quatNED2BDY = quatmultiply(quatmultiply(trueQuatECI2BDY, quatECI2ECEF), quatinv(quatECEF2NED));
            heading = quat2eul(quatNED2BDY);
            heading = heading(1);
        end

        function innovation = calculateInnovation(measHeading, estHeading)
            innovation = measHeading - estHeading;
        end

    end

end