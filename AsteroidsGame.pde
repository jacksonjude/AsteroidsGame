final char accelerateKey = 87;
final float spaceshipAccelerateAmount = 0.05;
final float spaceshipDecelerateAmount = 0.02;
final int spaceshipTurnAmount = 5;
final float asteroidSpeedMultiplier = 2.5;
final char fireBulletKey = 32;
final int bulletFireRate = 30;
final float bulletSpeed = 5.0;
final char turnLeftKey = 65;
final char turnRightKey = 68;

Spaceship spaceship;
ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();
ArrayList<Bullet> bullets = new ArrayList<Bullet>();

public void setup()
{
  size(600,600);
  spaceship = new Spaceship();
  spaceship.setX(width/2);
  spaceship.setY(height/2);

  int numAsteroids = 15;
  for (int i=0; i < numAsteroids; i++)
  {
    asteroids.add(new Asteroid(Math.random()*asteroidSpeedMultiplier - asteroidSpeedMultiplier/2, Math.random()*asteroidSpeedMultiplier - asteroidSpeedMultiplier/2, Math.random()*2*PI, (int)(Math.random()*3)+1));
  }
}

public void draw()
{
  background(0);

  updateShip();
  updateAsteroids();
  updateBullets();
}

public void updateShip()
{
  spaceship.move();
  turnShip();
  accelerateShip();
  spaceship.capMaxDirection();
  spaceship.show();
}

public void updateAsteroids()
{
  for (int i=0; i < asteroids.size(); i++)
  {
    asteroids.get(i).move();
    asteroids.get(i).show();

    for (int k=0; k < spaceship.getXCorners().length; k++)
    {
      if (asteroids.get(i).doesIntersectAtPoint(spaceship.getXCorners()[k] + spaceship.getX(), spaceship.getYCorners()[k] + spaceship.getY()))
      {
        println("SHIP INT");
      }
    }

    for (int j=0; j < bullets.size(); j++)
    {
      if (j < bullets.size() && i < asteroids.size() && asteroids.get(i).doesIntersect(bullets.get(j)))
      {
        if (asteroids.get(i).getSize() > 1)
        {
          double asteroidDirectionX = asteroids.get(i).getDirectionX();
          double asteroidDirectionY = asteroids.get(i).getDirectionY();
          double bulletDirectionX = bullets.get(j).getDirectionX()/5;
          double bulletDirectionY = bullets.get(j).getDirectionY()/5;

          double netDirectionX = asteroidDirectionX + bulletDirectionX;
          double netDirectionY = asteroidDirectionY + bulletDirectionY;
          double netDirection = Math.sqrt(Math.pow(asteroidDirectionX, 2) + Math.pow(asteroidDirectionY, 2));

          double asteroidPointDirection = asteroids.get(i).getPointDirection();
          double bulletPointDirection = bullets.get(j).getPointDirection();
          double newAsteroidPointDirection = (asteroidPointDirection + bulletPointDirection)/2;
          Asteroid asteroid1 = new Asteroid(netDirectionX, netDirectionY, newAsteroidPointDirection, asteroids.get(i).getSize()-1);
          Asteroid asteroid2 = new Asteroid(netDirection * Math.cos(-newAsteroidPointDirection), netDirection * Math.sin(-newAsteroidPointDirection), newAsteroidPointDirection, asteroids.get(i).getSize()-1);

          asteroid1.setX(asteroids.get(i).getX());
          asteroid1.setY(asteroids.get(i).getY());
          asteroid2.setX(asteroids.get(i).getX());
          asteroid2.setY(asteroids.get(i).getY());
          asteroids.add(asteroid1);
          asteroids.add(asteroid2);
        }

        asteroids.remove(i);
        bullets.remove(j);
      }
    }
  }
}

public void updateBullets()
{
  if (isFiring && ((frameCount % bulletFireRate - fireFrameOffset) == 0))
  {
    bullets.add(new Bullet((double)spaceship.getX(), (double)spaceship.getY(), spaceship.getPointDirection(), bulletSpeed));
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

public void mousePressed()
{
  if (mouseButton == LEFT)
  {
    isFiring = true;
    fireFrameOffset = frameCount % bulletFireRate + 1;
  }
}

public void mouseReleased()
{
  if (mouseButton == LEFT)
  {
    isFiring = false;
  }
}

public void turnShip()
{
  /*if (!mousePressed)
  {
    return;
  }

  switch (mouseButton)
  {
  case LEFT:
    spaceship.turn(-spaceshipTurnAmount);
    break;
  case RIGHT:
    spaceship.turn(spaceshipTurnAmount);
    break;
  }*/

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

private boolean isAccelerating = false;
private float fireFrameOffset;
private boolean isFiring = false;
private int turningSpaceship = 0;

public void keyPressed()
{
  switch (keyCode)
  {
  case accelerateKey:
    isAccelerating = true;
    break;
  case fireBulletKey:
    if (!isFiring)
    {
      isFiring = true;
      fireFrameOffset = frameCount % bulletFireRate + 1;
    }
    break;
  case turnLeftKey:
    turningSpaceship = LEFT;
    break;
  case turnRightKey:
    turningSpaceship = RIGHT;
    break;
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
