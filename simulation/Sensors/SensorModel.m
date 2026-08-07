classdef SensorModel < handle
    % class to handle all our sensors

    properties (SetAccess = public, GetAccess = public)
        Name = string.empty(1,0);
        UpdateRate = double.empty(1,0); % rate that update is received at
        ValidTimeRange = double.empty(2,0); % range we can use sensor
        Hmatrix = double.empty(1,0); % Sensor specific measurement matrix
        Rmatrix = double.empty(1,0); % Sensor specific measurement noise matrix
    end

    methods (Access = public)

        function this = SensorModel(name)
            this.UpdateRate = 1; % 1 s by default
            this.ValidTimeRange = [0, inf]; % valid through whole flight by default
            this.Name = name;
        end

        %% Getters        
        function rate = getUpdateRate(this)
            rate = this.UpdateRate;
        end

        function Hmatrix = getHMatrix(this)
            Hmatrix = this.Hmatrix;
        end

        function Rmatrix = getRMatrix(this)
            Rmatrix = this.Rmatrix;
        end

        function range = getValidRange(this)
            range = this.ValidTimeRange;
        end

        %% Setters
        function this = setUpdateRate(this, rate)
            this.UpdateRate = rate;
        end

        function this = setValidRange(this, range)
            this.ValidTimeRange = range;
        end

        % function this = setHMatrix(this, mat)
        %     if size(mat) ~= size(this.Hmatrix)
        %         s = size(this.Hmatrix);
        %         error('Size of new H should agree with old size of %i by %i', s(1), s(2))
        %     end
        %     this.Hmatrix = mat;
        % end
        % 
        % function this = setRMatrix(this, mat)
        %     if size(mat) ~= size(this.Rmatrix)
        %         s = size(this.Hmatrix);
        %         error('Size of new R should agree with old size of %i by %i', s(1), s(2))
        %     end
        %     this.Rmatrix = mat;
        % end

        %% Helpers
        function isValid = checkValidMeasurement(this, simTime)
            isValid = (mod(simTime, this.UpdateRate) == 0);
            if simTime > this.ValidTimeRange(2) || simTime < this.ValidTimeRange(1) % if time is past the valid time
                isValid = false;
            end        
        end

    end

end