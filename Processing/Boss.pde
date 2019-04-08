/*
@Author: Liam Gardner
@Date: 4/7/2019 or somewhere within a 2-3 day radius of that
@Purpose: "Imagine having an enemy that's so powerful it has two healthbars" -- every RPG gamedev ever.
Thankfully, every single method here has (or in my case will be) commented in the enemy class in which this inherents 
*/
class Boss extends Enemy {

  public Boss(Player player) {
    super(player);
    this.name = createName(10);
    this.name = name.substring(0, 1).toUpperCase() + name.substring(1);

    this.level = player.level + 5;
    this.health = 200;
    this.maxHealth = 200;

    this.isBoss = true;
  }

  @Override
    public void turn() {
    int val = floor(random(1, 5));
    if (val == 1) {
      health = skill1.heal(health, level, int(maxHealth));
      if (health == maxHealth) {
        text.add(new FadingText("Boss Taunted", width/2-300, height/2+200));
      } else {
        text.add(new FadingText("Boss Healed", width/2-300, height/2+200));
      }
      text.get(text.size()-1).setYOffset(5);
      text.get(text.size()-1).setTextSize(50);
    } else if (val == 2) {
      damage = skill2.damageIncr(damage, level);
      text.add(new FadingText("Boss Increased Damage", width/2-300, height/2+200));
      text.get(text.size()-1).setYOffset(5);
      text.get(text.size()-1).setTextSize(50);
    } else if (val == 3) {
      player.setDamage(skill3.damageDecr(player.getDamage(), level));
      text.add(new FadingText("Your Damage Decreased", width/2-300, height/2+200));
      text.get(text.size()-1).setYOffset(5);
      text.get(text.size()-1).setTextSize(50);
    } else {
      if (this.health > this.maxHealth/2) {
        player.setHealth(player.getHealth()-damage);
        text.add(new FadingText("Boss Attacked", width/2-300, height/2+200));
        text.get(text.size()-1).setYOffset(5);
        text.get(text.size()-1).setTextSize(50);
      } else {
        if (random(5) < 2) {
          player.setHealth(player.getHealth()-(damage*2));
          text.add(new FadingText("Boss Raged", width/2-300, height/2+200));
          text.get(text.size()-1).setYOffset(5);
          text.get(text.size()-1).setTextSize(50);
        } else {
          player.setHealth(player.getHealth()-damage);
          text.add(new FadingText("Boss Attacked", width/2-300, height/2+200));
          text.get(text.size()-1).setYOffset(5);
          text.get(text.size()-1).setTextSize(50);
        }
      }
    }
  }

  @Override
    void drawStats(int x, int y) {
    fill(255);
    text("Boss: " + name, width/2-100, y-25);
    textFont(map_font);
    text("Enemy Boss: ", x, y-25);
    color from0 = color(0, 100, 0);
    color to0 = color(0, 255, 0);
    color from1 = color(100, 0, 0);
    color to1 = color(255, 0, 0);

    color from2 = color(100, 0, 100);
    color to2 = color(255, 0, 255);

    if (health > 100) {
      noStroke();
      fill(to2);
      rect(x, y, 200, 30);
      if (health > 150) {
        color newColor = lerpColor(from0, to0, ((health-100)/100f));
        fill(newColor);
        noStroke();
        rect(x, y, (health-100)*2, 30);
      } else if (health < 150) {
        color newColor = lerpColor(from1, to1, ((health-100)/100f));
        fill(newColor);
        noStroke();
        rect(x, y, (health-100)*2, 30);
      }
    }else{
      noStroke();
      color newColor = lerpColor(from2,to2, health/100f);
      fill(newColor);
      rect(x,y,health*2,30);
    }

    fill(0, 255, 0);
    text("Boss Level: " + level, width/2-100, y);
    fill(255, 255, 255);
    textFont(map_font);
    textSize(35);
    text("Boss Damage: " + damage, width-500, 500);
  }
}
