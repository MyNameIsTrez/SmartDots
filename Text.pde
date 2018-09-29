import processing.core.PApplet;
import processing.data.IntList;

class Text {
	private PApplet displayApplet;
	public IntList textYPos = new IntList();
	private boolean textAppletResized = false;
	private int textXStart = 30;
	private int textYStart = 40;
	public int textYSpace = 55;
	private SmartDots mainApplet;

	public Text(PApplet displayApplet, SmartDots mainApplet) {
		this.displayApplet = displayApplet;
		this.mainApplet = mainApplet;

		for (int i = 0; i < 8; i++) {
			textYPos.append(textYStart + textYSpace * i);
		}
	}

	//draws the text for the textApplet
	public void textApplet(int maxFrameRate) {
		Population pop = mainApplet.pop;

		displayApplet.fill(0);//black text
		displayApplet.textSize(24);//the default font-size if this line is left out is 12

		//1
		displayApplet.text("main window size: " + mainApplet.width + " x " + mainApplet.height, textXStart, textYPos.get(0));//window size
		//println(applet.textWidth("main window size: " + width + " x " + height));

		//2
		displayApplet.text("gen: " + pop.gen, textXStart, textYPos.get(1));//gen

		//3
		displayApplet.text("mutation rate multiplier: " + mainApplet.mutationRateMultiplier, textXStart, textYPos.get(2));//mutation rate multiplier

		//4
		displayApplet.text("framerate: " + (int)mainApplet.frameRate + " / " + maxFrameRate, textXStart, textYPos.get(3));//frame rate

		//5
		if (pop.checkdotAlive() == 1) {//dots alive
			displayApplet.text("dot: " + pop.checkdotAlive() + " / " + mainApplet.dotStartAmount, textXStart, textYPos.get(4));
		} else {
			displayApplet.text("dots: " + pop.checkdotAlive() + " / " + mainApplet.dotStartAmount, textXStart, textYPos.get(4));
		}

		//6
		displayApplet.text("closest to goal: " + pop.setBestDistanceDot() + " pixels", textXStart, textYPos.get(5));//closest to goal

		//7
		displayApplet.text("current step: " + pop.calcMinStep() + " / " + pop.instructions, textXStart, textYPos.get(6));//current step

		//8
		if (pop.minStep < 1000) {//min step
			if (pop.lastMinStep < 1000) {
				if (pop.secondLastMinStep < 1000) {
					if (pop.thirdLastMinStep < 1000) {
						displayApplet.text("min step: "
								+ pop.minStep + " (" + -1 * (pop.lastMinStep - pop.minStep)
								+ ", " + -1 * (pop.secondLastMinStep - pop.lastMinStep)
								+ ", " + -1 * (pop.thirdLastMinStep - pop.secondLastMinStep)
								+ ")", textXStart, textYPos.get(7));
					} else {
						displayApplet.text("min step: "
								+ pop.minStep + " (" + -1 * (pop.lastMinStep - pop.minStep)
								+ ", " + -1 * (pop.secondLastMinStep - pop.lastMinStep)
								+ ")", textXStart, textYPos.get(7));
					}
				} else {
					displayApplet.text("min step: "
							+ pop.minStep + " (" + -1 * (pop.lastMinStep - pop.minStep)
							+ ")", textXStart, textYPos.get(7));
				}
			} else {
				displayApplet.text("min step: "
						+ pop.minStep, textXStart, textYPos.get(7));
				if (textAppletResized == false) {
					mainApplet.textApplet.resize();
					textAppletResized = true;
				}
			}
		}
	}
}
