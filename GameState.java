package Entity;

public class GameState {
	public static final int MENU = 0;
	public static final int GAME = 1;
	public static final int SEED = 2;
	public static final int DEAD = 3;
	public static final int PAUSE = 4;
		
	int state;
	
	public GameState(){
	    state = 0;
	}
	public int getGameState(){
	    return state;    
	}
	 public void setGameState(int newGameState){
		state = newGameState;
	}
	 public void changeState(){
		state++;
	}
}
