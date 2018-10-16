//your variable declarations here
Spaceship spaceship;
public void setup()
{
  //your code here
  spaceship = new Spaceship();
  spaceship.setX(width/2);
  spaceship.setY(height/2);
}
public void draw()
{
  //your code here
  spaceship.show();
}
