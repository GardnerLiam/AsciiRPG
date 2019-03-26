class Map {
  int map_width;
  int map_height;
  public char[][] map;
  public color[][] col;
  public Map(int w, int h) {
    map_width = w;
    map_height = h;
    map = new char[map_width][map_height]; 
    col = new color[map_width][map_height];
    for (int x = 0; x < map_width; x++) {
      for (int y = 0; y < map_height; y++) {
        if (x == 0 || y == 0 || x == map_width-1 || y == map_height-1){
          col[x][y] = color(100,100,100);
          map[x][y] = '*';
        }else{
          float val = noise(x,y);
          if (val < 0.15){
            col[x][y] = color(0,0,150);
            map[x][y] = ',';
          }else if (val < 0.2){
            col[x][y] = color(0,0,200);
            map[x][y] = ',';
          }else if (val < 0.25){
            col[x][y] = color(0,100,255);
            map[x][y] = ',';
          }else if (val < 0.3){
            col[x][y] = color(255,243,0);
            map[x][y] = '$';
          }else if (val < 0.4){
            col[x][y] = color(0,200,0);
            map[x][y] = '~';
          }else{// if (val < 0.5){
            col[x][y] = color(0,255,0);
            map[x][y] = '#';
          }
        }
      }
    }
  }
  public char get(int x, int y) {
    return map[x][y];
  }
  public color getC(int x, int y){
    return col[x][y];
  }
}
