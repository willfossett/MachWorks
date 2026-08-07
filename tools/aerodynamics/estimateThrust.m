function thrust_N = estimateThrust(altRange, Sref, CD, Mach, plotFlag)

if nargin < 1
    altRange = 0:500:20000; % ft
end

if nargin < 2
    Sref = 0.25; % m^2
end

if nargin < 3
    CD = 0.05;
end

if nargin < 4
    Mach = 1.02;
end

if nargin < 5
    plotFlag = true;
end

% T = D
% D = 0.5*rho*V^2*Sref*CD
% V = M*a, a = sqrt(gamma*R*T), rho*a^2/gamma = P ->
% D = gamma/2*P(h)*M^2*Sref*CD ->
% D ~ 0.7 * P(h) * M^2 * Sref * CD

[~, ~, P, ~] = atmosisa(altRange.*0.3048);

thrust_N = 0.7 .* P .* Mach^2 .* Sref .* CD;


if plotFlag
    figure
    hold on
    plot(altRange/1000, thrust_N)
    xlabel('altitude (kft)')
    ylabel('thrust required (N)')
    hold off

end

end