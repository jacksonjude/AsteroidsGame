final char accelerateKey = 'w';
final float spaceshipAccelerateAmount = 0.07;
final float spaceshipDecelerateAmount = 0.02;
final int spaceshipTurnAmount = 5;
final float asteroidSpeedMultiplier = 2.5;
final char fireBulletKey = 'f';
final int bulletFireRate = 50;
final float bulletSpeed = 2.0;

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
  spaceship.move();
  turnShip();
  accelerateShip();
  spaceship.capMaxDirection();
  spaceship.show();

  for (int i=0; i < asteroids.size(); i++)
  {
    asteroids.get(i).move();
    asteroids.get(i).show();
    if (asteroids.get(i).doesIntersect(spaceship))
    {

    }

    for (int j=0; j < bullets.size(); j++)
    {
      if (asteroids.get(i).doesIntersect(bullets.get(j)))
      {

      }
    }
  }

  if (isFiring && ((frameCount % bulletFireRate - fireFrameOffset) == 0))
  {
    bullets.add(new Bullet((double)spaceship.getX(), (double)spaceship.getY(), spaceship.getPointDirection(), bulletSpeed));
  }

  for (int i=0; i < bullets.size(); i++)
  {
    bullets.get(i).move();
    bullets.get(i).show();
  }
}

public void turnShip()
{
  if (!mousePressed)
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
  }
}

private boolean isAccelerating = false;
private float fireFrameOffset;
private boolean isFiring = false;

public void keyPressed()
{
  switch (key)
  {
  case accelerateKey:
    isAccelerating = true;
    break;
  case fireBulletKey:
    isFiring = true;
    break;
  }
}

public void keyReleased()
{
  switch (key)
  {
  case accelerateKey:
    isAccelerating = false;
    break;
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
