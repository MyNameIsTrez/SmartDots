import processing.core.PApplet;

class TextApplet extends PApplet {
	private GUI gui;
	private Text text;
	private int appletWindowX = 360 + 60;
	private int appletWindowY = 385;
	private SmartDots mainApplet;

	public TextApplet(SmartDots mainApplet) {
		this.mainApplet = mainApplet;
	}

	public void settings() {
		size(appletWindowX, appletWindowY);
	}

	public void setup() {
		surface.setResizable(true);
		gui = new GUI(this, mainApplet);
		text = new Text(this, mainApplet);
	}

	public void draw() {
		background(255);
		gui.showGUI();
		text.textApplet(mainApplet.maxFrameRate);
	}

	public void resize() {
		surface.setSize(appletWindowX, appletWindowY + 55);
	}
}
