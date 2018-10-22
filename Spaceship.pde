class Spaceship extends Floater
{
  Spaceship()
  {
    myColor = color(255);
    corners = 4;
    int[] xS = {-8, 16, -8, -2};
    int[] yS = {-8, 0, 8, 0};
    xCorners = xS;
    yCorners = yS;

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
      int dirXSignum1 = (int)Math.signum(myDirectionX);
      int dirYSignum1 = (int)Math.signum(myDirectionY);

      double totalDirection = Math.sqrt(Math.pow(myDirectionX, 2) + Math.pow(myDirectionY, 2));
      double dRadians = atan((float)(myDirectionY/myDirectionX));
      totalDirection -= dAmount;
      myDirectionX = (Math.signum(myDirectionX))*Math.abs(Math.cos(dRadians)*totalDirection);
      myDirectionY = (Math.signum(myDirectionY))*Math.abs(Math.sin(dRadians)*totalDirection);

      int dirXSignum2 = (int)Math.signum(myDirectionX);
      int dirYSignum2 = (int)Math.signum(myDirectionY);

      if (dirXSignum1 != dirXSignum2 || dirYSignum1 != dirYSignum2)
      {
        myDirectionX = 0;
        myDirectionY = 0;
      }
    }
  }
}
