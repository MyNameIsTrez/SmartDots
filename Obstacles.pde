class Obstacles {

  private SmartDots mainApplet;

  public Obstacles(SmartDots mainApplet) {
    this.mainApplet = mainApplet;
  }

  public void createObstacleByGrid(int xGrid, int yGrid, int obstWidth, int obstHeight) {
    for (int i = 0; i < obstWidth; i++) {
      for (int u = 0; u < obstHeight; u++) {
        int[] gridPos = {xGrid + i - 1, yGrid + u - 1};
        mainApplet.obstPos.add(gridPos);
      }
    }
  }

  public void createObstacle(int mouseXPos, int mouseYPos) {
    int xGrid = floor(mouseXPos/16);
    int yGrid = floor(mouseYPos/16);
    int[] gridPos = {xGrid, yGrid};
    mainApplet.obstPos.add(gridPos);
    if (obstLayout) {
      mainApplet.obstPosLayout.add(gridPos);
    }
  }

  public void removeObstacle(int mouseXPos, int mouseYPos) {
    int xGrid = floor(mouseXPos/16);
    int yGrid = floor(mouseYPos/16);
    for (int i = 0; i < mainApplet.obstPos.size(); i++) {
      if (mainApplet.obstPos.get(i)[0] == xGrid && mainApplet.obstPos.get(i)[1] == yGrid) {
        mainApplet.obstPos.remove(i);
        break;
      }
    }
    if (obstLayout) {
      for (int i = 0; i < mainApplet.obstPosLayout.size(); i++) {
        if (mainApplet.obstPosLayout.get(i)[0] == xGrid && mainApplet.obstPosLayout.get(i)[1] == yGrid) {
          mainApplet.obstPosLayout.remove(i);
          break;
        }
      }
    }
  }

  public void drawObstacles() {
    mainApplet.pushStyle();
    for (int i = 0; i < mainApplet.obstPos.size(); i++) {
      mainApplet.noStroke();
      mainApplet.fill(0, 0, 255);
      mainApplet.rect(mainApplet.obstPos.get(i)[0]*16, mainApplet.obstPos.get(i)[1]*16, 16, 16);
    }
    mainApplet.popStyle();
  }

  void initObstPos() {
    createObstacleByGrid(2, 3, 5, 10);
  }
}
