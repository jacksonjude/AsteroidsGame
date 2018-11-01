final char accelerateKey = 87;
final float spaceshipAccelerateAmount = 0.07;
final float spaceshipDecelerateAmount = 0.01;
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

  asteroids = new ArrayList<Asteroid>();
  createAsteroids();

  bullets = new ArrayList<Bullet>();

  gameScore = 0;

  gameOverOffsetFrame = 0;
}

public void newLevel()
{
  asteroidSpeedMultiplier += 1.618;
  createAsteroids();
  bullets = new ArrayList<Bullet>();
}

public void updateStars()
{
  for (int i=0; i < stars.size(); i++)
  {
    stars.get(i).randomizeStarFill();
    stars.get(i).show();
  }
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
