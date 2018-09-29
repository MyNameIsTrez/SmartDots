//the grid is made of 16x16 obstacles
class Grid {
	private Obstacles[] obstacles;
	private SmartDots mainApplet;

	//rgb of the obstacles
	private int[] gridcol = {
			255, 255, 255, //purple
	};
	
	private int gridWidth;
	private int gridHeight;
	
	public Grid(int size, SmartDots mainApplet) {
		this.mainApplet = mainApplet;
		obstacles = new Obstacles[size];
		for (int i = 0; i< size; i++) {
			obstacles[i] = new Obstacles(mainApplet);
		}
		gridWidth = mainApplet.width / 16;
		gridHeight = mainApplet.height / 16;
	}

	//makes obstacles and fills them with a color
	void createGrid() {
		for (int i = 0; i < gridHeight; i++) {
			for (int j = 0; j < gridWidth; j++) {
				mainApplet.stroke(0);
				mainApplet.fill(gridcol[0], gridcol[1], gridcol[2]);
				mainApplet.rect(j * 16, i * 16, 16, 16);
			}
		}
	}
}
