/*
@Author: Liam Gardner
@Date: 31/3/2019
@Purpose: well it's called passive, I guess it's telling me to be a pacifist? probably not, it's probably saying 'just be passively violent' right?
I basically used this to name integers.
*/
class Passive {
  public static final int RETAIN_DAMAGE = 0;
  public static final int WATER_WALKING = 1;
  public static final int MOUNTAIN_WALKING = 2;

  int type;
  public Passive(int type) {
    this.type = type;
  }
}
