/* Author: Samuel Bates
 * Date: 2-27-2019
 * Purpose: To have a class used entirely for skills of the enemy and player
 
 Okay so I am REALLY tired right now. I've had like 3 cups of coffee and it has done nothing.
 Sorry Sam. I edited your enemy class. Like A Lot. We didn't really need accessors and mutators, did we? Good Job though!
 */

public class Enemy {


  String name;
  int health;
  float xp;
  int damage;
  int level;
  float maxHealth;

  Skill skill1 = new Skill();
  Skill skill2 = new Skill();
  Skill skill3 = new Skill();
  
  boolean isBoss;

  public Enemy(Player player) {
    name = createName(round(random(3, 5)));
    name = name.substring(0, 1).toUpperCase() + name.substring(1);
    if (random(0,1) < 0.25){
      name += "n";
    }
    isBoss = false;

    if (player.level < 3) {
      level = 1;
    } else if (player.level < 5) {
      level = floor(random(1, 3));
    } else if (player.level < 10) {
      level = floor(random(1, 10));
    } else {
      level = abs(round(random(player.getLevel()-3, player.getLevel()+3)));
    }
    if (level < 2) {
      health = 25;
      maxHealth = 25;
    } else if (level < 3) {
      health = 50;
      maxHealth = 50;
    } else if (level < 5) {
      health = 75;
      maxHealth = 75;
    } else {
      health = 100;
      maxHealth = 100;
    }

    xp = 10 * level;

    skill1.setName("Heal");
    skill2.setName("Atk+");
    skill3.setName("Atk-");

    damage = 1;
  }

  //Okay so since we didn't really need accessors and mutators I'm leaving them uncommented.
  //Also this isn't -- or shouldn't be -- my code to comment, so... whatever?

  public int getLevel() {
    return level;
  }

  public void setLevel(int newLevel) {
    level = newLevel;
  }

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public int getHealth() {
    return health;
  }

  public void setHealth(int health) {
    this.health = health;
  }

  public int getDamage() {
    return damage;
  }

  public void setDamage(int damage) {
    this.damage = damage;
  }

  public Skill getSkill1() {
    return skill1;
  }

  public void setSkill1(Skill skill1) {
    this.skill1 = skill1;
  }

  public Skill getSkill2() {
    return skill2;
  }

  public void setSkill2(Skill skill2) {
    this.skill2 = skill2;
  }

  public Skill getSkill3() {
    return skill3;
  }

  public void setSkill3(Skill skill3) {
    this.skill3 = skill3;
  }


  /*
  Now This. This is *my* code.
  When you fight someone in real life. you know how all the sudden, this green bar appears over their head and slowly turns red and shrinks when they get hit? no? just me? well it's here now too!
  Along with that, you can see the enemy level and name!
  all for the price of two integer coordinates for drawing reference.
  Your coordinates are consumed by the 'voids' of hell and are never returned! mwahahahahhah!  
  */
  void drawStats(int x, int y) {
    fill(255);
    text("Enemy: " + name, width/2-100, y-25);
    textFont(map_font);
    text("Enemy Health: ", x, y-25);
    if (enemy.getHealth() > enemy.maxHealth/2) {
      color from = color(0, 100, 0);
      color to = color(0, 255, 0);
      color newCol = lerpColor(from, to, (enemy.getHealth()/enemy.maxHealth));
      fill(newCol);
    } else {
      color from = color(100, 0, 0);
      color to = color(255, 0, 0);
      color newCol = lerpColor(from, to, (enemy.getHealth()/enemy.maxHealth));
      fill(newCol);
    }
    noStroke();
    rect(x, y, enemy.getHealth()*2, 30);
    fill(0, 255, 0);
    text("Enemy Level: " + level, width/2-100, y);
    fill(255, 255, 255);
    textFont(map_font);
    textSize(35);
    text("Enemy Damage: " + damage, width-500, 500);
  }

  /*
  so as per standard combat, you can only hit someone once before they hit you back. Wait... I'm being told that's just me again. I should get into fights more often!
  This method allows the enemy to take it's turn deciding what to do and acting upon it's decision. ITS AN AI!!!
  takes nothing and returns nothing.
  */
  public void turn() {
    int val = floor(random(1, 5));
    if (val == 1) {
      health = skill1.heal(health, level, int(maxHealth));
      if (health == maxHealth) {
        text.add(new FadingText("Enemy Taunted", width/2-300, height/2+200));
      } else {
        text.add(new FadingText("Enemy Healed", width/2-300, height/2+200));
      }
      text.get(text.size()-1).setYOffset(5);
      text.get(text.size()-1).setTextSize(50);
    } else if (val == 2) {
      damage = skill2.damageIncr(damage, level);
      text.add(new FadingText("Enemy Increased Damage", width/2-300, height/2+200));
      text.get(text.size()-1).setYOffset(5);
      text.get(text.size()-1).setTextSize(50);
    } else if (val == 3) {
      player.setDamage(skill3.damageDecr(player.getDamage(), level));
      text.add(new FadingText("Your Damage Decreased", width/2-300, height/2+200));
      text.get(text.size()-1).setYOffset(5);
      text.get(text.size()-1).setTextSize(50);
    } else {
      player.setHealth(player.getHealth()-damage);
      text.add(new FadingText("Enemy Attacked", width/2-300, height/2+200));
      text.get(text.size()-1).setYOffset(5);
      text.get(text.size()-1).setTextSize(50);
    }
  }
}
