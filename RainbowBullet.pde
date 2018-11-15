class RainbowBullet extends Bullet
{
  public static final int bulletFireRate = 1;

  public RainbowBullet() {}

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
    overrideStrokeColor = true;
    colorMode(HSB, 255);
    stroke(decay, 255, decay);
    colorMode(RGB, 255);
    super.show();
  }

  public void drawPixel(float x, float y, int pixelColor)
  {
    fill(pixelColor);
    stroke(0, 0);
    rectMode(CENTER);
    rect(x, y, 4, 1);
  }
}
