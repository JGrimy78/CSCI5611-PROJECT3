public class Arm{
  Vec2 root;
  float l0, l1, l2, l3;
  float a0, a1, a2, a3;
  Vec2 start_l1,start_l2,start_l3,endPoint;
  
  public Arm(Vec2 root, float l0, float l1, float l2, float l3, float a0, float a1, float a2, float a3){
    this.root = root;
    this.a0 = a0;
    this.a1 = a1;
    this.a2 = a2;
    this.a3 = a3;
    this.l0 = l0;
    this.l1 = l1;
    this.l2 = l2;
    this.l3 = l3;
  }
  
  void fk(){
    start_l1 = new Vec2(cos(a0)*l0,sin(a0)*l0).plus(root);
    start_l2 = new Vec2(cos(a0+a1)*l1,sin(a0+a1)*l1).plus(start_l1);
    start_l3 = new Vec2(cos(a0+a1+a2)*l2,sin(a0+a1+a2)*l2).plus(start_l2);
    endPoint = new Vec2(cos(a0+a1+a2+a3)*l3, sin(a0+a1+a2+a3)*l3).plus(start_l3);
  }

  void solve(){
    Vec2 goal = new Vec2(mouseX, mouseY);
    
    Vec2 startToGoal, startToEndEffector;
    //Vec2 startToGoal_r, startToEndEffector_r;
    float dotProd, angleDiff;
    //float dotProd_r, angleDiff_r;
    
    //4th joint
    startToGoal = goal.minus(start_l3);
    startToEndEffector = endPoint.minus(start_l3);
    dotProd = dot(startToGoal.normalized(), startToEndEffector.normalized());
    dotProd = clamp(dotProd, -1, 1);
    angleDiff = acos(dotProd);
    if (cross(startToGoal, startToEndEffector) < 0)
      a3 += angleDiff;
    else
      a3 -= angleDiff;
    if (a3 > 1.5708) a3 = 1.5708;
    if (a3 < -1.5708) a3 = -1.5708;
    fk();
    
    
    //Update wrist joint
    startToGoal = goal.minus(start_l2);
    startToEndEffector = endPoint.minus(start_l2);
    dotProd = dot(startToGoal.normalized(),startToEndEffector.normalized());
    dotProd = clamp(dotProd,-1,1);
    angleDiff = acos(dotProd);
    if (cross(startToGoal,startToEndEffector) < 0)
      a2 += angleDiff;
    else
      a2 -= angleDiff;
    /*TODO: Wrist joint limits here*/
    //if (a2 > 1.5708) a2 = 1.5708;
    //if (a2 < -1.5708) a2 = -1.5708;
    fk(); //Update link positions with fk (e.g. end effector changed)
    
    
    
    //Update elbow joint
    startToGoal = goal.minus(start_l1);
    startToEndEffector = endPoint.minus(start_l1);
    dotProd = dot(startToGoal.normalized(),startToEndEffector.normalized());
    dotProd = clamp(dotProd,-1,1);
    angleDiff = acos(dotProd);
    if (cross(startToGoal,startToEndEffector) < 0)
      a1 += angleDiff;
    else
      a1 -= angleDiff;
    fk(); //Update link positions with fk (e.g. end effector changed)
    
    
    //Update shoulder joint
    startToGoal = goal.minus(root);
    if (startToGoal.length() < .0001) return;
    startToEndEffector = endPoint.minus(root);
    dotProd = dot(startToGoal.normalized(),startToEndEffector.normalized());
    dotProd = clamp(dotProd,-1,1);
    angleDiff = acos(dotProd);
    if (cross(startToGoal,startToEndEffector) < 0)
      a0 += angleDiff;
    else
      a0 -= angleDiff;
  
    /*TODO: Shoulder joint limits here*/
    if(a0 > 3.14159) a0 = 3.14159;
    if(a0 < 0) a0 = 0;
    //if(a0_r > 3.14159) a0_r = 3.14159;
    //if(a0_r < 0) a0_r = 0;
    fk(); //Update link positions with fk (e.g. end effector changed)
   
    //println("Angle 0:",a0,"Angle 1:",a1,"Angle 2:",a2);
  }
  
  
}
