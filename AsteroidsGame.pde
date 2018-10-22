final char accelerateKey = 'w';
final float spaceshipAccelerateAmount = 0.07;
final float spaceshipDecelerateAmount = 0.02;
final int spaceshipTurnAmount = 5;

Spaceship spaceship;

public void setup()
{
  size(300,300);
  spaceship = new Spaceship();
  spaceship.setX(width/2);
  spaceship.setY(height/2);
}

public void draw()
{
  background(0);
  spaceship.move();
  turnShip();
  accelerateShip();
  spaceship.capMaxDirection();
  spaceship.show();
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
