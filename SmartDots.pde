import static javax.swing.JOptionPane.ERROR_MESSAGE;
import static javax.swing.JOptionPane.showInputDialog;
import static javax.swing.JOptionPane.showMessageDialog;

import java.util.Arrays;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.Files;
import java.nio.charset.Charset;

//import java.io.File;
//import java.io.PrintWriter;
import java.util.ArrayList;

import processing.core.PApplet;
import processing.core.PVector;
import processing.data.IntList;
//import processing.sound.SoundFile;

public TextApplet textApplet;
@SuppressWarnings("unused")
  private GraphApplet graphApplet;

public Population pop;
public Obstacles obst;
public Goal goal;
public Text text;
private Grid grid;

//	private SoundFile click;
private File f;
private File obstPosLayoutFile;

public boolean paused = false;//if the game is paused when started
//	private boolean restartApp = false;
public int dotStartAmount = 100;//create a new population with a default of 1000 members, must be greater than 0
//	private int dotStartMax = 2000;//the maximum of dot that can be in the game at once
//	int dotAlive;
public int maxFrameRate = 120;//lower than 0 causes the game to automatically max it
private int[] windowSize = {//size of the window
  648, 648
};
public float mutationRateMultiplier = 1;

//	private IntList guiPos = new IntList();
public List<int[]> obstPos;
public boolean obstLayout = false;
public List<int[]> obstPosLayout = new ArrayList<int[]>();

private PrintWriter output;

public static void main(String[] args) {
  PApplet.main("SmartDots");
}

public void settings() {
  //fullScreen();//1360x768 = 85x48 grid
  size(windowSize[0], windowSize[1]);
}

public void setup() {
  frameRate(maxFrameRate);//increase this to make the dot go faster, 60 by default
  pop = new Population(dotStartAmount, this);
  obst = new Obstacles(this);
  goal = new Goal(this);
  grid = new Grid(width / 16 * (height / 16), this);
  text = new Text(this, this);

  //		guiPos = new IntList();
  obstPos = new ArrayList<int[]>();
  obst.initObstPos();

  //		click = new SoundFile(this, "click.mp3");

  final String[] switches = { "--sketch-path=" + sketchPath(), "" };
  textApplet = new TextApplet(this);
  graphApplet = new GraphApplet(this);
  runSketch(switches, textApplet);
  //		runSketch(switches, graphApplet);

  f = new File(dataPath("saveCounter.txt"));//doesn't clear the text file
  obstPosLayoutFile = new File(dataPath("obstPosLayoutFile.txt"));//doesn't clear the text file
}

//draws and updates everything
public void draw() {
  if (paused == false) {
    //if all dot are dead and the game isn't paused
    if (pop.alldotDead()) {
      if (pop.gen > 1) {
        if (pop.bestFitnessDot != pop.lastBestFitnessDot) {
          if (pop.posListList.size() == 5) {
            pop.posListList.remove(0);
            pop.bestRGBList.remove(0);
          }
          pop.posListList.add((ArrayList<PVector>)pop.posList.clone());
          pop.bestRGBList.add(pop.bestRGB.clone());
        }
        pop.posList.clear();
      }
      //click.play();
      pop.calculateFitness();
      pop.naturalSelection();
      pop.mutateDemBabies();
      pop.newGen = true;
    } else {
      background(255, 255, 255);
      //obst.appendCustomObstacle();
      //obst.createObstacles();
      //obst.removeObstacles();
      goal.goal();
      pop.update();
      pop.showDot();
      pop.showBestDot();
      pop.showPreviousBestDots();
      obst.drawObstacles();
    }
  } else {
    grid.createGrid();
    //obst.appendCustomObstacle();
    //obst.createObstacles();
    //obst.removeObstacles();
    goal.goal();
    pop.showDot();
    obst.drawObstacles();
  }
}



public void keyReleased() {
  String inputStr;

  switch(key) {
    //pauses and unpauses the game
  case ' ':
    paused = !paused;
    break;

    //resets the simulation
  case 'r':
    textApplet.dispose();
    textApplet.stop();
    frameCount = -1;
    break;

    //changes dotStartAmount
  case 'p':
    inputStr = showInputDialog("Please enter the new dot start amount: int, (1, ->)");
    if (inputStr !=null) {
      int inputInt = Integer.parseInt(inputStr);
      if (inputInt > 1) {
        dotStartAmount = inputInt;
      } else {
        showMessageDialog(null, "Invalid input!", "Alert", ERROR_MESSAGE);
      }
      textApplet.stop();
      frameCount = -1;
    }
    break;

    //changes maxFrameRate
  case 'f':
    inputStr = showInputDialog("Please enter the new max frame rate: int, (0, ->)");
    if (inputStr !=null) {
      int inputInt = Integer.parseInt(inputStr);
      if (inputInt > 0) {
        maxFrameRate = inputInt;
      } else {
        showMessageDialog(null, "Invalid input!", "Alert", ERROR_MESSAGE);
      }
      frameRate(maxFrameRate);//increase this to make the dot go faster, 60 by default
    }
    break;

    //changes mutationRateMultiplier
  case 'm':
    float inputFloat = Float.parseFloat(showInputDialog("Please enter the new mutation rate multiplier: float, [0.001, ->)"));
    if (str(inputFloat) !=null) {
      if (inputFloat > 0.0009) {
        mutationRateMultiplier = inputFloat;
      } else {
        showMessageDialog(null, "Invalid input!", "Alert", ERROR_MESSAGE);
      }
      textApplet.stop();
      frameCount = -1;
    }
    break;

    //saves data to a text file inside the sketch's folder
  case 's':
    try {
      String[] saveCounter = loadStrings("I:/Github/SmartDots/data/saveCounter.txt");
      int saveCounterValue = Integer.parseInt(saveCounter[0]) + 1;
      List<String> lines = Arrays.asList(str(saveCounterValue));
      Path file = Paths.get("I:/Github/SmartDots/data/saveCounter.txt");
      Files.write(file, lines, Charset.forName("UTF-8"));
    } 
    catch (Exception e) {
      e.printStackTrace();
    }
    break;

    //a key for printing code that needs to be tested
  case 'b': 
    println();
    break;

  case CODED:
    switch(keyCode) {
      //default:println(keyCode);
    case 112://F1
      obstLayout = !obstLayout;
      break;

    case 113://F2
      if (obstLayout && obstPosLayout.size() > 0) {
        obstLayout = false;
        String temp = "";
        for (int i = 0; i < obstPosLayout.size(); i++) {
          temp += "[" + obstPosLayout.get(i)[0] + ", " + obstPosLayout.get(i)[1] + "], ";
        }
        temp = temp.substring(0, temp.length() - 2);
        println(temp);
        println(sketchPath());

        if (obstPosLayoutFile.exists()) {
          try {
            List<String> lines = Arrays.asList(temp);
            Path file = Paths.get("I:/Github/SmartDots/data/obstPosLayoutFile.txt");
            Files.write(file, lines, Charset.forName("UTF-8"));
          } 
          catch (Exception e) {
            e.printStackTrace();
          }
          //Files.write(file, lines, Charset.forName("UTF-8"), StandardOpenOption.APPEND);


          //String[] strings = new String[0];//clears the string array by setting the array size to 0
          //strings = append(strings, temp);
          //saveStrings(dataPath("obstPosLayoutFile.txt"), strings);
          //println(loadStrings(dataPath("obstPosLayoutFile.txt")));
        } else {
          //output = createWriter(dataPath("obstPosLayoutFile.txt"));
          //output.flush(); // Writes the remaining data to the file
          //output.close(); // Finishes the file
          //println(2);
        }
        obstPosLayout.clear();
      }
      break;
    }
    break;
  }
}

public void mousePressed() {
  if (mouseButton == LEFT) {
    if (paused) {
      obst.createObstacle(mouseX, mouseY);
    }
  } else if (mouseButton == RIGHT) {
    if (paused) {
      obst.removeObstacle(mouseX, mouseY);
    }
  }
}
