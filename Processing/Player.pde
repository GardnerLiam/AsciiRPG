/* Author: Samuel Bates
* Date: 2-27-2019
* Purpose: To have a class used entirely for skills of the enemy and player

Boy was this a handful to work with. Is handful the right expression to use here? I'm not sure...
All I did here was make things floats and add a hashmap for items... It's not my place to do the work of others (Unless I can get paid for it. but what are the chances of that...)
Looks good though, good job!
*/

public class Player {

  String name;
  int health;
  float xp;
  int damage;
  int level;
  float x;
  float y;
  Skill skill1;
  Skill skill2;
  Skill skill3;

  Item sneak = new Item("Sneak", 0);
  Item kill = new Item("Kill", 1);
  Item heal = new Item("Heal", 2);
  Item weaken = new Item("Weaken", 3);
  Item water = new Item("Water", 4);
  Item pandora = new Item("Pandora", 5);
  
  Passive passive;
  int waterWalkingSteps = 0;
  
  int sneakSteps;
  
  HashMap<Integer, Integer> items;
  
  public Player() {
    skill1 = new Skill();
    skill2 = new Skill();
    skill3 = new Skill();
    skill1.setName("Heal");
    skill2.setName("Atk+");
    skill3.setName("Atk-");
    damage = 1;
    passive = new Passive(floor(random(0,3)));
    
    sneakSteps = 0;
    waterWalkingSteps = 0;
    
    items = new HashMap<Integer, Integer>();
    for (int i = 0; i < Item.ITEMS; i++){
      items.put(i,0);
    }
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

  public float getX() {
    return x;
  }

  public void setX(float x) {
    this.x = x;
  }

  public float getY() {
    return y;
  }

  public void setY(float y) {
    this.y = y;
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
  
  public float getXP(){
    return this.xp;
  }
  
  public int getLevel(){
    return this.level;
  }
}
