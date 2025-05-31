classdef Robott < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure    matlab.ui.Figure
        UIAxes      matlab.ui.control.UIAxes
    end

    % Private properties for robot state
    properties (Access = private)
        GestureControl = ''      % 'up', 'down', 'left', 'right'
        robotPos = [0 0]         % [x, y] position of robot
        robotDir = 'up'          % Robot facing direction
    end

    methods (Access = private)

        % Key press function
        function UIFigureKeyPress(app, event)
            key = event.Key;
            switch key
                case 'uparrow'
                    app.GestureControl = 'up';
                    app.robotDir = 'up';
                case 'downarrow'
                    app.GestureControl = 'down';
                    app.robotDir = 'down';
                case 'leftarrow'
                    app.GestureControl = 'left';
                    app.robotDir = 'left';
                case 'rightarrow'
                    app.GestureControl = 'right';
                    app.robotDir = 'right';
                otherwise
                    app.GestureControl = '';
            end
            app.updateRobotMotion();
        end

        % Update the robot position and redraw
        function updateRobotMotion(app)
            stepSize = 1;  % how much the robot moves per key press

            switch app.GestureControl
                case 'up'
                    app.robotPos(2) = app.robotPos(2) + stepSize;
                case 'down'
                    app.robotPos(2) = app.robotPos(2) - stepSize;
                case 'left'
                    app.robotPos(1) = app.robotPos(1) - stepSize;
                case 'right'
                    app.robotPos(1) = app.robotPos(1) + stepSize;
            end

            % Clear previous drawing
            cla(app.UIAxes);
            hold(app.UIAxes, 'on');

            % Draw robot body (rectangle)
            w = 1; h = 1.5;
            xRect = [-w/2 w/2 w/2 -w/2] + app.robotPos(1);
            yRect = [-h/2 -h/2 h/2 h/2] + app.robotPos(2);
            fill(app.UIAxes, xRect, yRect, [0.2 0.6 1], 'LineWidth', 2);

            % Draw robot head (triangle) to indicate facing direction
            switch app.robotDir
                case 'up'
                    xHead = [0 -0.3 0.3] + app.robotPos(1);
                    yHead = [h/2 h/2+0.5 h/2+0.5] + app.robotPos(2);
                case 'down'
                    xHead = [0 -0.3 0.3] + app.robotPos(1);
                    yHead = [-h/2 -h/2-0.5 -h/2-0.5] + app.robotPos(2);
                case 'left'
                    xHead = [-w/2 -w/2-0.5 -w/2-0.5] + app.robotPos(1);
                    yHead = [0 -0.3 0.3] + app.robotPos(2);
                case 'right'
                    xHead = [w/2 w/2+0.5 w/2+0.5] + app.robotPos(1);
                    yHead = [0 -0.3 0.3] + app.robotPos(2);
            end
            fill(app.UIAxes, xHead, yHead, [1 0 0], 'LineWidth', 2);

            % Set axis limits and properties
            axis(app.UIAxes, [-10 10 -10 10]);
            axis(app.UIAxes, 'equal');
            hold(app.UIAxes, 'off');
            drawnow;
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and set properties
            app.UIFigure = uifigure('Name', 'Gesture Controlled Robot');
            app.UIFigure.Position = [100 100 600 500];
            app.UIFigure.KeyPressFcn = @(src,event)app.UIFigureKeyPress(event);

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            app.UIAxes.Position = [50 50 500 400];
            title(app.UIAxes, 'Robot Simulation');
            xlabel(app.UIAxes, 'X Position');
            ylabel(app.UIAxes, 'Y Position');
            axis(app.UIAxes, 'equal');
            grid(app.UIAxes, 'on');

            % Initialize robot position and draw
            app.robotPos = [0 0];
            app.robotDir = 'up';
            app.updateRobotMotion();
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Robott
            createComponents(app)
        end
    end
end
