final char accelerateKey = 87;
final float spaceshipAccelerateAmount = 0.07;
final float spaceshipDecelerateAmount = 0.007;
final int spaceshipTurnAmount = 5;
final char fireBulletKey = 32;
final int bulletFireRate = 20;
final float bulletSpeed = 5.0;
final char turnLeftKey = 65;
final char turnRightKey = 68;
final char hyperspaceKey = 72;

private float asteroidSpeedMultiplier = 4;

Spaceship spaceship;
ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();
ArrayList<Bullet> bullets = new ArrayList<Bullet>();
ArrayList<Star> stars = new ArrayList<Star>();

private int gameScore = 0;

public void setup()
{
  size(600,600);

  setupShip();
  createAsteroids();
  createStars();
}

public void setupShip()
{
  spaceship = new Spaceship();
  spaceship.setX(width/2);
  spaceship.setY(height/2);
}

public void createAsteroids()
{
  int numAsteroids = 10;
  for (int i=0; i < numAsteroids; i++)
  {
    asteroids.add(new Asteroid(Math.random()*asteroidSpeedMultiplier - asteroidSpeedMultiplier/2, Math.random()*asteroidSpeedMultiplier - asteroidSpeedMultiplier/2, Math.random()*2*PI, (int)(Math.random()*2)+2));
  }
}

public void createStars()
{
  int numStars = 30;
  for (int i=0; i < numStars; i++)
  {
    stars.add(new Star());
  }
}

public void draw()
{
  background(0);

  updateStars();
  updateShip();
  updateAsteroids();
  updateBullets();
  updateScores();
}

public void updateShip()
{
  if (spaceship.isAlive())
  {
    spaceship.move();
    turnShip();
    accelerateShip();
    spaceship.capMaxDirection();
    spaceship.show();
  }
  else if (!spaceship.finishedDeathAnimation())
  {
    spaceship.updateDeathAnimation();
    spaceship.showDeathAnimation();
  }
}

public void updateAsteroids()
{
  for (int i=0; i < asteroids.size(); i++)
  {
    asteroids.get(i).move();
    asteroids.get(i).show();

    for (int k=0; k < spaceship.getXCorners().length; k++)
    {
      if (spaceship.isAlive() && asteroids.get(i).doesIntersectAtPoint(spaceship.getXCorners()[k] + spaceship.getX(), spaceship.getYCorners()[k] + spaceship.getY()))
      {
        splitAsteroid(asteroids.get(i), spaceship);
        spaceship.takeDamage(1);
        asteroids.remove(i);
      }
    }

    for (int j=0; j < bullets.size(); j++)
    {
      if (spaceship.isAlive() && j < bullets.size() && i < asteroids.size() && asteroids.get(i).doesIntersect(bullets.get(j)))
      {
        if (asteroids.get(i).getSize() > 1)
        {
          splitAsteroid(asteroids.get(i), bullets.get(j));
        }

        asteroids.remove(i);
        bullets.remove(j);
        gameScore += 1;

        if (asteroids.size() == 0)
        {
          newLevel();
        }
      }
    }
  }
}

public void splitAsteroid(Asteroid asteroid, Floater crasher)
{
  double asteroidDirectionX = asteroid.getDirectionX();
  double asteroidDirectionY = asteroid.getDirectionY();
  double crasherDirectionX = crasher.getDirectionX()/5;
  double crasherDirectionY = crasher.getDirectionY()/5;

  double netDirectionX = asteroidDirectionX + crasherDirectionX;
  double netDirectionY = asteroidDirectionY + crasherDirectionY;
  double netDirection = Math.sqrt(Math.pow(asteroidDirectionX, 2) + Math.pow(asteroidDirectionY, 2));

  double asteroidPointDirection = asteroid.getPointDirection();
  double bulletPointDirection = crasher.getPointDirection();
  double newAsteroidPointDirection = (asteroidPointDirection + bulletPointDirection)/2;
  Asteroid asteroid1 = new Asteroid(netDirectionX, netDirectionY, newAsteroidPointDirection, asteroid.getSize()-1);
  Asteroid asteroid2 = new Asteroid(netDirection * Math.cos(-newAsteroidPointDirection), netDirection * Math.sin(-newAsteroidPointDirection), newAsteroidPointDirection, asteroid.getSize()-1);

  asteroid1.setX(asteroid.getX());
  asteroid1.setY(asteroid.getY());
  asteroid2.setX(asteroid.getX());
  asteroid2.setY(asteroid.getY());
  asteroids.add(asteroid1);
  asteroids.add(asteroid2);
}

public void updateBullets()
{
  if (spaceship.isAlive())
  {
    if (isFiring && rechargeTime == 0)
    {
      rechargeTime = bulletFireRate;
      bullets.add(new Bullet((double)spaceship.getX(), (double)spaceship.getY(), spaceship.getPointDirection(), bulletSpeed));
    }

    if (rechargeTime > 0)
    {
      rechargeTime -= 1;
    }
    if (rechargeTime < 0)
    {
      rechargeTime = 0;
    }

    for (int i=0; i < bullets.size(); i++)
    {
      if (bullets.get(i).shouldDelete())
      {
        bullets.remove(i);
        continue;
      }
      bullets.get(i).move();
      bullets.get(i).show();
    }
  }
}

public void mousePressed()
{
  if (mouseButton == LEFT)
  {
    isFiring = true;
    if (rechargeTime <= 0)
    {
      updateBullets();
    }
  }
}

public void mouseReleased()
{
  if (mouseButton == LEFT)
  {
    isFiring = false;

    if (rechargeTime <= 0)
    {
      rechargeTime = bulletFireRate;
    }
  }
}

public void turnShip()
{
  switch (turningSpaceship)
  {
  case LEFT:
    spaceship.turn(-spaceshipTurnAmount);
    break;
  case RIGHT:
    spaceship.turn(spaceshipTurnAmount);
    break;
  }
}

private final int newGameBlinkSpeed = 120;
private final int newGameBlinkOffset = 90;
private int gameOverOffsetFrame = 0;
private int gameOverFrame = 0;

public void updateScores()
{
  if (spaceship.isAlive())
  {
    textSize(25);
    textAlign(LEFT);
    fill(255);
    text(gameScore, 5, 30);
  }
  else if (spaceship.finishedDeathAnimation())
  {
    if (gameOverOffsetFrame == 0)
    {
      gameOverOffsetFrame = frameCount + newGameBlinkOffset;
    }
    gameOverFrame += 1;

    textSize(40);
    textAlign(CENTER);
    fill(255);
    text("G A M E   O V E R", width/2, height/2 - 40/2);

    textSize(20);
    textAlign(CENTER);
    fill(255);
    text("SCORE: " + gameScore, width/2, height/2 + 15/2);

    if (gameOverFrame > newGameBlinkOffset && (frameCount - gameOverOffsetFrame) % newGameBlinkSpeed > newGameBlinkSpeed/2)
    {
      textSize(15);
      textAlign(CENTER);
      fill(255);
      text("Press SPACE", width/2, height/2 + 55/2);
    }
  }
}

private boolean isAccelerating = false;
private float fireFrameOffset;
private boolean isFiring = false;
private int rechargeTime = 0;
private int turningSpaceship = 0;

public void keyPressed()
{
  switch (keyCode)
  {
  case accelerateKey:
    isAccelerating = true;
    break;
  case fireBulletKey:
    if (spaceship.isAlive() && !isFiring)
    {
      isFiring = true;
      fireFrameOffset = frameCount % bulletFireRate + 1;
    }

    if (!spaceship.isAlive() && spaceship.finishedDeathAnimation())
    {
      resetGame();
    }
    break;
  case turnLeftKey:
    turningSpaceship = LEFT;
    break;
  case turnRightKey:
    turningSpaceship = RIGHT;
    break;
  case hyperspaceKey:
    spaceship.setX((int)(Math.random()*width));
    spaceship.setY((int)(Math.random()*height));
    spaceship.setDirectionX(0);
    spaceship.setDirectionY(0);
  }
}

public void keyReleased()
{
  switch (keyCode)
  {
  case accelerateKey:
    isAccelerating = false;
    break;
  case fireBulletKey:
    isFiring = false;
    break;
  case turnLeftKey:
  case turnRightKey:
    turningSpaceship = 0;
  }
}

public void accelerateShip()
{
  if (!isAccelerating)
  {
    spaceship.decelerate(spaceshipDecelerateAmount);
  }
  else
  {
    spaceship.accelerate(spaceshipAccelerateAmount);
  }
}

public void resetGame()
{
  spaceship.setX(width/2);
  spaceship.setY(height/2);
  spaceship.setDirectionX(0);
  spaceship.setDirectionY(0);
  spaceship.setPointDirection(0);
  spaceship.setHealth(1);

  asteroids.removeAll(asteroids);
  createAsteroids();

  bullets.removeAll(bullets);

  gameScore = 0;

  gameOverOffsetFrame = 0;
}

public void newLevel()
{
  asteroidSpeedMultiplier += 1.618;
  createAsteroids();
  bullets.removeAll(bullets);
}

public void updateStars()
{
  for (int i=0; i < stars.size(); i++)
  {
    stars.get(i).randomizeStarFill();
    stars.get(i).show();
  }
}

abstract class Floater //Do NOT modify the Floater class! Make changes in the Spaceship class
{
  protected int corners;  //the number of corners, a triangular floater has 3
  protected int[] xCorners;
  protected int[] yCorners;
  protected int myColor;
  protected double myCenterX, myCenterY; //holds center coordinates
  protected double myDirectionX, myDirectionY; //holds x and y coordinates of the vector for direction of travel
  protected double myPointDirection; //holds current direction the ship is pointing in degrees
  abstract public void setX(int x);
  abstract public int getX();
  abstract public void setY(int y);
  abstract public int getY();
  abstract public void setDirectionX(double x);
  abstract public double getDirectionX();
  abstract public void setDirectionY(double y);
  abstract public double getDirectionY();
  abstract public void setPointDirection(int degrees);
  abstract public double getPointDirection();
  abstract public int[] getXCorners();
  abstract public int[] getYCorners();

  //Accelerates the floater in the direction it is pointing (myPointDirection)
  public void accelerate (double dAmount)
  {
    //convert the current direction the floater is pointing to radians
    double dRadians =myPointDirection*(Math.PI/180);
    //change coordinates of direction of travel
    myDirectionX += ((dAmount) * Math.cos(dRadians));
    myDirectionY += ((dAmount) * Math.sin(dRadians));
  }
  public void turn (int nDegreesOfRotation)
  {
    //rotates the floater by a given number of degrees
    myPointDirection+=nDegreesOfRotation;
  }
  public void move ()   //move the floater in the current direction of travel
  {
    //change the x and y coordinates by myDirectionX and myDirectionY
    myCenterX += myDirectionX;
    myCenterY += myDirectionY;

    //wrap around screen
    if(myCenterX >width)
    {
      myCenterX = 0;
    }
    else if (myCenterX<0)
    {
      myCenterX = width;
    }
    if(myCenterY >height)
    {
      myCenterY = 0;
    }

    else if (myCenterY < 0)
    {
      myCenterY = height;
    }
  }
  public void show ()  //Draws the floater at the current position
  {
    fill(myColor);
    //stroke(myColor);

    //translate the (x,y) center of the ship to the correct position
    translate((float)myCenterX, (float)myCenterY);

    //convert degrees to radians for rotate()
    float dRadians = (float)(myPointDirection*(Math.PI/180));

    //rotate so that the polygon will be drawn in the correct direction
    rotate(dRadians);

    //draw the polygon
    beginShape();
    for (int nI = 0; nI < corners; nI++)
    {
      vertex(xCorners[nI], yCorners[nI]);
    }
    endShape(CLOSE);

    //"unrotate" and "untranslate" in reverse order
    rotate(-1*dRadians);
    translate(-1*(float)myCenterX, -1*(float)myCenterY);
  }
}


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

  public int[] getXCorners() { return xCorners; }
  public int[] getYCorners() { return yCorners; }

  public int getSize() { return asteroidSize; }

  private int asteroidSize;

  public Asteroid(double directionX, double directionY, double pointDirection, int asteroidSize)
  {
    myColor = color(0);

    this.myDirectionX = directionX/asteroidSize;
    this.myDirectionY = directionY/asteroidSize;
    this.myPointDirection = pointDirection;

    this.myCenterX = (Math.random()*width)-(width/2);
    this.myCenterY = (Math.random()*height)-(height/2);

    this.asteroidSize = asteroidSize;

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
    boolean intersection = false;
    for (int k=0; k < floater.getXCorners().length; k++)
    {
      if (doesIntersectAtPoint(floater.getXCorners()[k] + floater.getX(), floater.getYCorners()[k] + floater.getY()))
      {
        intersection = true;
      }
    }
    return intersection;
  }

  public boolean doesIntersectAtPoint(int x, int y)
  {
    int[] xVertex = new int[corners];
    int[] yVertex = new int[corners];
    float dRadians = (float)(myPointDirection*(Math.PI/180));
    for (int i=0; i < corners; i++)
    {
      xVertex[i] = (int)(xCorners[i]*Math.cos(dRadians) - yCorners[i]*Math.sin(dRadians)) + (int)myCenterX;
      yVertex[i] = (int)(xCorners[i]*Math.sin(dRadians) + yCorners[i]*Math.cos(dRadians)) + (int)myCenterY;
    }

    return pnpoly(corners, xVertex, yVertex, x, y);
  }

  boolean pnpoly(int nvert, int[] vertx, int[] verty, int testx, int testy)
  {
    int i, j;
    boolean c = false;
    for (i = 0, j = nvert-1; i < nvert; j = i++) {
      if (((verty[i]>testy) != (verty[j]>testy)) && (testx < (vertx[j]-vertx[i]) * (testy-verty[i]) / (verty[j]-verty[i]) + vertx[i]))
      {
        c = !c;
      }
    }
    return c;
  }
}

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
}

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

  public void setHealth(int health) { this.health = health; }

  private final int maxDirection = 5;

  private int health = 1;

  public void capMaxDirection()
  {
    if (Math.abs(myDirectionX) > maxDirection)
    {
      myDirectionX = maxDirection * signum(myDirectionX);
    }

    if (Math.abs(myDirectionY) > maxDirection)
    {
      myDirectionY = maxDirection * signum(myDirectionY);
    }
  }

  public void decelerate(double dAmount)
  {
    if (myDirectionX != 0 && myDirectionY != 0)
    {
      int dirXSignum1 = (int)signum(myDirectionX);
      int dirYSignum1 = (int)signum(myDirectionY);

      double totalDirection = Math.sqrt(Math.pow(myDirectionX, 2) + Math.pow(myDirectionY, 2));
      double dRadians = atan((float)(myDirectionY/myDirectionX));
      totalDirection -= dAmount;
      myDirectionX = (signum(myDirectionX))*Math.abs(Math.cos(dRadians)*totalDirection);
      myDirectionY = (signum(myDirectionY))*Math.abs(Math.sin(dRadians)*totalDirection);

      int dirXSignum2 = (int)signum(myDirectionX);
      int dirYSignum2 = (int)signum(myDirectionY);

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

  public boolean isAlive() { return health > 0; }

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
      float x11, x21, y11, y21;
      x11 = (float)(xCorners[i]);
      y11 = (float)(yCorners[i]);
      if (i+1 >= corners)
      {
        x21 = (float)(xCorners[0]);
        y21 = (float)(yCorners[0]);
      }
      else
      {
        x21 = (float)(xCorners[i+1]);
        y21 = (float)(yCorners[i+1]);
      }

      float x1, x2, y1, y2;
      float dRadians = (float)(myPointDirection*(Math.PI/180));
      x1 = (float)((x11*Math.cos(dRadians) - y11*Math.sin(dRadians)));
      y1 = (float)((x11*Math.sin(dRadians) + y11*Math.cos(dRadians)));
      x2 = (float)((x21*Math.cos(dRadians) - y21*Math.sin(dRadians)));
      y2 = (float)((x21*Math.sin(dRadians) + y21*Math.cos(dRadians)));

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
      deathAnimationLineCoords.add(255.0);
      deathAnimationLineCoords.add((float)Math.random()*0.7);
    }
  }

  public void updateDeathAnimation()
  {
    for (int i=0; i < deathAnimationLineCoords.size(); i += 7)
    {
      Float lineX1 = deathAnimationLineCoords.get(i);
      Float lineY1 = deathAnimationLineCoords.get(i+1);
      Float lineX2 = deathAnimationLineCoords.get(i+2);
      Float lineY2 = deathAnimationLineCoords.get(i+3);
      Float pointDirection = deathAnimationLineCoords.get(i+4);
      Float fade = deathAnimationLineCoords.get(i+5);
      Float randomMultiplier = deathAnimationLineCoords.get(i+6);

      fade -= 2.55;
      lineX1 += (float)(Math.cos(pointDirection)*randomMultiplier);
      lineX2 += (float)(Math.cos(pointDirection)*randomMultiplier);
      lineY1 += (float)(Math.sin(pointDirection)*randomMultiplier);
      lineY2 += (float)(Math.sin(pointDirection)*randomMultiplier);

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
        deathAnimationLineCoords.remove(i);
      }
    }
  }

  public void showDeathAnimation()
  {
    for (int i=0; i < deathAnimationLineCoords.size(); i += 7)
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

  public boolean finishedDeathAnimation()
  {
    return deathAnimationLineCoords.size() == 0;
  }
}

class Star
{
  float myX, myY;
  float starSize;
  int myOpacity;
  public Star()
  {
    myX = (float)Math.random()*width;
    myY = (float)Math.random()*height;
    starSize = 2;
  }

  public void randomizeStarFill()
  {
    //starSize += (float)((Math.random()*0.75) - 0.35);
    myOpacity = (int)(Math.random()*100);
  }

  public void show()
  {
    stroke(255, myOpacity);
    fill(255, myOpacity);
    ellipse(myX, myY, starSize, starSize);
    //triangle(myX - starSize/4, myY - starSize/4, myX - starSize/4, myY + starSize/4, myX - starSize, myY);
    //triangle(myX + starSize/4, myY - starSize/4, myX + starSize/4, myY + starSize/4, myX + starSize, myY);
    //triangle(myX - starSize/4, myY + starSize/4, myX + starSize/4, myY + starSize/4, myX, myY - starSize);
    //triangle(myX - starSize/4, myY - starSize/4, myX + starSize/4, myY - starSize/4, myX, myY + starSize);
    //quad(myX - starSize/4, myY - starSize/4, myX + starSize/4, myY - starSize/4, myX + starSize/4, myY + starSize/4, myX - starSize/4, myY + starSize/4);
  }
}

public int signum(double num)
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
