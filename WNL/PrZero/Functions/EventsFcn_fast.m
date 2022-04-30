function [value,isterminal,direction] = EventsFcn_fast(t,y)
    value = y(2)+10;     % Detect height = 0
    isterminal = 1;   % Stop the integration
    direction = 1;   % Negative direction only
end

