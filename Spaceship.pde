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

  /*public void decelerate(double dAmount)
  {
    if (myDirectionX != 0 && myDirectionY != 0)
    {
      double dRadians = atan((float)(myDirectionX/myDirectionY));
      //println("RADS: " + String.valueOf(dRadians) + " -- MOVEX: " + String.valueOf((dAmount) * Math.cos(dRadians)) + " -- MOVEY: " + String.valueOf((dAmount) * Math.sin(dRadians)));
      println("RADS: " + String.valueOf(dRadians) + " -- MOVEX: " + String.valueOf(myDirectionX) + " -- MOVEY: " + String.valueOf(myDirectionY));
      //println();
      //println((dAmount) * Math.sin(dRadians));
      //println(Math.signum(myDirectionX));
      //println(Math.signum(myDirectionY));
      int dirXSignum1 = (int)Math.signum(myDirectionX);
      int dirYSignum1 = (int)Math.signum(myDirectionY);

      if (myDirectionX > 0)
      {
        myDirectionX -= Math.abs((dAmount) * Math.cos(dRadians));
      }
      if (myDirectionX < 0)
      {
        myDirectionX += Math.abs((dAmount) * Math.sin(dRadians));
      }
      if (myDirectionY > 0)
      {
        myDirectionY -= Math.abs((dAmount) * Math.sin(dRadians));
      }
      if (myDirectionY < 0)
      {
        myDirectionY += Math.abs((dAmount) * Math.cos(dRadians));
      }

      //double dRadians2 = atan((float)(myDirectionY/myDirectionX));
      //int dRadiansSigNum2 = (int)Math.signum(dRadians2);

      int dirXSignum2 = (int)Math.signum(myDirectionX);
      int dirYSignum2 = (int)Math.signum(myDirectionY);

      if (dirXSignum1 != dirXSignum2 || dirYSignum1 != dirYSignum2)
      {
        myDirectionX = 0;
        myDirectionY = 0;
      }
    }
  }*/

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
