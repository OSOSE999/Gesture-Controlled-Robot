classdef SimpleRobotApp < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure  matlab.ui.Figure
        qButton   matlab.ui.control.Button
        xButton   matlab.ui.control.Button
        dButton   matlab.ui.control.Button
        aButton   matlab.ui.control.Button
        sButton   matlab.ui.control.Button
        wButton   matlab.ui.control.Button
        UIAxes    matlab.ui.control.UIAxes  % We'll add axes for simulation visualization
    end

    properties (Access = private)
        GestureCode = 0; % 0 = no command
        GestureTimer % timer for updating simulation
        robotPos = [0 0]; % robot position [x,y]
        robotDir = 'up';  % robot facing direction
    end

    methods (Access = private)

        % Startup function
        function startupFcn(app)
            % Create and start timer to update robot motion
            app.GestureTimer = timer( ...
                'ExecutionMode', 'fixedRate', ...
                'Period', 0.1, ...
                'TimerFcn', @(~,~) app.updateRobotMotion());

            start(app.GestureTimer);

            % Set UIFigure key press callback
            app.UIFigure.KeyPressFcn = @(src,event) app.UIFigureKeyPress(event);

            % Initialize drawing
            app.drawRobot();
        end

        % Key press callback
        function UIFigureKeyPress(app, event)
            key = event.Key;
            switch key
                case {'w','uparrow'}
                    app.GestureCode = 1; % forward
                    app.robotDir = 'up';
                case {'s','downarrow'}
                    app.GestureCode = 2; % backward
                    app.robotDir = 'down';
                case {'a','leftarrow'}
                    app.GestureCode = 3; % left
                    app.robotDir = 'left';
                case {'d','rightarrow'}
                    app.GestureCode = 4; % right
                    app.robotDir = 'right';
                case {'x'}
                    app.GestureCode = 5; % stop
                otherwise
                    app.GestureCode = 0; % no command
            end
        end

        % Button callbacks -- update GestureCode accordingly
        function wButtonPushed(app, ~)
            app.GestureCode = 1; % forward
            app.robotDir = 'up';
        end

        function sButtonPushed(app, ~)
            app.GestureCode = 2; % backward
            app.robotDir = 'down';
        end

        function aButtonPushed(app, ~)
            app.GestureCode = 3; % left
            app.robotDir = 'left';
        end

        function dButtonPushed(app, ~)
            app.GestureCode = 4; % right
            app.robotDir = 'right';
        end

        function xButtonPushed(app, ~)
            app.GestureCode = 5; % stop
        end

        % Timer callback to update robot position and redraw
        function updateRobotMotion(app)
            stepSize = 0.5;

            switch app.GestureCode
                case 1 % forward/up
                    app.robotPos(2) = app.robotPos(2) + stepSize;
                case 2 % backward/down
                    app.robotPos(2) = app.robotPos(2) - stepSize;
                case 3 % left
                    app.robotPos(1) = app.robotPos(1) - stepSize;
                case 4 % right
                    app.robotPos(1) = app.robotPos(1) + stepSize;
                case 5 % stop
                    % Do nothing, hold position
                otherwise
                    % No movement
            end

            % Redraw the robot
            app.drawRobot();
        end

        % Function to draw the robot in UIAxes
        function drawRobot(app)
            if isempty(app.UIAxes) || ~isvalid(app.UIAxes)
                % Create UIAxes if not exist
                app.UIAxes = uiaxes(app.UIFigure);
                app.UIAxes.Position = [350 50 250 250];
                axis(app.UIAxes, [-10 10 -10 10]);
                axis(app.UIAxes, 'equal');
                grid(app.UIAxes, 'on');
                title(app.UIAxes, 'Robot Simulation');
                xlabel(app.UIAxes, 'X');
                ylabel(app.UIAxes, 'Y');
            end

            % Clear previous
            cla(app.UIAxes);
            hold(app.UIAxes, 'on');

            % Robot body rectangle
            w = 1; h = 1.5;
            xRect = [-w/2 w/2 w/2 -w/2] + app.robotPos(1);
            yRect = [-h/2 -h/2 h/2 h/2] + app.robotPos(2);
            fill(app.UIAxes, xRect, yRect, [0.2 0.6 1], 'LineWidth', 2);

            % Robot head (triangle) showing facing direction
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

            hold(app.UIAxes, 'off');
            drawnow;
        end

        % Close request function
        function UIFigureCloseRequest(app, event)
            if ~isempty(app.GestureTimer)
                stop(app.GestureTimer);
                delete(app.GestureTimer);
            end
            delete(app)
        end

    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'Gesture Controlled Robot';
            app.UIFigure.CloseRequestFcn = createCallbackFcn(app, @UIFigureCloseRequest, true);

            % Create wButton
            app.wButton = uibutton(app.UIFigure, 'push');
            app.wButton.ButtonPushedFcn = createCallbackFcn(app, @wButtonPushed, true);
            app.wButton.Position = [95 337 100 23];
            app.wButton.Text = 'w';

            % Create sButton
            app.sButton = uibutton(app.UIFigure, 'push');
            app.sButton.ButtonPushedFcn = createCallbackFcn(app, @sButtonPushed, true);
            app.sButton.Position = [95 296 100 23];
            app.sButton.Text = 's';

            % Create aButton
            app.aButton = uibutton(app.UIFigure, 'push');
            app.aButton.ButtonPushedFcn = createCallbackFcn(app, @aButtonPushed, true);
            app.aButton.Position = [95 257 100 23];
            app.aButton.Text = 'a';

            % Create dButton
            app.dButton = uibutton(app.UIFigure, 'push');
            app.dButton.ButtonPushedFcn = createCallbackFcn(app, @dButtonPushed, true);
            app.dButton.Position = [251 336 100 23];
            app.dButton.Text = 'd';

            % Create xButton
            app.xButton = uibutton(app.UIFigure, 'push');
            app.xButton.ButtonPushedFcn = createCallbackFcn(app, @xButtonPushed, true);
            app.xButton.Position = [251 296 100 23];
            app.xButton.Text = 'x';

            % Create qButton (optional, can add callback if needed)
            app.qButton = uibutton(app.UIFigure, 'push');
            app.qButton.Position = [251 256 100 23];
            app.qButton.Text = 'q';

            % Create UIAxes for robot simulation visualization
            app.UIAxes = uiaxes(app.UIFigure);
            app.UIAxes.Position = [350 50 250 250];
            axis(app.UIAxes, [-10 10 -10 10]);
            axis(app.UIAxes, 'equal');
            grid(app.UIAxes, 'on');
            title(app.UIAxes, 'Robot Simulation');
            xlabel(app.UIAxes, 'X Position');
            ylabel(app.UIAxes, 'Y Position');

            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = SimpleRobotApp
            createComponents(app)
            registerApp(app, app.UIFigure)
            runStartupFcn(app, @startupFcn)
            if nargout == 0
                clear app
            end
        end

        % Delete function
        function delete(app)
            if ~isempty(app.GestureTimer)
                stop(app.GestureTimer);
                delete(app.GestureTimer);
            end
            delete(app.UIFigure)
        end
    end
end
