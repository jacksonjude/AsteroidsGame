class Bullet extends Floater
{
  private float decay = 100.0;

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

  public Bullet(double centerX, double centerY, double pointDirection, float bulletSpeed)
  {
    this.myCenterX = centerX;
    this.myCenterY = centerY;
    this.myPointDirection = pointDirection;
    this.myDirectionX = bulletSpeed*Math.cos(myPointDirection*(Math.PI/180));
    this.myDirectionY = bulletSpeed*Math.sin(myPointDirection*(Math.PI/180));
  }

  public void show()
  {
    decay -= 1.0;
    myColor = color(255, decay/100.0);
    super.show();
  }

  public boolean shouldDelete()
  {
    return decay <= 0.0;
  }
}
