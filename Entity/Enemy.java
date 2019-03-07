/* Author: Samuel Bates
 * Date: 2-27-2019
 * Purpose: To have a class used entirely for skills of the enemy and player
 */
package Entity;

public class Enemy {
	
	String name;
	int health;
	int damage;
	Skill skill1 = new Skill();
	Skill skill2 = new Skill();
	Skill skill3 = new Skill();
	
	public Enemy() {
		
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
	
}