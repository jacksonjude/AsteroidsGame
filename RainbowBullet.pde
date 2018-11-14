class RainbowBullet extends Bullet
{
  public RainbowBullet(double centerX, double centerY, double pointDirection, float bulletSpeed)
  {
    super(centerX, centerY, pointDirection, bulletSpeed);

    corners = 4;
    int[] xS = {2, -2, -2, 2};
    int[] yS = {1, 1, -1, -1};

    xCorners = xS;
    yCorners = yS;
  }

  public void show()
  {
    myColor = color(0, 0);
    super.show();
    translate((float)myCenterX, (float)myCenterY);
    rotate((float)myPointDirection);
    drawPixel(2, -1, color(255, 0, 0));
    drawPixel(2, 0, color(0, 255, 0));
    drawPixel(2, 1, color(0, 0, 255));
    rotate(-(float)myPointDirection);
    translate(-(float)myCenterX, -(float)myCenterY);
  }

  public void drawPixel(float x, float y, int pixelColor)
  {
    fill(pixelColor);
    rectMode(CORNER);
    rect(x, y, 4, 1);
  }
}
