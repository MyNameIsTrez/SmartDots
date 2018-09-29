import processing.core.PApplet;

class GraphApplet extends PApplet {
//	private GUI gui;
//	private Text text;
	private int windowWidth = 500;
	private int windowHeight = 500;
	private int windowOffsetX = 100;
	private int windowOffsetY = windowHeight - 100;
	private int lineWidth = 30;
	private SmartDots mainApplet;

	public GraphApplet(SmartDots mainApplet) {
		this.mainApplet = mainApplet;
	}

	public void settings() {
		size(windowWidth, windowHeight);
	}

	public void setup() {
//		gui = new GUI(this, mainApplet);
//		text = new Text(this, mainApplet);
	}

	//draws the text
	private void graphApplet() {
		fill(0);
		textSize(24);//the default font-size if this line is left out is 12

		text("best pop gen", windowWidth - 175, windowHeight - 65);//x-axis
		text("0", 100, windowHeight - 65);

		text("best", 35, 30);//y-axis
		text("dot", 35, 60);//y-axis
		text("0", 70, windowHeight - 100);
	}

	public void draw() {
		Population pop = mainApplet.pop;

		background(255);
		strokeWeight(2);//default 1

		//horizontal and vertical lines and text
		line(windowOffsetX, 0, windowOffsetX, windowOffsetY);
		line(windowOffsetX, windowOffsetY, windowWidth, windowOffsetY);
		graphApplet();

		//organic lines
		if (pop.lastMinStep != 0 && pop.lastMinStep != 1000000) {
			for (int i = 0; i < pop.minStepList.size(); i++) {
				//draws the organic lines
				line(
						windowOffsetX + lineWidth + lineWidth * (i - 1), 
						windowOffsetY - pop.lastMinStepList.get(i), 
						windowOffsetX + lineWidth + lineWidth * i, 
						windowOffsetY - pop.minStepList.get(i)
						);

				//numbers above the organic lines
				fill(0);//black text
				textSize(12);//the default font-size if this line is left out is 12
				text(
						pop.minStepList.get(i), 
						windowOffsetX + lineWidth + lineWidth * i, 
						windowOffsetY - 10 - pop.minStepList.get(i)
						);
			}
		}
	}
}
