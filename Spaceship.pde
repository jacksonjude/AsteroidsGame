class Spaceship extends Floater
{
  Spaceship()
  {
    myColor = color(0);
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

  public int[] getXCorners() { return xCorners; }
  public int[] getYCorners() { return yCorners; }

  private final int maxDirection = 5;

  private int health = 1;

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

  public void takeDamage(int amount)
  {
    health -= amount;
  }

  public boolean isAlive()
  {
    return health > 0;
  }

  public void show()
  {
    stroke(255);
    super.show();
  }

  private ArrayList<Float> deathAnimationLineCoords = new ArrayList<Float>();

  public void setDeathAnimationLines()
  {
    for (int i=0; i < corners; i+=2)
    {
      float x1, x2, y1, y2;
      x1 = xCorners[i]+myCenterX;
      y1 = yCorners[i]+myCenterY;
      if (i+1 >= corners)
      {
        x2 = xCorners[0]+myCenterX;
        y2 = yCorners[0]+myCenterY;
      }
      else
      {
        x2 = xCorners[i+1]+myCenterX;
        y2 = yCorners[i+1]+myCenterY;
      }

      float middleX = (x1+x2)/2.0;
      float middleY = (y1+y2)/2.0;

      deathAnimationLineCoords.add(x1);
      deathAnimationLineCoords.add(y1);
      deathAnimationLineCoords.add(x2);
      deathAnimationLineCoords.add(y2);
      deathAnimationLineCoords.add(Math.atan(middleY/middleX));
      deathAnimationLineCoords.add(100.0);
    }

  }

  public void updateDeathAnimation()
  {
    for (int i=0; i < deathAnimationLineCoords.size(); i += 6)
    {
      Float lineX1 = deathAnimationLineCoords.get(i);
      Float lineY1 = deathAnimationLineCoords.get(i+1);
      Float lineX2 = deathAnimationLineCoords.get(i+2);
      Float lineY2 = deathAnimationLineCoords.get(i+3);
      Float pointDirection = deathAnimationLineCoords.get(i+4);
      Float fade = deathAnimationLineCoords.get(i+5);

      fade -= 1;
      lineX1 += Math.cos(pointDirection)*0.5;
      lineX2 += Math.cos(pointDirection)*0.5;
      lineY2 += Math.sin(pointDirection)*0.5;
      lineY2 += Math.sin(pointDirection)*0.5;

      deathAnimationLineCoords.set(i, lineX1);
      deathAnimationLineCoords.set(i+1, lineY1);
      deathAnimationLineCoords.set(i+2, lineX2);
      deathAnimationLineCoords.set(i+3, lineY2);
      deathAnimationLineCoords.set(i+5, fade);
    }
  }

  public void showDeathAnimation()
  {
    for (int i=0; i < deathAnimationLineCoords.size(); i += 6)
    {
      Float lineX1 = deathAnimationLineCoords.get(i);
      Float lineY1 = deathAnimationLineCoords.get(i+1);
      Float lineX2 = deathAnimationLineCoords.get(i+2);
      Float lineY2 = deathAnimationLineCoords.get(i+3);
      Float fade = deathAnimationLineCoords.get(i+5);

      stroke(255, fade/100.0);
      line(lineX1, lineY1, lineX2, lineY2);
    }
  }
}
