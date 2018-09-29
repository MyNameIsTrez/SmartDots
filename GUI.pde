import processing.core.PApplet;
import processing.data.IntList;

class GUI {
	private PApplet displayApplet;
	private SmartDots mainApplet;
	private IntList colorGUI = new IntList();

	public GUI(PApplet displayApplet, SmartDots mainApplet) {
		this.displayApplet = displayApplet;
		this.mainApplet = mainApplet;

		for (int i = 0; i < mainApplet.text.textYPos.size(); i++) {
			colorGUI.append((int)mainApplet.random(127, 224));
		}
	}

	public void showGUI() {
		Text text = mainApplet.text;
		Population pop = mainApplet.pop;

		//1
		displayApplet.fill(colorGUI.get(0));//window size
		displayApplet.rect(0, 0, 392, text.textYSpace);
		//2
		displayApplet.fill(colorGUI.get(1));//gen
		displayApplet.rect(0, text.textYSpace, 392, text.textYSpace);
		//3
		displayApplet.fill(colorGUI.get(2));//mutation rate multiplier
		displayApplet.rect(0, text.textYSpace * 2, 392 / 2 * mainApplet.mutationRateMultiplier, text.textYSpace);
		//4
		displayApplet.fill(colorGUI.get(3));//frame rate
		displayApplet.rect(0, text.textYSpace * 3, 392 * mainApplet.frameRate / mainApplet.maxFrameRate, text.textYSpace);
		//5
		displayApplet.fill(colorGUI.get(4));//dots alive
		displayApplet.rect(0, text.textYSpace * 4, 392 * pop.checkdotAlive() / mainApplet.dotStartAmount, text.textYSpace);
		//6
		displayApplet.fill(colorGUI.get(5));//closest to goal
		if (pop.setBestDistanceDot() != 0) {
			displayApplet.rect(0, text.textYSpace * 5, 392 * 1/(PApplet.sqrt(pop.setBestDistanceDot())), text.textYSpace);
		} else {
			displayApplet.rect(0, text.textYSpace * 5, 392, text.textYSpace);
		}
		//7
		displayApplet.fill(colorGUI.get(6));//current step
		displayApplet.rect(0, text.textYSpace * 6, 392 * pop.calcMinStep() / pop.instructions, text.textYSpace);
		//8
		displayApplet.fill(colorGUI.get(7));//min step
		displayApplet.rect(0, text.textYSpace * 7, 392 / PApplet.sqrt(pop.minStep), text.textYSpace);
	}
}
