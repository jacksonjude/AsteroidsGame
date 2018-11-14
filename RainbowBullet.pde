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

    myColor = color(0, 0);
  }

  public void show()
  {
    super.show();
    translate((float)myCenterX, (float)myCenterY);
    float dRadians = (float)(myPointDirection*(Math.PI/180));
    //float x1 = (float)((x*Math.cos(dRadians) - y*Math.sin(dRadians)));
    //float y1 = (float)((x*Math.sin(dRadians) + y*Math.cos(dRadians)));
    rotate(dRadians);
    drawPixel(0, 2, color(180, 0, 180));
    drawPixel(0, -2, color(255, 0, 0));
    drawPixel(0, 0, color(0, 255, 0));
    drawPixel(0, 1, color(0, 0, 255));
    drawPixel(0, -1, color(180, 180, 0));
    rotate(-dRadians);
    translate(-(float)myCenterX, -(float)myCenterY);
  }

  public void drawPixel(float x, float y, int pixelColor)
  {
    fill(pixelColor);
    stroke(0, 0);
    rectMode(CENTER);
    rect(x, y, 4, 1);
  }
}
