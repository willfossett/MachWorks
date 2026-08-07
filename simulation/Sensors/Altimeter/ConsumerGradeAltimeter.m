classdef ConsumerGradeAltimeter < Altimeter

    properties (SetAccess = public, GetAccess = public)

    end


    methods (Access = public)

        function this = ConsumerGradeAltimeter()
            this.AltitudeSigma = 4;
            this.setRMatrix();
        end
    end


end