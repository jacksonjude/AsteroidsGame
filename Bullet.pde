class Bullet extends Floater
{
  private float decay = 255.0;

  public int getX() { return (int) myCenterX; }
  public void setX(int x) { myCenterX = (double) x; }
  public int getY() { return (int) myCenterY; }
  public void setY(int y) { myCenterY = (double) y; }

  public double getDirectionX() { return myDirectionX; }
  public void setDirectionX(double x) { myDirectionX = x; }
  public double getDirectionY() { return myDirectionY; }
  public void setDirectionY(double y) { myDirectionY = y; }

  public double getPointDirection() { return myPointDirection; }
  public void setPointDirection(int degrees) { myPointDirection = degrees; }

  public int[] getXCorners() { return xCorners; }
  public int[] getYCorners() { return yCorners; }

  public Bullet(double centerX, double centerY, double pointDirection, float bulletSpeed)
  {
    this.myCenterX = centerX;
    this.myCenterY = centerY;
    this.myPointDirection = pointDirection;
    this.myDirectionX = bulletSpeed*Math.cos(myPointDirection*(Math.PI/180));
    this.myDirectionY = bulletSpeed*Math.sin(myPointDirection*(Math.PI/180));

    corners = 4;
    int[] xS = {1, 1, -1, -1};
    int[] yS = {1, -1, -1, 1};

    xCorners = xS;
    yCorners = yS;
  }

  public void show()
  {
    decay -= 2.55;
    myColor = color(255, decay);
    stroke(255, decay);
    super.show();
  }

  public boolean shouldDelete()
  {
    return decay <= 0.0;
  }

  public int signum1(double num)
  {
    if (num > 0)
    {
      return 1;
    }
    else if (num < 0)
    {
      return -1;
    }
    else
    {
      return 0;
    }
  }
}
