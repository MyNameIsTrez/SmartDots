import processing.core.PVector;

class Goal {
	private SmartDots mainApplet;
	public PVector goal;
	
	public Goal(SmartDots mainApplet) {
		this.mainApplet = mainApplet;
		this.goal = new PVector(mainApplet.width/2, 24);
	}

	void goal() {
		mainApplet.stroke(0);
		mainApplet.fill(255, 0, 0);
		mainApplet.ellipse(goal.x, goal.y, 10, 10);
	}
}
