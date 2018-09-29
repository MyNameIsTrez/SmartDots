import java.util.ArrayList;
import java.util.List;

import processing.core.PVector;
import processing.data.IntList;

class Population {
  //change this to a list instead of an array later
  private Dot[] dot;
  private SmartDots mainApplet;

  public boolean newGen;
  public int gen = 1;
  public int bestFitnessDot = 0;//the index of the best fitness dot in the dot[]
  public int lastBestFitnessDot;
  public int minStep = 1000000;
  public int lastMinStep;
  public int secondLastMinStep;
  public int thirdLastMinStep;
  private int minDistance = 1000000;
  private int dotAlive;
  private float fitnessSum;
  //	private float bestDistanceDot = 0;//the index of the best distance dot in the dot[]
  public int instructions = 1000;

  public IntList minStepList = new IntList();
  public IntList lastMinStepList = new IntList();
  
  public ArrayList<PVector> posList = new ArrayList<PVector>();
  public List<List<PVector>> posListList = new ArrayList<List<PVector>>();
  public int[] bestRGB = new int[3];
  public List<int[]> bestRGBList = new ArrayList<int[]>();


  public Population(int size, SmartDots mainApplet) {
    this.mainApplet = mainApplet;
    dot = new Dot[size];
    for (int i = 0; i< size; i++) {
      dot[i] = new Dot(this, mainApplet);
    }
  }

  public int calcMinStep() {
    int temp = 0;
    for (int i = 0; i< dot.length; i++) {
      if (dot[i].brain.step > temp) {
        temp = dot[i].brain.step;
      }
    }
    return temp;
  }

  //show all dots
  public void showDot() {
    for (int i = 1; i< dot.length; i++) {
      dot[i].showDot();
    }
  }

  //show best dot
  public void showBestDot() {
    for (int i = 1; i< dot.length; i++) {
      dot[i].showBestDot();
    }
    dot[0].showBestDot();//later on when a new generation is started, 1 dot will be created that has the same directions as the last best dot did
  }

  public void showPreviousBestDots() {
    mainApplet.pushStyle();
    if (gen > 2) {
      for (int u = 0; u < posListList.size(); u++) {
        mainApplet.fill(bestRGBList.get(u)[0], bestRGBList.get(u)[1], bestRGBList.get(u)[2]);
        mainApplet.stroke(bestRGBList.get(u)[0], bestRGBList.get(u)[1], bestRGBList.get(u)[2]);
        mainApplet.strokeWeight(5);
        for (int i = 1; i < posListList.get(u).size(); i++) {
          mainApplet.line(posListList.get(u).get(i-1).x, posListList.get(u).get(i-1).y, posListList.get(u).get(i).x, posListList.get(u).get(i).y);
        }
      }
    }
    mainApplet.popStyle();
  }


  //update all dot 
  public void update() {
    for (int i = 0; i< dot.length; i++) {
      //if the dot has already taken more steps than the best dot has taken to reach the goal
      if (dot[i].brain.step > minStep) {
        dot[i].dead = true;//then it's dead
      } else {
        dot[i].update();
      }
    }
  }

  //calculate all the fitnesses
  public void calculateFitness() {
    for (int i = 0; i< dot.length; i++) {
      dot[i].calculateFitness();
    }
  }

  //returns whether all the dot are either dead or have reached the goal
  public boolean alldotDead() {
    for (int i = 0; i< dot.length; i++) {
      if (!dot[i].dead && !dot[i].reachedGoal) { 
        return false;
      }
    }
    return true;
  }

  public int checkdotAlive() {
    dotAlive = mainApplet.dotStartAmount;
    for (int i = 0; i< dot.length; i++) {
      if (dot[i].dead || dot[i].reachedGoal) { 
        dotAlive--;
      }
    }
    return dotAlive;
  }

  //gets the next generation of dot
  public void naturalSelection() {
    Dot[] newdot = new Dot[dot.length];//next gen
    setBestFitnessDot();
    setBestDistanceDot();
    calculateFitnessSum();
    //the champion lives on 
    newdot[0] = dot[bestFitnessDot].gimmeBaby();
    newdot[0].isBest = true;
    for (int i = 1; i< newdot.length; i++) {
      //select parent based on fitness
      Dot parent = selectParent();
      //get baby from them
      newdot[i] = parent.gimmeBaby();
    }
    dot = newdot.clone();
    gen ++;
  }

  private void calculateFitnessSum() {
    fitnessSum = 0;
    for (int i = 0; i< dot.length; i++) {
      fitnessSum += dot[i].fitness;
    }
  }

  //chooses dot from the population to return randomly(considering fitness)
  //this function works by randomly choosing a value between 0 and the sum of all the fitnesses
  //then go through all the dot and add their fitness to a running sum and if that sum is greater than the random value generated that dot is chosen
  //since dot with a higher fitness function add more to the running sum then they have a higher chance of being chosen
  private Dot selectParent() {
    float rand = mainApplet.random(fitnessSum);
    float runningSum = 0;
    for (int i = 0; i< dot.length; i++) {
      runningSum+= dot[i].fitness;
      if (runningSum > rand) {
        return dot[i];
      }
    }
    return null;//should never get to this point
  }

  //mutates all the brains of the babies
  public void mutateDemBabies() {
    for (int i = 1; i< dot.length; i++) {
      dot[i].brain.mutate(mainApplet.mutationRateMultiplier);
    }
  }

  //finds the dot with the highest fitness and sets it as the best dot
  private void setBestFitnessDot() {
    float max = 0;
    int maxIndex = 0;
    for (int i = 0; i< dot.length; i++) {
      if (dot[i].fitness > max) {
        max = dot[i].fitness;
        maxIndex = i;
      }
    }
    lastBestFitnessDot = bestFitnessDot;
    bestFitnessDot = maxIndex;
    //if this dot reached the goal then reset the minimum number of steps it takes to get to the goal
    if (dot[bestFitnessDot].reachedGoal) {
      thirdLastMinStep = secondLastMinStep;
      secondLastMinStep = lastMinStep;
      lastMinStep = minStep;
      minStep = dot[bestFitnessDot].brain.step;
      if (this.lastMinStep != 0 && this.lastMinStep != 1000000) {
        minStepList.append(this.minStep);
        lastMinStepList.append(this.lastMinStep);
      }
    }
  }

  public int setBestDistanceDot() {
    for (int i = 0; i< dot.length; i++) {
      if (dot[i].calculateDistance() < minDistance) {
        minDistance = dot[i].calculateDistance();
        return minDistance;
      }
    }
    return(minDistance);//this means that if the 'if-condition' isn't met, there is always a return value of minDistance
  }
}
