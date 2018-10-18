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
  switch (keyCode)
  {
  case 32:
    isAccelerating = true;
    break;
  }
}

public void keyReleased()
{
  switch (keyCode)
  {
  case 32:
    isAccelerating = false;
    break;
  }
}

public void accelerateShip()
{
  if (!isAccelerating)
  {
    spaceship.decelerate(-0.05);
    //println("SLOW");
  }
  else
  {
    spaceship.accelerate(0.2);
    //println("FAST");
  }
  /*
    break;
  case 32:
    //int oldSignumX = (int)Math.signum(spaceship.getDirectionX());
    //int oldSignumY = (int)Math.signum(spaceship.getDirectionY());
    spaceship.accelerate(0.2);
    println("FAST");

    /*if (oldSignumX != (int)Math.signum(spaceship.getDirectionX()))
    {
      spaceship.setDirectionX(0);
    }

    if (oldSignumY != (int)Math.signum(spaceship.getDirectionY()))
    {
      spaceship.setDirectionY(0);
    }
  }*/
}
