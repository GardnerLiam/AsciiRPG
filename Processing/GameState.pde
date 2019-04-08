/* Author: Samuel Bates
 * Date: 3-31-2019
 * Purpose: To have a class used entirely for skills of the enemy and player
 
 
 Hmmm. Something seems familiar about this. I can't seem to put my finger on it though.
 OH! Maybe I should've actually put draw in here. or at least segments of it! That would've been smart!
 Good job on this btw. It looks great!
 */
public class GameState {
  public static final int MENU = 0;
  public static final int ROAMING = 1;
  public static final int FIGHTING = 2;
  public static final int DEAD = 3;
  public static final int LEVELUP = 4;
  public static final int LOADING = 5;

  int state;

  public GameState() {
    state = GameState.LOADING;
  }
  public int getGameState() {
    return state;
  }
  public void setGameState(int newGameState) {
    state = newGameState;
  }
  public void changeState() {
    state++;
  }
}
