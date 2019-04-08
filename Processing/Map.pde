/*
@Author: Liam Gardner
@Date: Hmmm.....March 26, 2019! Maybe!
@Purpose: Did you know there's this really cool thing called perlin noise? that's been updated like 60 times by the author?
          Well guess which version processing uses? It's the original!
          I spent countless years turning that original noise algorithm into a class and here's my final result!
*/

class Map {

  public Map() {
    
  }
  /*
  returns a character based on FLOATING POINT COORDINATES!!! --> noise works by a very small step value
  */
  public char get(float x, float y) {
    float val = noise(x, y);
    if (val < 0.25) {
      return ',';
    } else if (val < 0.3) {
      return'$';
    } else if (val < 0.4) {
      return '~';
    } else  if (val < 0.5){
      return '#';
    }else if (val < 0.675){
      return '.';
    }else {
      return '"';
    }
  }
  
  /*
  this is literally just the noise function... I'm not even sure why I did this...
  Okay, so it takes two floats and returns a float... like perlin noise.....
  */
  public float getVal(float x, float y){
    return noise(x,y);
  }
  /*
  this takes in two floats and returns an 'integer' based off it's noise value
  */
  public color getC(float x, float y) {
    float val = noise(x, y);
    if (val < 0.15) {
      return color(0, 0, 150);
    } else if (val < 0.2) {
      return color(0, 0, 200);
    } else if (val < 0.25) {
      return color(0, 100, 255);
    } else if (val < 0.3) {
      return color(255, 243, 0);
    } else if (val < 0.4) {
      return color(0, 200, 0);
    } else if (val < 0.5){
      return color(0, 255, 0);
    }else if (val < 0.6){
      return color(100,100,100);
    }else if (val < 0.625){
      return color(150,150,150);
    }else if (val < 0.65){
      return color(175,175,175);
    }else if (val < 0.675){
      return color(200,200,200);
    }else{
      return color(255,255,255);
    }
  }
}
