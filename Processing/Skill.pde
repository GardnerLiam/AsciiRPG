/* Author: Samuel Bates
 * Date: 2-27-2019
 * Purpose: To have a class used entirely for skills of the enemy and player
 
 This is a different kind of "leave me out of this"
 */

public class Skill {
  String name;
  public Skill() {
    this.name = "";
  }
  
  public void setName(String name){
    this.name = name;
  }
  
  public String getName(){
    return this.name;
  }
  
  public int heal(int curhealth, int level) {
    int newhealth = 0;
    if(curhealth == 100) {
      newhealth = curhealth;
    }
    if(level == 0) {
      newhealth = curhealth + 1;
    }
    else if(level == 100) {
      newhealth = 100;
    }
    else if(level >= 1 && level <= 10) {
      newhealth = curhealth + 1 * level;
    }
    else if(level >= 11 && level <= 50) {
      newhealth = curhealth + 1 * level;
    }
    else if(level >= 51 && level <= 100) {
      newhealth = curhealth + 1 * level;
    }
    if(newhealth >= 100) {
      newhealth = 100;
    }
    return newhealth;
  }
  
  public int heal(int curhealth, int level, int maxHealth) {
    int newhealth = 0;
    if(curhealth == 100) {
      newhealth = curhealth;
    }
    if(level == 0) {
      newhealth = curhealth + 1;
    }
    else if(level == 100) {
      newhealth = 100;
    }
    else if(level >= 1 && level <= 10) {
      newhealth = curhealth + 1 * level;
    }
    else if(level >= 11 && level <= 50) {
      newhealth = curhealth + 1 * level;
    }
    else if(level >= 51 && level <= 100) {
      newhealth = curhealth + 1 * level;
    }
    if(newhealth >= maxHealth) {
      newhealth = maxHealth;
    }
    return newhealth;
  }
  public int damageDecr(int curattack, int level) {
    int newattack = 0;
    if(level == 0) {
      newattack = curattack - 1;
    }
    else if(level >= 1 && level <= 10) {
      newattack = curattack - 1 * level;
    }
    else if(level >= 11 && level <= 50) {
      newattack = curattack - 1 * level;
    }
    else if(level >= 51 && level <= 100) {
      newattack = curattack - 1 * level;
    }
    else if(level > 100) {
      newattack = curattack - 1 * level;
    }
    if(newattack < 1) {
      newattack = 1;
    }
    return newattack;
  }
  public int damageIncr(int curattack, int level) {
    int newattack = 0;
    if(level == 0) {
      newattack = curattack + 1; 
    }
    else if(level == 100) {
      newattack = 100;
    }
    else if(level >= 1 && level <= 10) {
      newattack = curattack + 1 * level;
    }
    else if(level >= 11 && level <= 50) {
      newattack = curattack + 1 * level;
    }
    else if(level >= 51 && level <= 100) {
      newattack = curattack + 1 * level;
    }
    else if(level > 100) {
      newattack = curattack + 1 * level;
    }
    return newattack;
  }
}
