class Star
{
  public static final int maxStarOpacity = 220;
  public static final int minStarOpacity = 70;
  public static final int starOpacityRandom = 5;
  public static final int starOpacityConstant = 2;

  private float myX, myY;
  private float starSize;
  private int myOpacity = ((int)(Math.random()*2) == 1 ? maxStarOpacity : minStarOpacity);
  private int myOpacityDirection = (myOpacity == maxStarOpacity ? -1 : 1);
  public Star()
  {
    myX = (float)Math.random()*width;
    myY = (float)Math.random()*height;
    starSize = 2;
  }

  public void randomizeStarFill()
  {
    //starSize += (float)((Math.random()*0.75) - 0.35);
    myOpacity += ((int)(Math.random()*starOpacityRandom)+starOpacityConstant)*myOpacityDirection;

    if (myOpacity <= minStarOpacity || myOpacity >= maxStarOpacity)
    {
      myOpacityDirection = -1*myOpacityDirection;
    }

    if (myOpacity <= minStarOpacity)
    {
      myOpacity = minStarOpacity+1;
    }

    if (myOpacity >= maxStarOpacity)
    {
      myOpacity = maxStarOpacity-1;
    }
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
