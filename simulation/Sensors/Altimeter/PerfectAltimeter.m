classdef PerfectAltimeter < Altimeter

    properties (SetAccess = public, GetAccess = public)

    end


    methods (Access = public)

        function this = PerfectAltimeter()
            this.AltitudeSigma = 0;
            this.setRMatrix(); % 1x1
        end
    end


end