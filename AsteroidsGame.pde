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
  spaceship.show();
}

public void keyPressed()
{
  switch (keyCode)
  {
  case LEFT:
    spaceship.setPointDirection((int)spaceship.getPointDirection() - 3);
    break;
  case RIGHT:
    spaceship.setPointDirection((int)spaceship.getPointDirection() + 3);
    break;
  case UP:
    spaceship.accelerate(1.0);
    break;
  case DOWN:
    spaceship.accelerate(-1.0);
    break;
  }
}
