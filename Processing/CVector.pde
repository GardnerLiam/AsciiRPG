/*
@Author: Liam Gardner
 @Date: Let's say around a week ago... 31/3/2019
 @Purpose: So Processing has this thing called PVector. PVector can hold 1D coordinates, 2D coordinates and 3D coordinates.
 These coordinates are x,y, and z.
 I don't like that.
 Here's a CVector class for a 3D vector for R,G,B because variable names.
 */

class CVector {

  int r;
  int g;
  int b;

  public CVector(int r, int g, int b) {
    this.r = r;
    this.g = g;
    this.b = b;
  }

  public CVector(int x) {
    this.r = (x>>16)&0xFF;
    this.g = (x>>8)&0xFF;
    this.b = (x>>0)&0xFF;
  }

  /*
  .equals() practicality
   could've probably just converted it to an int and done it that way, but to late now (and by too late I mean I'm not gonna put the effort in)
   it takes in another one of its kind and returns a PASS/FAIL test score on similarity.
   */
  public boolean equals(CVector b) {
    return this.r == b.r && this.g == b.g && this.b == b.b;
  }
  /*
  I wanted to print it. Also printing is just println() in processing! So much easier! and you can comma separate in print statements!
   anyways, this toString() converts it to a string.
   */
  public String toString() {
    return "[" + r + " " + g + " " + b + "]";
  }
  /*
  returns an int called color.
   it's meant to represent the vector "as color" -- heh, see what I did there? It's like 23:00 and I'm tired! It's not my fault I  make bad jokes!
   */
  public int asColor() {
    return color(this.r, this.g, this.b);
  }
  /*
  So you know how when you're a kid, how there's always that one person that you really want to be like?
   This function basically shows a kid learning to become closer and closer to that one person he really wants to be like.
   except as kids don't exist in programming (human at least). It's been done with vectors.
   It just takes small steps. It 'adjusts' itself -- I did it again!
   */
  public void adjust(CVector toEmulate) {
    if (this.r > toEmulate.r) {
      this.r --;
    } else if (this.r < toEmulate.r) {
      this.r++;
    }

    if (this.g > toEmulate.g) {
      this.g --;
    } else if (this.g < toEmulate.g) {
      this.g++;
    }

    if (this.b > toEmulate.b) {
      this.b --;
    } else if (this.b < toEmulate.b) {
      this.b++;
    }
  }
  /*
  I needed it done in a for loop
   */
  public void adjust(CVector toEmulate, int loop) {
    for (int i = 0; i < loop; i++) {
      if (this.r > toEmulate.r) {
        this.r --;
      } else if (this.r < toEmulate.r) {
        this.r++;
      }

      if (this.g > toEmulate.g) {
        this.g --;
      } else if (this.g < toEmulate.g) {
        this.g++;
      }

      if (this.b > toEmulate.b) {
        this.b --;
      } else if (this.b < toEmulate.b) {
        this.b++;
      }
    }
  }
}
//I'M SO CLOSE TO BEING ABLE TO SLEEP!
//SOMEONE SAVE ME FROM THIS ACURSED HELL!
