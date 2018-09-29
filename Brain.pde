import processing.core.PApplet;
import processing.core.PVector;

class Brain {
	public PVector[] directions;//series of vectors which get the dot to the goal (hopefully)
	public int step = 0;
	private SmartDots mainApplet;

	public Brain(int size, SmartDots mainApplet) {
		this.mainApplet = mainApplet;
		directions = new PVector[size];
		randomize();
	}

	//sets all the vectors in directions to a random vector with length 1
	private void randomize() {
		for (int i = 0; i< directions.length; i++) {
			float randomAngle = mainApplet.random(2*PApplet.PI);
			directions[i] = PVector.fromAngle(randomAngle);
		}
	}

	//returns a perfect copy of this brain object
	protected Brain clone() {
		Brain clone = new Brain(directions.length, mainApplet);
		for (int i = 0; i < directions.length; i++) {
			clone.directions[i] = directions[i].copy();
		}
		return clone;
	}

	//mutates the brain by setting some of the directions to random vectors
	//0.01 by default, chance that any vector in directions gets changed
	//lower is better in general, the mutationRate can get modified by the mutationRateMultiplier
	public void mutate(float mutationRateMultiplier) {
		float mutationRate = (float) (0.10 * mainApplet.mutationRateMultiplier);
		for (int i = 0; i < directions.length; i++) {      
			float rand = mainApplet.random(1);
			if (rand < mutationRate) {
				//set this direction as a random direction 
				float randomAngle = mainApplet.random(2*PApplet.PI);
				directions[i] = PVector.fromAngle(randomAngle);
			}
		}
	}
}
