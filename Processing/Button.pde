/*
@Author: Liam Gardner
@Date: Let's say around a week ago... so 3/31/2019
@Purpose: Let's turn this into a dialogue
  "Hey, I'm making a game, wanna draw some buttons for me?" - me
  "I'm kind of busy right now" - Lyndsay
  "Same" - The only other person I trust to draw (His name is Maurice and I've known him since gr. 1)
  "Looks like I'll program them myself then... :(" - me
  
Seriously though, The constructor's so big and I couldn't even fit everything I needed into it
*/
class Button {
  int x;
  int y;
  int w;
  int h;
  int s;
  CVector fillColor;
  CVector strokeColor;
  CVector textColor;
  CVector fillColorSelected;
  CVector strokeColorSelected;
  CVector textColorSelected;
  String str;
  int strSize;

  CVector fillColorPressed;
  CVector strokeColorPressed;
  CVector textColorPressed;

  Skill skill;

  int counter;

  int textX;
  int textY;

  CVector changeFillColor;
  CVector changeStrokeColor;
  CVector changeTextColor;
  float change;

  boolean allowChange;

  float xoff;

  boolean menuButton;

  boolean disabled;
  boolean itemButton;

  public Button(int x, int y, int w, int h, int s, color fillColor, color strokeColor, color fillColorSelected, color strokeColorSelected, color textColor, color textColorSelected, String text, int textSize, Skill skill) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.s = s;
    this.fillColor = new CVector(fillColor);
    this.strokeColor = new CVector(strokeColor);
    this.fillColorSelected = new CVector(fillColorSelected);
    this.strokeColorSelected = new CVector(strokeColorSelected);
    this.textColor = new CVector(textColor);
    this.textColorSelected = new CVector(textColorSelected);
    this.str = text;
    this.strSize = textSize;

    this.fillColorPressed = new CVector(fillColorSelected);
    this.strokeColorPressed = new CVector(strokeColorSelected);
    this.textColorPressed = new CVector(textColorSelected);

    this.skill = skill;
    counter = 50;

    this.textX = x + 5;
    this.textY = y + 25;

    this.changeFillColor = new CVector(fillColor);
    this.changeStrokeColor = new CVector(strokeColor);
    this.changeTextColor = new CVector(textColor);

    this.allowChange = false;
    this.xoff = 0;
    this.menuButton = false;
    this.itemButton = false;
  }

  /*
  add Pressed effect
  just in case you want to have your buttons look different when you press them
  technically, these all take integers because... processing?
  */
  void addPressedEffect(color fillColorPressed, color strokeColorPressed, color textColorPressed) {
    this.fillColorPressed = new CVector(fillColorPressed);
    this.strokeColorPressed = new CVector(strokeColorPressed);
    this.textColorPressed = new CVector(textColorPressed);
  }

  /*
  This just sets the text position of the button. hence the "setTextPos"
  takes in integer coordinates
  those coordinates are sent into the depths of hell and nothing is returned. Just like the "integers" in the function/method above
  */
  void setTextPos(int x, int y) {
    this.textX = x;
    this.textY = y;
  }

  /*
  this should've been split into a multitude of different methods.
  I cry everytime I travel to this section of my code. Seriously, it's 222 lines!
  this is like the buttons's personal draw() function and my second personal hell. 
  */
  void show() {
    if (mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h && !mousePressed) {
      if (allowChange) {
        if (fillColorSelected.equals(changeFillColor) && strokeColorSelected.equals(changeStrokeColor) && textColorSelected.equals(changeTextColor)) { 
          fill(fillColorSelected.asColor());
          stroke(strokeColorSelected.asColor());
          if (!str.contains(">>")) {
            str += ">";
          }
        } else {
          if (xoff > -24) {
            xoff-=0.5;
          }

          if (xoff == -12) {
            str += ">";
          }

          changeFillColor.adjust(fillColorSelected, 10);

          changeStrokeColor.adjust(strokeColorSelected, 10);

          changeTextColor.adjust(textColorSelected, 10);

          fill(changeFillColor.asColor());
          stroke(changeStrokeColor.asColor());
        }
      } else {
        fill(fillColorSelected.asColor());
        stroke(strokeColorSelected.asColor());
      }
    } else if (mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h && mousePressed) {
      fill(fillColorPressed.asColor());
      stroke(strokeColorPressed.asColor());
    } else {
      fill(fillColor.asColor());
      stroke(strokeColor.asColor());
      this.changeFillColor = new CVector(this.fillColor.asColor());
      this.changeStrokeColor = new CVector(this.strokeColor.asColor());
      this.changeTextColor = new CVector(this.textColor.asColor());

      if (str.contains(">>")) {
        str = str.substring(0, str.length()-2);
        xoff = 0;
      }
    }
    strokeWeight(s);
    rect(x, y, w, h);

    if (mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h && !mousePressed) {
      if (allowChange) {
        if (textColorSelected.equals(changeTextColor)) {
          fill(textColorSelected.asColor());
        } else {
          fill(changeTextColor.asColor());
        }
      } else {

        fill(textColorSelected.asColor());
      }
      textSize(strSize);
      text(str, textX+xoff, textY);
    } else if (mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h && mousePressed && counter >= 50 && menuButton == false) {
      fill(textColorPressed.asColor());
      textSize(strSize);
      text(str, textX+xoff, textY);
    } else {
      fill(textColor.asColor());
      textSize(strSize);
      text(str, textX+xoff, textY);
    }

    if (mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h && mousePressed && menuButton) {
      fill(textColorPressed.asColor());
      textSize(strSize);
      text(str, textX+xoff, textY);
    } else {
      fill(textColor.asColor());
      textSize(strSize);
      text(str, textX+xoff, textY);
    }

    if (mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h && mousePressed && counter >= 50 && menuButton == false && itemButton == false) {
      if (gameState.getGameState() == GameState.FIGHTING) {
        if (!str.equals("Attack")) {
          if (skill.getName().equals("Heal")) {
            player.setHealth(skill.heal(player.getHealth(), player.getLevel()));
            text.add(new FadingText("You Healed", width/2-300, height/2+100));
            text.get(text.size()-1).setYOffset(5);
            text.get(text.size()-1).setTextSize(50);
          } else if (skill.getName().equals("Atk+")) {
            player.setDamage(skill.damageIncr(player.getDamage(), player.getLevel()));
            text.add(new FadingText("You Increased Damage", width/2-300, height/2+100));
            text.get(text.size()-1).setYOffset(5);
            text.get(text.size()-1).setTextSize(50);
          } else if (skill.getName().equals("Atk-")) {
            enemy.setDamage(skill.damageDecr(enemy.getDamage(), player.getLevel()));
            text.add(new FadingText("Enemy Damage Decreased", width/2-300, height/2+100));
            text.get(text.size()-1).setYOffset(5);
            text.get(text.size()-1).setTextSize(50);
          }
        } else {
          enemy.setHealth(enemy.getHealth()-player.getDamage());
          text.add(new FadingText("You Attacked", width/2-300, height/2+100));
          text.get(text.size()-1).setYOffset(5);
          text.get(text.size()-1).setTextSize(50);
        }
        counter = 0;
        enemy.turn();
      }
    }
    if (mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h && mousePressed && menuButton == true) {
      if (menuButton && gameState.getGameState() == GameState.MENU || gameState.getGameState() == GameState.LOADING) {
        if (str.contains("Play")) {
          gameState.setGameState(GameState.ROAMING);
          menuMusic.pause();
          menuMusic.stop();
          gameMusic[musicIndex].play();
        } else if (str.contains("Exit")) {
          System.exit(0);
        } else if (str.contains("Load")) {
          try {
            XML saveFile = loadXML("save.xml");

            for (XML x : saveFile.getChildren("world")) {
              for (XML c : x.getChildren("seed")) {
                seed = c.getIntContent();
                break;
              }
            }

            for (XML x : saveFile.getChildren("player")) {
              for (XML c : x.getChildren("coordinates")) {
                for (XML c1 : c.getChildren("x")) {
                  player.x = c1.getFloatContent();
                }
                for (XML c2 : c.getChildren("y")) {
                  player.y = c2.getFloatContent();
                }
              }
              for (XML c : x.getChildren("level")) {
                player.level = c.getIntContent();
              }
              for (XML c : x.getChildren("xp")) {
                player.xp = c.getFloatContent();
              }
              for (XML c : x.getChildren("health")) {
                player.health = c.getIntContent();
              }
              for (XML c : x.getChildren("passive")) {
                player.passive.type = c.getIntContent();
              }
              for (XML i : x.getChildren("inventory")){
                for (XML c : x.getChildren("sneak")){
                  player.items.put(0, c.getIntContent());
                }
                for (XML c : x.getChildren("kill")){
                  player.items.put(1, c.getIntContent());
                }
                for (XML c : x.getChildren("heal")){
                  player.items.put(2, c.getIntContent());
                }
                for (XML c : x.getChildren("weaken")){
                  player.items.put(3, c.getIntContent());
                }
                for (XML c : x.getChildren("water")){
                  player.items.put(4, c.getIntContent());
                }
                for (XML c : x.getChildren("pandora")){
                  player.items.put(5, c.getIntContent());
                }
              }
            }

            noiseSeed(seed);

            gameState.setGameState(GameState.ROAMING);
            menuMusic.stop();
            gameMusic[musicIndex].play();
          }
          catch (Exception e) {
            println("Could not load properly");
            gameState.setGameState(GameState.ROAMING);
            menuMusic.stop();
            gameMusic[musicIndex].play();
          }
        }
      }
    }
    if (mouseX > x && mouseX < x+w && mouseY > y && mouseY < y+h && mousePressed && itemButton == true) {
      if (str.equals("Sneak")) {
        player.sneak.use();
        if (player.items.get(0) > 0) {
          player.items.put(0, player.items.get(0)-1);
        }
      } else if (str.equals("Kill")) {
        player.kill.use();
        if (player.items.get(1) > 0) {
          player.items.put(1, player.items.get(1)-1);
        }
      } else if (str.equals("Heal")) {
        player.heal.use();
        if (player.items.get(2) > 0) {
          player.items.put(2, player.items.get(2)-1);
        }
      } else if ( str.equals("Weaken")) {
        player.weaken.use();
        if (player.items.get(3) > 0) {
          player.items.put(3, player.items.get(3)-1);
        }
      } else if (str.equals("Water")) {
        player.water.use();
        if (player.items.get(4) > 0) {
          player.items.put(4, player.items.get(4)-1);
        }
      } else if (str.equals("Pandora")) {
        player.pandora.use();
        if (player.items.get(5) > 0) {
          player.items.put(5, player.items.get(5)-1);
        }
      }
    }
  }
}
