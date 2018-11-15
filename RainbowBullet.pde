class RainbowBullet extends Bullet
{
  public static final int bulletFireRate = 1;
  public float getBulletSpeed() { return 50.0; }

  public RainbowBullet() {}

  public RainbowBullet(double centerX, double centerY, double pointDirection)
  {
    super(centerX, centerY, pointDirection);
  }

  public void show()
  {
    overrideStrokeColor = true;
    colorMode(HSB, 255);
    stroke(decay, 255, decay);
    colorMode(RGB, 255);
    super.show();
  }
}
