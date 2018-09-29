import processing.core.PApplet;
import processing.core.PVector;

class Dot {
  public Brain brain;
  private Population pop;

  public boolean dead = false;
  public boolean reachedGoal = false;
  public boolean isBest = false;//true if this dot is the best dot from the previous generation
  public float fitness = 0;
  private PVector pos;
  private PVector vel;
  private PVector acc;
  private SmartDots mainApplet;

  public Dot(Population pop, SmartDots mainApplet) {
    this.mainApplet = mainApplet;
    this.pop = pop;
    brain = new Brain(pop.instructions, mainApplet);//new brain with 1000 instructions
    //start the dot at the bottom of the window with a no velocity or acceleration
    pos = new PVector(mainApplet.width/2, mainApplet.height - 300);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);
  }

  //draws the dot on the screen
  public void showDot() {
    //if this dot is not the best dot from the previous generation then draw it
    if (!isBest) {
      mainApplet.fill(0);
      mainApplet.ellipse(pos.x, pos.y, 4, 4);
    }
  }

  private void bestDotColor() {
    if (pop.newGen == true) {
      if (pop.bestFitnessDot != pop.lastBestFitnessDot) {
        pop.bestRGB[0] = (int)mainApplet.random(256);
        pop.bestRGB[1] = (int)mainApplet.random(256);
        pop.bestRGB[2] = (int)mainApplet.random(256);
        while (pop.bestRGB[0] + pop.bestRGB[1] + pop.bestRGB[2] <= 150 || pop.bestRGB[0] + pop.bestRGB[1] + pop.bestRGB[2] >= 600) {
          pop.bestRGB[0] = (int)mainApplet.random(256);
          pop.bestRGB[1] = (int)mainApplet.random(256);
          pop.bestRGB[2] = (int)mainApplet.random(256);
          //println(pop.lastA + pop.lastB + pop.lastC);
        }
      }
      pop.newGen = false;
    }
  }

  public void showBestDot() {
    if (isBest) {
      mainApplet.pushStyle();
      mainApplet.stroke(pop.bestRGB[0], pop.bestRGB[1], pop.bestRGB[2]);
      bestDotColor();
      if (pop.bestFitnessDot == pop.lastBestFitnessDot) {
        mainApplet.fill(pop.bestRGB[0], pop.bestRGB[1], pop.bestRGB[2]);
        mainApplet.ellipse(pos.x, pos.y, 16, 16);
      } else {
        mainApplet.fill(pop.bestRGB[0], pop.bestRGB[1], pop.bestRGB[2]);
        mainApplet.ellipse(pos.x, pos.y, 16, 16);
      }
      mainApplet.strokeWeight(5);//default 1
      pop.posList.add(pos.copy());
      //show the best dot
      for (int i = 1; i < pop.posList.size(); i++) {
        mainApplet.line(pop.posList.get(i-1).x, pop.posList.get(i-1).y, pop.posList.get(i).x, pop.posList.get(i).y);
      }
      mainApplet.popStyle();
    }
  }

  //moves the dot according to the brains directions
  private void move() {
    //if there are still directions left then set the acceleration as the next PVector in the directions array
    if (brain.directions.length > brain.step) {
      acc = brain.directions[brain.step];
      brain.step++;
    }
    //if at the end of the directions array, then the dot is dead
    else {
      dead = true;
    }
    //apply the acceleration and move the dot
    vel.add(acc);
    vel.limit(5);//speed limit for the dot
    pos.add(vel);
  }

  //calls the move function and check for collisions and stuff
  public void update() {
    if (!dead && !reachedGoal) {
      move();
      //if near the edges of the window then kill it 
      if (pos.x< 2|| pos.y<2 || pos.x>mainApplet.width-2 || pos.y>mainApplet.height -2) {
        dead = true;
      }
      //if reached goal
      else if (PApplet.dist(pos.x, pos.y, mainApplet.goal.goal.x, mainApplet.goal.goal.y) < 5) {
        reachedGoal = true;
      }
      for (int a = 0; a < mainApplet.obstPos.size(); a++) {
        //if hit obstacle
        if (pos.x < (mainApplet.obstPos.get(a)[0] * 16 + 16) && pos.y < (mainApplet.obstPos.get(a)[1] * 16 + 16) &&
          pos.x > mainApplet.obstPos.get(a)[0] * 16 && pos.y > mainApplet.obstPos.get(a)[1] * 16) {
          dead = true;
        }
      }
    }
  }

  //calculates the fitness
  public void calculateFitness() {
    //if the dot reached the goal then the fitness is based on the amount of steps it took to get there
    if (reachedGoal) {
      fitness = (float) (1.0/16.0 + 10000.0/(float)(brain.step * brain.step));
    }
    //if the dot didn't reach the goal then the fitness is based on how close it is to the goal
    else {
      float distanceToGoal = PApplet.dist(pos.x, pos.y, mainApplet.goal.goal.x, mainApplet.goal.goal.y);
      fitness = (float) (1.0/(distanceToGoal * distanceToGoal));
    }
  }

  //calculates the dot that got the closest to the goal
  public int calculateDistance() {
    int distance = (int) PApplet.dist(pos.x, pos.y, mainApplet.goal.goal.x, mainApplet.goal.goal.y);
    return distance;
  }

  //clone it 
  public Dot gimmeBaby() {
    Dot baby = new Dot(pop, mainApplet);
    baby.brain = brain.clone();//babies have the same brain as their parents
    return baby;
  }
}
