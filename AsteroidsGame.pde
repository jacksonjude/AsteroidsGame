final char accelerateKey = 'w';
final float spaceshipAccelerateAmount = 0.07;
final float spaceshipDecelerateAmount = 0.02;
final int spaceshipTurnAmount = 5;
final float asteroidSpeedMultiplier = 2.5;

Spaceship spaceship;
ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();

public void setup()
{
  size(600,600);
  spaceship = new Spaceship();
  spaceship.setX(width/2);
  spaceship.setY(height/2);

  int numAsteroids = 15;
  for (int i=0; i < numAsteroids; i++)
  {
    asteroids.add(new Asteroid(Math.random()*asteroidSpeedMultiplier - asteroidSpeedMultiplier/2, Math.random()*asteroidSpeedMultiplier - asteroidSpeedMultiplier/2, Math.random()*2*PI));
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

public void keyPressed()
{
  switch (key)
  {
  case accelerateKey:
    isAccelerating = true;
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
