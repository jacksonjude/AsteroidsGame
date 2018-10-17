class Spaceship extends Floater
{
  Spaceship()
  {
    myColor = color(255);
    corners = 4;
    xCorners = new int[corners];
    yCorners = new int[corners];
    xCorners[0] = -8;
    yCorners[0] = -8;
    xCorners[1] = 16;
    yCorners[1] = 0;
    xCorners[2] = -8;
    yCorners[2] = 8;
    xCorners[3] = -2;
    yCorners[3] = 0;

    myDirectionX = 0;
    myDirectionY = 0;
  }

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

  private final int maxDirection = 5;

  public void capMaxDirection()
  {
    if (Math.abs(myDirectionX) > maxDirection)
    {
      myDirectionX = maxDirection * Math.signum(myDirectionX);
    }

    if (Math.abs(myDirectionY) > maxDirection)
    {
      myDirectionY = maxDirection * Math.signum(myDirectionY);
    }
  }

  public void decelerate(double dAmount)
  {
    if (myDirectionX != 0 && myDirectionY != 0)
    {
      double dRadians = atan((float)(myDirectionY/myDirectionX));
      int dRadiansSigNum = Math.signum(dRadians);

      myDirectionX -= ((dAmount) * Math.cos(dRadians));
      myDirectionY -= ((dAmount) * Math.sin(dRadians));

      double dRadians2 = atan((float)(myDirectionY/myDirectionX));
      int dRadiansSigNum2 = Math.signum(dRadians2);

      if (dRadians != dRadians2)
      {
        myDirectionY = 0;
        myDirectionX = 0;
      }
    }
  }
}
