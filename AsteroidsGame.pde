//your variable declarations here
Spaceship spaceship;

public void setup()
{
  size(300,300);
  //your code here
  spaceship = new Spaceship();
  spaceship.setX(width/2);
  spaceship.setY(height/2);
}

public void draw()
{
  background(0);
  //your code here
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
    spaceship.turn(-5);
    break;
  case RIGHT:
    spaceship.turn(5);
    break;
  }
}

private boolean isAccelerating = false;

public void keyPressed()
{
  switch (key)
  {
  case 'w':
    isAccelerating = true;
    break;
  }
}

public void keyReleased()
{
  switch (key)
  {
  case 'w':
    isAccelerating = false;
    break;
  }
}

public void accelerateShip()
{
  if (!isAccelerating)
  {
    spaceship.decelerate(0.06);
  }
  else
  {
    spaceship.accelerate(0.1);
  }
}
