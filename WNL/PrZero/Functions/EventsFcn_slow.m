function [value,isterminal,direction] = EventsFcn_slow(t,y)
    value = y(2)+10;     % Detect height = 0
    isterminal = 1;   % Stop the integration
    direction = -1;   % Positive direction only
end

