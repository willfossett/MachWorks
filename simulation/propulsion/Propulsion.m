classdef Propulsion < matlab.System
    % base propulsion model class

    properties (SetAccess = protected, GetAccess = public, Nontunable)
        SystemName = string.empty();
        ExecutionRate_sec = double.empty(1,0);
    end

    methods (Access = public)
        function this = Propulsion(name)
            this.SystemName = name;
            this.ExecutionRate_sec = 0.001;
        end

    end

end