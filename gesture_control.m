% gesture_control.m
clc;
clear;

x = 0; y = 0; % Initial position
step = 1;     % Distance per move

while true
    gesture = input('Enter gesture (w=forward, s=backward, a=left, d=right, x=stop, q=quit): ','s');

    switch gesture
        case 'w'
            y = y + step;
            disp('Moving forward');
        case 's'
            y = y - step;
            disp('Moving backward');
        case 'a'
            x = x - step;
            disp('Turning left');
        case 'd'
            x = x + step;
            disp('Turning right');
        case 'x'
            disp('Stopping');
        case 'q'
            break;
        otherwise
            disp('Invalid input');
    end

    fprintf('Robot Position: X = %.2f, Y = %.2f\n', x, y);
end
