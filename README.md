# Gesture-Controlled Robot with Arduino, POT-HG, L298 Motor Driver, and DC Motors


## Project Overview
This project demonstrates a gesture-controlled robot simulation using Proteus and Arduino Uno. The robot's movements are controlled by interpreting simulated hand gestures via two potentiometers (POT-HG) in Proteus. It showcases basic concepts of gesture control, PWM motor driving, and microcontroller programming.

## Features
### Gesture-Controlled Movement: 
Simulates hand gestures using potentiometers to navigate.

### Real-time Motor Control: 
PWM signals dynamically control the robot’s motors for smooth operation.

### Forward, Backward, and Turning: 
Adjust movements in all directions based on gesture inputs.

### Simulation-Ready Design: 
Fully modeled in Proteus for virtual testing and debugging.


## Components
### Devices:

### Arduino Uno: 
Processes gesture inputs and controls the motors.

### POT-HG 
Potentiometers: Simulate hand gestures for robot movement.

### X-axis: 
Controls forward/backward motion.

### Y-axis: 
Controls left/right turning.

### L298 Motor Driver: 
Drives the two DC motors based on Arduino PWM signals.

### DC Motors (2):
Represent the robot's left and right wheels.

### Power Source: 
Supplies power to the Arduino and motors.


## Software:
### Arduino IDE: 
To write and upload the code to the Arduino Uno.

### Proteus Design Suite: 
For simulating the robot and its control system.


### Circuit Design

### POT-HG Connections:

POT-HG X: Connect to Arduino A0 for forward/backward control.

POT-HG Y: Connect to Arduino A1 for left/right control.

### L298 Motor Driver Connections:

### Power Pins:

### VCC: Connect to the main power supply (e.g., 9V).

### GND: Connect to Arduino GND.

### Motor Outputs:

### OUT1 and OUT2: Connect to the left motor terminals.

### OUT3 and OUT4: Connect to the right motor terminals.

### Control Pins:

### IN1, IN2: 
Control the left motor direction via Arduino D2 and D3.

### IN3, IN4: 
Control the right motor direction via Arduino D4 and D5.

### Enable Pins:

ENA: Connect to Arduino D9 (PWM for left motor).

ENB: Connect to Arduino D10 (PWM for right motor).

## Software Implementation

### Key Code Functions:

### readPotentiometer(axisPin):

Reads analog values from the potentiometers to determine the gesture direction.

### Movement Functions:

moveForward(): Both motors run forward.

moveBackward(): Both motors run backward.

turnLeft(): Right motor runs forward, left motor stops or runs backward.

turnRight(): Left motor runs forward, right motor stops or runs backward.

stopMotors(): Stops both motors.

### Dynamic Control Logic:

Continuously reads POT-HG values and adjusts motor actions accordingly.

How to Run the Project

## Simulation (Proteus):

Assemble the circuit in Proteus based on the connections described above.

Upload the Arduino code (.hex file) into the Arduino Uno component in Proteus.

Run the simulation.

Adjust the virtual potentiometers (POT-HG) to simulate hand gestures and observe motor behavior.

## Acknowledgments
This project is based on fundamental robotics concepts and gesture-controlled design. Special thanks to the Arduino and Proteus communities for resources and inspiration.

