/* Author: Samuel Bates
 * Date: 2-27-2019
 * Purpose: To have a class used entirely for skills of the enemy and player
 */
package Entity;

public class Skill {
	String name;
	public Skill() {
		this.name = "";
	}
	public int Heal(int curhealth, int level) {
		int newhealth = 0;
		if(curhealth == 100) {
			newhealth = curhealth;
		}
		if(level == 0) {
			newhealth = curhealth+1;
		}
		else if(level == 100) {
			newhealth = 100;
		}
		else if(level >= 1 && level <= 10) {
			newhealth = curhealth + 1*level;
		}
		else if(level >= 11 && level <= 50) {
			newhealth = curhealth + 1*level;
		}
		else if(level >= 51 && level <= 100) {
			newhealth = curhealth + 1*level;
		}
		if(newhealth >= 100) {
			newhealth = 100;
		}
		return newhealth;
	}
	public int AtkDecr(int curattack, int level) {
		int attack = 0; 
		return attack;
	}
	public int AtkIncr(int curattack, int level) {
		int attack = 0;
		return attack;
	}
}
