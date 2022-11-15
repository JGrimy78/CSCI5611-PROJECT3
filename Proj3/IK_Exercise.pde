//Inverse Kinematics
//CSCI 5611 IK [Solution]
// Stephen J. Guy <sjguy@umn.edu>

/*
INTRODUCTION:
Rather than making an artist control every aspect of a characters animation, we will often specify 
key points (e.g., center of mass and hand position) and let an optimizer find the right angles for 
all of the joints in the character's skelton. This is called Inverse Kinematics (IK). Here, we start 
with some simple IK code and try to improve the results a bit to get better motion.

TODO:
Step 1. Change the joint lengths and colors to look more like a human arm. Try to match 
        the length ratios of your own arm/hand, and try to match your own skin tone in the rendering.

Step 2: Add an angle limit to the wrist joint, and limit it to be within +/- 90 degrees relative
        to the lower arm.
        -Be careful to put the joint limits for the wrist *before* you compute the new end effoctor
         position for the next link in CCD

Step 3: Add an angle limit to the shoulder joint to limit the joint to be between 0 and 90 degrees, 
        this should stop the top of the arm from moving off screen.

Step 4: Cap the acceleration of each joint so the joints can only update slowly. Try to tweak the 
        acceleration cap to be different for each joint to get a good effect on the arm motion.

Step 5: Try adding a 4th limb to the IK chain.


CHALLENGE:

1. Go back to the 3-limb arm, can you make it look more human-like. Try adding a simple body to 
   the scene using circles and rectangles. Can you make a scene where the character picks up 
   something and moves it somewhere?
2. Create a more full skeleton. How do you handle the torso having two different arms?

*/

void setup(){
  size(640, 480, P3D);
  surface.setTitle("Inverse Kinematics [CSCI 5611 Example]");
  armList = new ArrayList();
  for(int i = 0; i < armCount; i+=2){
     Arm tempRightArm = new Arm(root, l0, l1, l2, l3, a0, a1, a2, a3);
     Arm tempLeftArm = new Arm(root2, l0, l1, l2, l3, a0, a1, a2, a3);
     armList.add(tempRightArm);
     armList.add(tempLeftArm);
  }
}

//Root
Vec2 root = new Vec2(350,120);
Vec2 root2 = new Vec2(250, 120);

//Upper Arm
float l0 = 100; 
float a0 = 0.3; //Shoulder joint
//float a0_r = 0.3;

//Lower Arm
float l1 = 100;
float a1 = 0.3; //Elbow joint
//float a1_r = 0.3;

//Hand
float l2 = 50;
float a2 = 0.3; //Wrist joint
//float a2_r = 0.3;

float l3 = 20;
float a3 = 0.3;

float armW = 20;

int armCount = 2;
ArrayList<Arm> armList;

boolean shiftPressed, leftPressed, rightPressed;
boolean paused = false;
float speed = 200;
Vec2 vel = new Vec2(0, 0);
Vec2 pos = new Vec2(0, 0);

void update(float dt){
  //pos = new Vec2(0, 0);
  vel = new Vec2(0, 0);
  speed = 0.1;
  if (leftPressed) vel = new Vec2(-speed,0);
  if (rightPressed) vel = new Vec2(speed,0);
  pos.add(vel.times(dt));
  root.add(vel.times(dt));
  root2.add(vel.times(dt));
}


void draw(){

  background(250,250,250);
  
  if(!paused) update(frameRate);

  fill(20);
  //BODY
  pushMatrix();
  translate(250+pos.x, 100);
  rect(0, 0, 100, 150);
  popMatrix();
  
  //LEGS
  pushMatrix();
  rect(260+pos.x, 250, 30, 200);
  rect(310+pos.x, 250, 30, 200);
  popMatrix();
  
  fill(255);
  
  //HEAD
  pushMatrix();
  translate(300+pos.x, 50);
  circle(0, 0, 100);
  popMatrix();
  
  for(int i = 0; i < armCount; i++) {
    Arm curArm = armList.get(i);
    curArm.fk();
    curArm.solve();
    
    //rectMode(CORNER);
    fill(35);
    pushMatrix();
    translate(curArm.root.x,curArm.root.y);
    rotate(curArm.a0);
    rect(0, -armW/2, curArm.l0, armW);
    //ox(curArm.l0, armW, 25);
    popMatrix();
    
    pushMatrix();
    translate(curArm.start_l1.x,curArm.start_l1.y);
    rotate(curArm.a0+curArm.a1);
    rect(0, -armW/2, curArm.l1, armW);
    //box(curArm.l1, armW, 25);
    popMatrix();
    
    fill(255);
    pushMatrix();
    translate(curArm.start_l2.x,curArm.start_l2.y);
    rotate(curArm.a0+curArm.a1+curArm.a2);
    rect(0, -armW/2, curArm.l2, armW);
    //box(curArm.l2, armW, 25);
    popMatrix();
        
    pushMatrix();
    translate(curArm.start_l3.x,curArm.start_l3.y);
    rotate(curArm.a0+curArm.a1+curArm.a2+curArm.a3);
    rect(0, -armW/2, curArm.l3, armW);
    //box(curArm.l3, armW, 25);
    popMatrix();
  }
  
  fill(0);
  pushMatrix();
  translate(mouseX, mouseY);
  circle(0, 0, 20);
  popMatrix();
}

void keyPressed(){
  if (keyCode == LEFT) leftPressed = true;
  if (keyCode == RIGHT) rightPressed = true;
  if (keyCode == SHIFT) shiftPressed = true;
  if (key == ' ') paused = !paused;
}

void keyReleased(){
  if (keyCode == LEFT) leftPressed = false;
  if (keyCode == RIGHT) rightPressed = false;
  if (keyCode == SHIFT) shiftPressed = false;
}
