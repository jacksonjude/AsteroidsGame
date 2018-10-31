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
