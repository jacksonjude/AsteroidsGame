class Asteroid extends Floater
{
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

  public Asteroid(double myDirectionX, double myDirectionY, double myPointDirection)
  {
    myColor = color(255);

    this.myDirectionX = myDirectionX;
    this.myDirectionY = myDirectionY;
    this.myPointDirection = myPointDirection;

    this.myCenterX = (Math.random()*width)-(width/2);
    this.myCenterY = (Math.random()*width)-(width/2);

    corners = (int)(Math.random()*10)+12;
    xCorners = new int[corners];
    yCorners = new int[corners];

    float rotationOn = 0;
    for (int i=0; i < corners; i++)
    {
      rotationOn += 2*PI / corners;
      xCorners[i] = (int)(((Math.random()*10)+10)*cos(rotationOn));
      yCorners[i] = (int)(((Math.random()*10)+10)*sin(rotationOn));
    }
  }
}
