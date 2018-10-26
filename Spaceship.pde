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
    if (!isAlive())
    {
      setDeathAnimationLines();
    }
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
    for (int i=0; i < corners; i+=1)
    {
      float x1, x2, y1, y2;
      x1 = (float)(xCorners[i]);
      y1 = (float)(yCorners[i]);
      if (i+1 >= corners)
      {
        x2 = (float)(xCorners[0]);
        y2 = (float)(yCorners[0]);
      }
      else
      {
        x2 = (float)(xCorners[i+1]);
        y2 = (float)(yCorners[i+1]);
      }

      float dRadians = (float)(myPointDirection*(Math.PI/180));
      x1 = (float)((x1*Math.cos(dRadians) - y1*Math.sin(dRadians)));
      y1 = (float)((x1*Math.sin(dRadians) + y1*Math.cos(dRadians)));
      x2 = (float)((x2*Math.cos(dRadians) - y2*Math.sin(dRadians)));
      y2 = (float)((x2*Math.sin(dRadians) + y2*Math.cos(dRadians)));

      x1 += myCenterX;
      x2 += myCenterX;
      y1 += myCenterY;
      y2 += myCenterY;

      float middleX = (x1+x2)/2.0;
      float middleY = (y1+y2)/2.0;

      deathAnimationLineCoords.add(x1);
      deathAnimationLineCoords.add(y1);
      deathAnimationLineCoords.add(x2);
      deathAnimationLineCoords.add(y2);
      deathAnimationLineCoords.add((float)Math.atan(middleY/middleX));
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
      lineX1 += (float)Math.cos(pointDirection)*0.1;
      lineX2 += (float)Math.cos(pointDirection)*0.3;
      lineY1 += (float)Math.sin(pointDirection)*0.1;
      lineY2 += (float)Math.sin(pointDirection)*0.3;

      deathAnimationLineCoords.set(i, lineX1);
      deathAnimationLineCoords.set(i+1, lineY1);
      deathAnimationLineCoords.set(i+2, lineX2);
      deathAnimationLineCoords.set(i+3, lineY2);
      deathAnimationLineCoords.set(i+5, fade);

      if (fade < 0)
      {
        deathAnimationLineCoords.remove(i);
        deathAnimationLineCoords.remove(i);
        deathAnimationLineCoords.remove(i);
        deathAnimationLineCoords.remove(i);
        deathAnimationLineCoords.remove(i);
        deathAnimationLineCoords.remove(i);
      }
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

      stroke(255, fade);
      line(lineX1, lineY1, lineX2, lineY2);
    }
  }
}
