//Author: Samuel R. Bates
//Purpose: To make a loading screen for our game 
//Date: 2019/04/05
int idx = 0;
int[] indices;
void setup()
{
  size(800, 600);
}
void draw()
{
  showLoading();
}
int loadingX = 10;
void showLoading()
{
  background(250);
  fill(#0000AA);
  text("Please wait, loading...", 10, height / 2);
  ellipse(loadingX, 2 * height / 3, 30, 30);
  loadingX += 10;
  if (loadingX > width - 20)
  {
    loadingX = 10;
  }
}
