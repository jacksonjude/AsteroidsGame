class Asteroid extends Floater
{
  private final int asteroidCornerRandom = 10;
  private final int asteroidCornerConstant = 12;
  private final int asteroidDeltaRandom = 5;
  private final int asteroidDeltaConstant = 10;

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

  public Asteroid(double directionX, double directionY, double pointDirection, int asteroidSize)
  {
    myColor = color(0);

    this.myDirectionX = directionX/asteroidSize;
    this.myDirectionY = directionY/asteroidSize;
    this.myPointDirection = pointDirection;

    this.myCenterX = (Math.random()*width)-(width/2);
    this.myCenterY = (Math.random()*height)-(height/2);

    corners = (int)(Math.random()*asteroidCornerRandom)+asteroidCornerConstant;
    xCorners = new int[corners];
    yCorners = new int[corners];

    float rotationOn = 0;
    for (int i=0; i < corners; i++)
    {
      rotationOn += 2*PI / corners;
      xCorners[i] = (int)(asteroidSize*((Math.random()*asteroidDeltaRandom)+asteroidDeltaConstant)*cos(rotationOn));
      yCorners[i] = (int)(asteroidSize*((Math.random()*asteroidDeltaRandom)+asteroidDeltaConstant)*sin(rotationOn));
    }
  }

  public void show()
  {
    stroke(color(255));
    super.show();
  }

  public boolean doesIntersect(Floater floater)
  {
    return pnpoly(corners, xCorners, yCorners, (int)floater.getX(), (int)floater.getY());
  }

  boolean pnpoly(int nvert, int[] vertx, int[] verty, int testx, int testy)
  {
    int i, j;
    boolean c = false;
    for (i = 0, j = nvert-1; i < nvert; j = i++) {
      if ( ((verty[i]>testy) != (verty[j]>testy)) &&
       (testx < (vertx[j]-vertx[i]) * (testy-verty[i]) / (verty[j]-verty[i]) + vertx[i]) )
         c = !c;
    }
    return c;
  }
}
