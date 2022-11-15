# CSCI5611-PROJECT3
Inverse Kinematics Arm Movement
Project Write-Up

FEATURES:
My Inverse Kinematic program features a simulation of Slenderman reaching for a target point. The target point is represented by a black sphere that follows the user's mouse. Slenderman does have four joints in each of his two arms, as the project requires. He also can be moved by the user by pressing either the left or right arrowkeys, as demonstrated at around the 45 second mark in the video. Even while being moved, Slenderman still tries to reach his target. 

The joints, specifically the wrist and shoulder joint, also have limits on how far they can move. The shoulders are limited so they each cannot rise farther than horizontally to each other. The wrists are limited at 90 degrees in both directions. This is done to simulate a more lifelike representation of how arms actually move, and the limit to how they do so. The implementation of this can be seen during many parts of the video. 

To reiterate, my program satisfies the Single and Multi-arm requirement, Joint limits, User Interaction, and Moving IK. I did not use any external libraries aside from Professor's Vector library. 

DIFFICULTIES:
I really wanted to render this in 3D, but I am using processing and could not figure out how to change the root of the box shape. The origin of the shape was always in the middle, causing the IK to simply not work as it is programmed for the rectangle's corner origin. Funny enough, there is a function to change the origin of a rectange, but I could not find any mention of a similar function for the Box object. I looked everywhere from the processing reference to youtube videos and couldn't find anything about it. Other than this, the project was straight forward and pretty easy to implement. 


