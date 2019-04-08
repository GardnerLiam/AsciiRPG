/*
@Author: Liam Gardner
@Date: today, so that would be... 9/7/2019!
@Purpose: So Maurice told me to add items, well, here's a terribly implemented item class!
*/

class Item {
  public static final int SNEAK = 0;
  public static final int KILL = 1;
  public static final int HEAL = 2;
  public static final int WEAKEN = 3;
  public static final int WATER = 4;
  public static final int PANDORA = 5;

  public static final int ITEMS = 6;
  public static final int MAXITEMID = 5;

  String name;
  int id;

  public Item (String name, int id) {
    this.name = name;
    this.id = id;
  }
  /*
  So you know how whenever you touch an object in the real world it disappears? like a sandwich, or a soul, or someone's innocence? No? why am I so alone...
  Okay, so apparently things don't disappear when you use them, so they don't disappear in this method either! this method just 'helps' the player when they use an item
  */
  public void use() {
    if (id == SNEAK) {
      player.sneakSteps = 500;
    }
    if (id == KILL) {
      if (!enemy.isBoss) {
        enemy.health = 1;
      }
    }
    if (id == HEAL) {
      player.health += 25;
      if (player.health > 100) {
        player.health = 100;
      }
    }
    if (id == WEAKEN) {
      if (!enemy.isBoss) {
        enemy.health/=2;
        enemy.level -= 1;
      }
    }
    if (id == WATER) {
      player.waterWalkingSteps = 250;
    }
    if (id == PANDORA) {
      if (random(0, 1) < 0.5) {
        player.damage += 20;
      } else {
        enemy.health = 200;
        enemy.maxHealth = 200;
        enemy.isBoss = true;
      }
    }
  }
}
