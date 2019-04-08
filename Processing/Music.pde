
import processing.sound.*;
/*
@Author: Liam Gardner
@Date: 31/3/2019
@Purpose: What makes or breaks a game? MUSIC!

Okay so peter just told me that I didn't have to comment anything.... it's like 23:30 or something and I'm so tired and unmotivated to finish this yet I can't sleep bc of coffee and need to finish this
Someone save me from my 3rd self condemned hell.

Oh also every function in here is just calling the music file function... that can be found here: https://processing.org/reference/libraries/sound/SoundFile.html
*/

class Music {
  SoundFile file;
  String filename;
  PApplet container;
  public Music(String filename, PApplet container) {
    this.container = container;
    this.filename = filename;
    this.file = new SoundFile(container, filename);

    this.file.loop();
    this.file.stop();
  }

  public Music(String filename, PApplet container, boolean loop) {
    this.container = container;
    this.filename = filename;
    this.file = new SoundFile(container, filename);
    if (loop) {
      this.file.loop();
    }
    this.file.stop();
  }

  public void play() {
    if (!mute) {
      this.file.play();
    }
  }

  public void stop() {
    this.file.stop();
  }

  public void pause() {
    this.file.pause();
  }

  public boolean isPlaying() {
    return this.file.isPlaying();
  }
}
