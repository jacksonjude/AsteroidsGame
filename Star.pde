class Star
{
  public static final int maxStarOpacity = 220;
  public static final int minStarOpacity = 70;
  public static final int starOpacityRandom = 5;
  public static final int starOpacityConstant = 2;

  private float myX, myY;
  private float starSize;
  private int myOpacity = (int)(Math.random()*GameConstants.starOpacityMax)+GameConstants.starOpacityMin;
  private int myOpacityDirection = 1;
  public Star()
  {
    myX = (float)Math.random()*width;
    myY = (float)Math.random()*height;
    starSize = 2;
  }

  public void randomizeStarFill()
  {
    //starSize += (float)((Math.random()*0.75) - 0.35);
    myOpacity += (int)((Math.random()*GameConstants.starOpacityDeltaRandom)+GameConstants.starOpacityDeltaConstant)*myOpacityDirection;
    if (myOpacity > GameConstants.starOpacityMax)
    {
      myOpacityDirection = -1;
      myOpacity = GameConstants.starOpacityMax;
    }

    if (myOpacity < GameConstants.starOpacityMin)
    {
      myOpacityDirection = 1;
      myOpacity = GameConstants.starOpacityMin;
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
