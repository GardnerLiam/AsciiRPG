/*
@Author: Liam Gardner
@Date: 31/3/2019 probably.
@Purpose: CSS doesn't work with java? Guess I'll have to do everything myself :(
*/
class FadingText {
  int x;
  int y;
  String text;
  int c;
  
  int textSize;
  int yOff;
  public FadingText(String text, int x, int y) {
    this.x = x;
    this.y = y;
    this.text = text;
    this.c = 255;
    this.textSize = 30;
    this.yOff = 2;
  }
  
  /*
  Changes how fast it goes up
  Takes an integer for some reason. I should make that a float. I'll do it later
  returns nothing
  */
  public void setYOffset(int yoff){
    yOff = yoff;
  }
  
  /*
  sets the text size.
  I'm still not sure why I used integers for these. meh, can't be that bad can it?
  returns nothing
  */
  public void setTextSize(int size){
    textSize = size;
  }

  /*
  Updating is like going through life. Actually, this class is like going through life. You're born into this world bright and slowly fade into nothingness while your innocents and purity blackens into disgust.
  That might also be me again... I'm fairly certain it's at least relatable to a few people.
  + there's also the ascension part of it if you're religious. You know, going up to heaven to meet god or whatever.
  
  It takes nothing and it gives nothing... just like life? no? that one doesn't work? alright then... I'm gonna go cry in gameState now.
  */
  public void update() {
    c -= 3;
    fill(c);
    textSize(textSize);
    text(text, x, y);
    y -= yOff;
  }
}
