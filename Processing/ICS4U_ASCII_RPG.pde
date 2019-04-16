/*
@Author: Liam Gardner
@Date: March 26, 2019
@Purpose: This is the 'run' class. I've cried every time I've had to actually go through everything here. 
*/

import processing.sound.*;

Map m;

float encounterPercentage = 0.0075;
float bossEncounterPercentage = 0.001;

int minLevelBossEncounter = 1;

ArrayList<FadingText> text = new ArrayList<FadingText>();

float move = 0.015;

int seed = 0;

int text_scalar;

int display_width;
int display_height;

PFont map_font;
PFont title_font;

Player player;

boolean random_movement = false;
int decision = 0;
int counter = 0;

GameState gameState = new GameState();

Enemy enemy;
boolean enemyExists = false;

Button play;
Button load;
Button exit;

Button attack;
Button skill1;
Button skill2;
Button skill3;

Button Item_SNEAK;
Button Item_KILL;
Button Item_HEAL;
Button Item_WEAKEN;
Button Item_WATER;
Button Item_PANDORA;

FadingText saveText;

int deathResetCounter = 0;

boolean mute = false;

String[] characters = {"ha", "he", "hi", "ho", "fu", "ba", "be", "bi", "bo", "bu", "sa", "se", "shi", "so", "su", "ta", "te", "chi", "to", "tsu", "pa", "pe", "pi", "po", "pu", 
  "ka", "ke", "ki", "ko", "ku", "ra", "re", "ri", "ro", "ru", "ma", "me", "mi", "mo", "mu", "na", "ne", "ni", "no", "nu"};

int levelUpCounter = 0;
boolean dispSave = false;

Music menuMusic;
Music[] gameMusic;
int musicIndex = 0;

float timeStart = millis();

/*
@Name: createName
@Purpose: It'd suck if enemies were named 'slime #467' right? So I have hiragana style generated name!
@Type: takes a size and returns a name of said size
*/
String createName(int size) {
  String name = "";
  for (int i = 0; i < size; i++) {
    name += characters[floor(random(0, characters.length))];
  }
  return name;
}

/*
@Name: setup
@Purpose: bare minimum initialization;
@type: No params -- return None
*/
void setup() {
  fullScreen();
  if (seed == 0) {
    seed = millis();
    println(seed);
  }
  noiseSeed(seed);

  map_font = createFont("courier", 24);
  title_font = createFont("Monotype Corsiva", 50);
}
/*
@Name: Init
@Purpose: Initialize everything that could be initialized apart from the setup function
@Type: No params -- return None
*/
void init() {
  menuMusic = new Music("menuMusic.mp3", this);
  gameMusic = new Music[6];
  gameMusic[0] = new Music("roamingMusic.mp3", this, false);
  gameMusic[1] = new Music("WindsOfStories.wav", this, false);
  gameMusic[2] = new Music("pathToLakeLand.mp3", this, false);
  gameMusic[3] = new Music("oldCityTheme.mp3", this, false);
  gameMusic[4] = new Music("September.wav", this, false);
  gameMusic[5] = new Music("Orchestra.wav", this, false);

  saveText = new FadingText("Saved.", width/2-100, height/2);
  saveText.setTextSize(100);

  play = new Button(width/2-100, height/2-200, 250, 100, 5, color(283, 283, 283), color(150, 150, 150), color(200, 200, 200), color(100, 100, 100), color(0, 0, 0), color(255, 255, 255), "Play", 50, null);
  load = new Button(width/2-100, height/2, 250, 100, 5, color(283, 283, 283), color(150, 150, 150), color(200, 200, 200), color(100, 100, 100), color(0, 0, 0), color(255, 255, 255), "Load", 50, null);
  exit = new Button(width/2-100, height/2+200, 250, 100, 5, color(283, 283, 283), color(150, 150, 150), color(200, 200, 200), color(100, 100, 100), color(0, 0, 0), color(255, 255, 255), "Exit", 50, null);

  Item_SNEAK = new Button(100, 600, 250, 50, 5, color(283, 283, 283), color(150, 150, 150), color(200, 200, 200), color(100, 100, 100), color(0, 0, 0), color(255, 255, 255), "Sneak", 50, null);
  Item_KILL = new Button(100, 700, 250, 50, 5, color(283, 283, 283), color(150, 150, 150), color(200, 200, 200), color(100, 100, 100), color(0, 0, 0), color(255, 255, 255), "Kill", 50, null);
  Item_HEAL = new Button(100, 800, 250, 50, 5, color(283, 283, 283), color(150, 150, 150), color(200, 200, 200), color(100, 100, 100), color(0, 0, 0), color(255, 255, 255), "Heal", 50, null);
  Item_WEAKEN = new Button(450, 600, 250, 50, 5, color(283, 283, 283), color(150, 150, 150), color(200, 200, 200), color(100, 100, 100), color(0, 0, 0), color(255, 255, 255), "Weaken", 50, null);
  Item_WATER = new Button(450, 700, 250, 50, 5, color(283, 283, 283), color(150, 150, 150), color(200, 200, 200), color(100, 100, 100), color(0, 0, 0), color(255, 255, 255), "Water", 50, null);
  Item_PANDORA = new Button(450, 800, 250, 50, 5, color(283, 283, 283), color(150, 150, 150), color(200, 200, 200), color(100, 100, 100), color(0, 0, 0), color(255, 255, 255), "Pandora", 50, null);

  Item_SNEAK.itemButton = true;
  Item_KILL.itemButton = true;
  Item_HEAL.itemButton = true;
  Item_WEAKEN.itemButton = true;
  Item_WATER.itemButton = true;
  Item_PANDORA.itemButton = true;


  play.setTextPos(width/2-25, height/2-135);
  load.setTextPos(width/2-25, height/2+65);
  exit.setTextPos(width/2-25, height/2+265);

  Item_SNEAK.setTextPos(150, 635);
  Item_KILL.setTextPos(150, 735);
  Item_HEAL.setTextPos(150, 835);
  Item_WEAKEN.setTextPos(500, 635);
  Item_WATER.setTextPos(500, 735);
  Item_PANDORA.setTextPos(500, 835);

  play.allowChange = true;
  load.allowChange = true;
  exit.allowChange = true;

  play.menuButton = true;
  load.menuButton = true;
  exit.menuButton = true;

  m = new Map();

  player = new Player();
  player.setHealth(100);
  player.setX(0);
  player.setY(0);

  while (player.passive.type != Passive.MOUNTAIN_WALKING && m.getVal(player.getX(), player.getY()) > 0.625) {
    player.setX(random(-1000, 1000));
    player.setY(random(-1000, 1000));
  }

  while (player.passive.type != Passive.WATER_WALKING && m.getVal(player.getX(), player.getY()) < 0.25) {
    player.setX(random(-1000, 1000));
    player.setY(random(-1000, 1000));
  }

  attack = new Button(300, 300, 130, 30, 3, color(283, 283, 283), color(150, 150, 150), color(200, 200, 200), color(100, 100, 100), color(0, 0, 0), color(255, 255, 255), "Attack", 33, null);
  skill1 = new Button(300, 330, 130, 30, 3, color(283, 283, 283), color(150, 150, 150), color(200, 200, 200), color(100, 100, 100), color(0, 0, 0), color(255, 255, 255), "Heal", 33, player.skill1);
  skill2 = new Button(300, 360, 130, 30, 3, color(283, 283, 283), color(150, 150, 150), color(200, 200, 200), color(100, 100, 100), color(0, 0, 0), color(255, 255, 255), "ATK+", 33, player.skill2);
  skill3 = new Button(300, 390, 130, 30, 3, color(283, 283, 283), color(150, 150, 150), color(200, 200, 200), color(100, 100, 100), color(0, 0, 0), color(255, 255, 255), "ATK-", 33, player.skill3);

  attack.addPressedEffect(color(50, 50, 50), color(255, 255, 255), color(150, 150, 150));
  skill1.addPressedEffect(color(50, 50, 50), color(255, 255, 255), color(150, 150, 150));
  skill2.addPressedEffect(color(50, 50, 50), color(255, 255, 255), color(150, 150, 150));
  skill3.addPressedEffect(color(50, 50, 50), color(255, 255, 255), color(150, 150, 150));

  text_scalar = 20;

  display_width = 48;
  display_height = 48;

  gameState.setGameState(GameState.MENU);
}
/*
@Name: Draw loop
@Purpose: Draws the loading screen
@Type: Params none -- return none
*/
void drawLoop() {
  int colorHue = floor(map(noise(mouseX/1000f, mouseY/1000f, (millis()-timeStart)/1000f), 0, 1, 0, 256));
  colorMode(HSB);
  textFont(title_font);
  textSize(100);
  fill(colorHue, 255, 255);
  text("Loading", width/2-150, height/2+25);
  rectMode(CORNERS);
  noFill();
  strokeWeight(map(noise((millis()-timeStart)/1000f), 0, 1, 1, 10));
  stroke(colorHue, 255, 255);
  rect(width/2-200, height/2-200, width/2+200, height/2+200, map(noise((millis()-timeStart)/1000f), 0, 1, 1, 100));
  rectMode(CORNER);
  colorMode(RGB);
}
/*
@Name: drawMap
@purpose: draw's the 48x48 character abomination that's meant to show where in the infinite plane of suffering you are.
@type: params none -- return none
*/
void drawMap() {
  //println(startX, startY, endX, endY);

  int startX = -(display_width/2);
  int startY = -(display_height/2);

  int endX = (display_width/2);
  int endY = (display_height/2);

  int xOff = 0;
  int yOff = 5;
  textFont(map_font);
  for (int y = startY; y < endY; y++) {
    for (int x = startX; x < endX; x++) {
      fill(0, 255, 0);
      if (x == 0 && y == 0) {
        fill(0, 255, 255);
        text("@", xOff*text_scalar, yOff*text_scalar);
      } else {
        fill(m.getC(player.getX()+(x*move), player.getY()+(y*move)));
        text(m.get(player.getX()+(x*move), player.getY()+(y*move)), xOff*text_scalar, yOff*text_scalar);
      }
      xOff++;
    }
    yOff++;
    xOff = 0;
  }
}
/*
@Name: drawHealthBar
@Purpose: To continuously remind me to organize my functions, as this should go into the player class. Also to draw a healthbar during a fight
@Type: Params int (coordinates) -- return None
*/
void drawHealthBar(int x, int y) {
  fill(255);
  textFont(map_font);
  text("Health: ", x, y-25);
  if (player.getHealth() > 50) {
    color from = color(0, 155, 0);
    color to = color(0, 255, 0);
    color newCol = lerpColor(from, to, (player.getHealth()/100f));
    fill(newCol);
  } else {
    color from = color(100, 0, 0);
    color to = color(255, 0, 0);
    color newCol = lerpColor(from, to, (player.getHealth()/100f));
    fill(newCol);
  }
  noStroke();

  rect(x, y, player.getHealth()*2, 30);
}
/*
@Name: createSave
@Purpose: This allows for the game to be saved and reloaded "oh shite I forgot to have inventory saves! DAMMIT!"
@Type: params None -- return None
*/
void createSave() {
  String xmlData = "<root><world><seed>"+seed+"</seed></world><player><coordinates><x>"+player.x+"</x><y>"+player.y+"</y></coordinates><level>"+player.level+"</level><xp>"+player.xp+"</xp>" +
    "<health>";
  if (player.health < 50) {
    xmlData += Integer.toString(player.health);
  } else {
    xmlData += "100";
  }
  
  xmlData += "</health><passive>" + player.passive.type + "</passive>";
  xmlData += "<inventory>";
  xmlData += "<sneak>" + player.items.get(0) + "</sneak>";
  xmlData += "<kill>" + player.items.get(1) + "</kill>";
  xmlData += "<heal>" + player.items.get(2) + "</heal>";
  xmlData += "<weaken>" + player.items.get(3) + "</weaken>";
  xmlData += "<water>" + player.items.get(4) + "</water>";
  xmlData += "<pandora>" + player.items.get(5) + "</pandora>";
  xmlData += "</inventory>";
  xmlData += "</player></root>";

  XML xmlSave = parseXML(xmlData);
  saveXML(xmlSave, "save.xml");
}
/*
@Name: drawMoves
@Purpose: to uncluster my insanely clustured draw() function.
@Type: params None -- return None
*/
void drawMoves() {
  attack.show();
  skill1.show();
  skill2.show();
  skill3.show();

  if (skill1.counter < 100) {
    skill1.counter++;
  }

  if (skill2.counter < 100) {
    skill2.counter++;
  }

  if (skill3.counter < 100) {
    skill3.counter++;
  }

  if (attack.counter < 100) {
    attack.counter++;
  }
}

/*
@Name: createEnemy
@Purpose: I honestly have no idea why I use this. this could've just been one repeated section in an if statement. or I could've included the 'boss' thing into this. I probably thought it would be easier this way...
@Type: params None -- return None
*/
void createEnemy() {
  if (!enemyExists) {
    enemy = new Enemy(player);
    enemyExists = true;
  }
}
/*
@Name: DrawXPBar
@Purpose: there's this little grey rectangle that looks like it slowly fills up every time you win a fight. It's meant to show how much time and effort you've put in to the game.
@Type: params int(coordinates) -- return None
*/
void drawXPBar(int x, int y) {
  fill(255);
  text("XP: ", x, y-25);
  float dxp = map(player.getXP(), 0, 100, 0, 200);
  fill(150);
  rect(x, y, 200, 30);
  fill(0, 255, 0);
  rect(x, y, dxp, 30);
}
/*
@Name: drawInventory
@purpose: To make use for the items that I've created poorly. Items were made like 4 hours ago and I wanted to take my friend out for lunch before his family came over so it's implemented terribly.
@type; params none -- return none
*/
void drawInventory() {
  textFont(map_font);
  if (player.items.get(0) > 0) {
    Item_SNEAK.show();
  }
  if (player.items.get(1) > 0) {
    Item_KILL.show();
  }
  if (player.items.get(2) > 0) {
    Item_HEAL.show();
  }
  if (player.items.get(3) > 0) {
    Item_WEAKEN.show();
  }
  if (player.items.get(4) > 0) {
    Item_WATER.show();
  }
  if (player.items.get(5) > 0) {
    Item_PANDORA.show();
  }
}
/*
@Name: "The bane of my existence" --> also called draw
@purpose: this controlls what's on the screen, which means, it's like 201 lines of code and half of it's if statements
@type: params none -- return none
*/
void draw() {
  background(0);
  fill(255, 255, 255);
  textFont(title_font);
  text("AsciiGAR", 25, 50);
  text("_________", 0, 50);
  if (gameState.getGameState() == GameState.LOADING) {
    drawLoop();
    if ((millis()-timeStart)/1000f > 10) {
      thread("drawLoop");
      init();
    }
  } else if (gameState.getGameState() == GameState.MENU) {

    if (!menuMusic.isPlaying()) {
      menuMusic.play();
    }

    play.show();
    load.show();
    exit.show();
  } else if (gameState.getGameState() == GameState.ROAMING) {
    if (menuMusic.isPlaying()) {
      menuMusic.stop();
    }
    if (!gameMusic[musicIndex].isPlaying()) {
      if (musicIndex == gameMusic.length-1) {
        musicIndex = 0;
      } else {
        musicIndex++;
      }
      gameMusic[musicIndex].play();
    }


    drawMap();
    drawHealthBar((display_width*display_width)/2, 200);
    drawXPBar((display_width*display_width)/2, 350);

    textFont(map_font);
    textSize(35);
    text("Level: " + player.getLevel(), (display_width*display_width)/2, 150);

    fill(255, 255, 255);
    if (player.passive.type == Passive.RETAIN_DAMAGE) {
      text("Passive Skill: Damage Retain", (display_width*display_width)/2, 450);
    } else if (player.passive.type == Passive.WATER_WALKING) {
      text("Passive Skill: Water Walking", (display_width*display_width)/2, 450);
    } else if (player.passive.type == Passive.MOUNTAIN_WALKING) {
      text("Passive Skill: Mountain Walking", (display_width*display_width)/2, 450);
    }
    if (random_movement) {
      if (counter == 100) {
        counter = 0;
      }
      if (counter == 0) {
        decision = floor(random(0, 4));
        counter++;
      } else {
        if (decision == 0) {
          player.setY(player.getY()-move);
        } 
        if (decision == 1) {
          player.setX(player.getX()+move);
        }  
        if (decision == 2) {
          player.setY(player.getY()+move);
        }  
        if (decision == 3) {
          player.setX(player.getX()-move);
        }
        counter++;
      }
    }
    if (m.getVal(player.x, player.y) < 0.25 && player.passive.type != Passive.WATER_WALKING && player.waterWalkingSteps <= 0) {
      gameState.setGameState(GameState.DEAD);
    }
    if (dispSave) {
      saveText.update();
      if (saveText.c <= 0) {
        saveText.x = width/2-100;
        saveText.y = height/2;
        saveText.c = 255;
        dispSave = false;
      }
    }
  } else if (gameState.getGameState() == GameState.FIGHTING) {
    if (menuMusic.isPlaying()) {
      menuMusic.stop();
    }
    //if (roamingMusic.isPlaying()) {
    //  roamingMusic.pause();
    //}

    drawInventory();
    drawHealthBar(300, 150);
    createEnemy();
    enemy.drawStats(width-300, 150);
    drawMoves();

    fill(255);
    text("Player Damage: " + player.getDamage(), 100, 500);


    for (FadingText ft : text) {
      if (ft.c > 0) {
        ft.update();
      }
    }

    if (player.health <= 0) {
      gameState.setGameState(GameState.DEAD);
    }

    if (enemy.health <= 0) {
      if (enemy.level < 3) {
        player.xp += 10*enemy.level;
      } else if (enemy.level < 5) {
        player.xp += 7.5*enemy.level;
      } else if (enemy.level < 10) {
        player.xp += 5*enemy.level;
      } else {
        player.xp += enemy.level;
      }

      player.health = max(50, player.health);

      if (player.passive.type == Passive.RETAIN_DAMAGE) {
        if (player.level < 3) {
          player.setDamage(max(1, player.getDamage()/10));
        } else if (player.level < 5) {
          player.setDamage(max(1, player.getDamage()/5));
        } else if (player.level < 7) {
          player.setDamage(max(1, player.getDamage()/2));
        } else {
          player.setDamage(max(1, player.getDamage()));
        }
      } else {
        if (player.getLevel() < 1) {
          player.setDamage(1);
        } else {
          player.setDamage(player.getLevel());
        }
      }

      if (floor(random(0, Item.ITEMS)) > 0) {
        int id =  floor(random(0, Item.MAXITEMID));
        player.items.put(id, player.items.get(id)+1);
      }
      if (player.xp >= 100) {
        gameState.setGameState(GameState.LEVELUP);
      } else {
        gameState.setGameState(GameState.ROAMING);
      }
    }
  } else if (gameState.getGameState() == GameState.DEAD) {
    if (menuMusic.isPlaying()) {
      menuMusic.stop();
    }
    gameMusic[musicIndex].stop();
    musicIndex = 0;

    textFont(title_font);
    textSize(100);
    fill(255, 0, 0);
    text("YOU DIED", width/2-300, height/2);
    deathResetCounter ++;
    if (deathResetCounter >= 1000 || (deathResetCounter > 100 && mousePressed) ||(deathResetCounter > 100 && keyPressed)) {
      gameState.setGameState(GameState.MENU);
    }
  } else if (gameState.getGameState() == GameState.LEVELUP) {
    if (menuMusic.isPlaying()) {
      menuMusic.stop();
    }
    //if (roamingMusic.isPlaying()){
    //  roamingMusic.pause();
    //}

    textFont(title_font);
    textSize(100);
    fill(0, 255, 0);
    if (player.xp >= 100) {
      player.level++;
      player.xp = 0;
      player.health = 100;
    }
    text("You leveled up!", width/2-300, height/2-50);
    text("You're now level " + player.getLevel(), width/2-300, height/2+50);


    levelUpCounter+=1;
    if (levelUpCounter >= 1000) {
      gameState.setGameState(GameState.ROAMING);
      levelUpCounter = 0;
    }

    if ((levelUpCounter >= 100 && keyPressed) || (levelUpCounter >= 100 && mousePressed)) {
      gameState.setGameState(GameState.ROAMING);
      levelUpCounter = 0;
    }
  }
}

/*
@Name: keyPressed
@Purpose: so that you can move. otherwise you'd be paralyzed. Imagine if you were paralyzed and spawned in water. That'd suck.
@Type: params none -- return none
*/
void keyPressed() {
  if (!random_movement) {
    if (gameState.getGameState() == GameState.ROAMING) {
      if (keyCode == 87) {
        float value = m.getVal(player.getX(), player.getY()-move);

        boolean shouldMove = true;

        if (value < 0.25 && player.passive.type != Passive.WATER_WALKING && player.waterWalkingSteps <= 0) {
          shouldMove = false;
          if (m.getVal(player.getX(), player.getY()) == 0) {
            gameState.setGameState(GameState.DEAD);
          }
        }
        if (value < 0.25 && player.waterWalkingSteps > 0) {
          player.waterWalkingSteps-= 1;
        }

        if (value > 0.625 && player.passive.type != Passive.MOUNTAIN_WALKING) {
          shouldMove = false;
        }


        if (shouldMove) {
          player.setY(player.getY()-move);
          if (player.sneakSteps > 0) {
            player.sneakSteps --;
          } else {
            if (random(0, 1) < encounterPercentage) {
              if (player.level >= minLevelBossEncounter && random(0, 1) < bossEncounterPercentage) {
                enemyExists = true;
                enemy = new Boss(player);
                gameState.setGameState(GameState.FIGHTING);
                text = new ArrayList<FadingText>();
                println("BOSS");
              } else {
                enemyExists = false;
                gameState.setGameState(GameState.FIGHTING);
                text = new ArrayList<FadingText>();
              }
            }
          }
        }
      }
      if (keyCode == 65) {
        float value = m.getVal(player.getX()-move, player.getY());

        boolean shouldMove = true;

        if (value < 0.25 && player.passive.type != Passive.WATER_WALKING && player.waterWalkingSteps <= 0) {
          shouldMove = false;
          if (m.getVal(player.getX(), player.getY()) == 0) {
            gameState.setGameState(GameState.DEAD);
          }
        }
        if (value < 0.25 && player.waterWalkingSteps > 0) {
          player.waterWalkingSteps-= 1;
        }

        if (value > 0.625 && player.passive.type != Passive.MOUNTAIN_WALKING) {
          shouldMove = false;
        }

        if (shouldMove) {
          player.setX(player.getX()-move);
          if (player.sneakSteps > 0) {
            player.sneakSteps--;
          } else {
            if (random(0, 1) < encounterPercentage) {
              if (player.level >= minLevelBossEncounter && random(0, 1) < bossEncounterPercentage) {
                enemyExists = true;
                enemy = new Boss(player);
                gameState.setGameState(GameState.FIGHTING);
                text = new ArrayList<FadingText>();
                println("BOSS");
              } else {
                enemyExists = false;
                gameState.setGameState(GameState.FIGHTING);
                text = new ArrayList<FadingText>();
              }
            }
          }
        }
      }
      if (keyCode == 83) {
        float value = m.getVal(player.getX(), player.getY()+move);

        boolean shouldMove = true;

        if (value < 0.25 && player.passive.type != Passive.WATER_WALKING && player.waterWalkingSteps <= 0) {
          shouldMove = false;
          if (m.getVal(player.getX(), player.getY()) == 0) {
            gameState.setGameState(GameState.DEAD);
          }
        }
        if (value < 0.25 && player.waterWalkingSteps > 0) {
          player.waterWalkingSteps-= 1;
        }

        if (value > 0.625 && player.passive.type != Passive.MOUNTAIN_WALKING) {
          shouldMove = false;
        }

        if (shouldMove) {
          player.setY(player.getY()+move);
          if (player.sneakSteps > 0) {
            player.sneakSteps--;
          } else {
            if (random(0, 1) < encounterPercentage) {
              if (player.level >= minLevelBossEncounter && random(0, 1) < bossEncounterPercentage) {
                enemyExists = true;
                enemy = new Boss(player);
                gameState.setGameState(GameState.FIGHTING);
                text = new ArrayList<FadingText>();
                println("BOSS");
              } else {
                enemyExists = false;
                gameState.setGameState(GameState.FIGHTING);
                text = new ArrayList<FadingText>();
              }
            }
          }
        }
      }
      if (keyCode == 68) {
        float value = m.getVal(player.getX()+move, player.getY());

        boolean shouldMove = true;

        if (value < 0.25 && player.passive.type != Passive.WATER_WALKING && player.waterWalkingSteps <= 0) {
          shouldMove = false;
          if (m.getVal(player.getX(), player.getY()) == 0) {
            gameState.setGameState(GameState.DEAD);
          }
        }
        if (value < 0.25 && player.waterWalkingSteps > 0) {
          player.waterWalkingSteps-= 1;
        }

        if (value > 0.625 && player.passive.type != Passive.MOUNTAIN_WALKING) {
          shouldMove = false;
        }

        if (shouldMove) {
          player.setX(player.getX()+move);
          if (player.sneakSteps > 0) {
            player.sneakSteps --;
          } else {
            if (random(0, 1) < encounterPercentage) {
              if (player.level >= minLevelBossEncounter && random(0, 1) < bossEncounterPercentage) {
                enemyExists = true;
                enemy = new Boss(player);
                gameState.setGameState(GameState.FIGHTING);
                text = new ArrayList<FadingText>();
                println("BOSS");
              } else {
                enemyExists = false;
                gameState.setGameState(GameState.FIGHTING);
                text = new ArrayList<FadingText>();
              }
            }
          }
        }
      }

      if (keyCode == 115) {
        createSave();
        dispSave = true;
      }
    }
  }
}

//FINALLY! IVE REACHED THE BOTTOM!
//THAT'S 1/13...
//please save me. I don't have time for this...
