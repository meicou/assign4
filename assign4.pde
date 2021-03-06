Ship ship;
PowerUp ruby;
Bullet[] bList;
Laser[] lList;
Alien[] aList;

//Game Status
final int GAME_START   = 0;
final int GAME_PLAYING = 1;
final int GAME_PAUSE   = 2;
final int GAME_WIN     = 3;
final int GAME_LOSE    = 4;
int status;              //Game Status
int point;               //Game Score
int expoInit;            //Explode Init Size
int countBulletFrame;   //Bullet Time Counter
int bulletNum;           //Bullet Order Number
int life;
int laserNum;
int countLaserFrame;
int frame;
/*--------Put Variables Here---------*/


void setup() {

  status = GAME_START;

  bList = new Bullet[30];
  lList = new Laser[30];
  aList = new Alien[100];

  size(640, 480);
  background(0, 0, 0);
  rectMode(CENTER);

  ship = new Ship(width/2, 460, 3);
  ruby = new PowerUp(int(random(width)), -10);

  reset();
}

void draw() {
  background(50, 50, 50);
  noStroke();

  switch(status) {

  case GAME_START:
    /*---------Print Text-------------*/
        printText(1); // replace this with printText
    /*--------------------------------*/
    break;

  case GAME_PLAYING:
    background(50, 50, 50);

    drawHorizon();
    drawScore();
    drawLife();
    ship.display(); //Draw Ship on the Screen
    drawAlien();
    drawBullet();
    drawLaser();

    /*---------Call functions---------------*/

//    checkWinLose();
    checkRubyDrop();
    checkAlienDead();/*finish this function*/
    checkShipHit();  /*finish this function*/
    alienShoot(50);
    countBulletFrame+=1;
    countLaserFrame+=1;

            
    break;

  case GAME_PAUSE:
    /*---------Print Text-------------*/
    printText(2);
    /*--------------------------------*/
    break;

  case GAME_WIN:
    /*---------Print Text-------------*/
    printText(3);
    /*--------------------------------*/
    winAnimate();
    break;

  case GAME_LOSE:
    loseAnimate();
    /*---------Print Text-------------*/
    printText(4);
    /*--------------------------------*/
    break;
  }
}

void printText(int x){
  fill(95, 194, 226);
  textAlign(CENTER,CENTER);

  if(x == 1){
  textSize(60);
  text("GALIXIAN",320,240);
  textSize(20);
  text("Press ENTER to Start", 320, 280);
}
  else if(x == 2){
 textSize(40);
 text("PAUSE",320,240);
 textSize(20);
 text("Press ENTER to Resume", 320, 280);
}
  else if(x == 3){
 textSize(40);
 text("WIN",320,300);
}
  else if(x == 4){
 textSize(40);
 text("BOOM",320,240);
 textSize(20);
 text("You are dead!!", 320, 280);
}

}

void drawHorizon() {
  stroke(153);
  line(0, 420, width, 420);
}

void drawScore() {
  noStroke();
  fill(95, 194, 226);
  textAlign(CENTER, CENTER);
  textSize(23);
  text("SCORE:"+point, width/2, 16);
}

void keyPressed() {
  if (status == GAME_PLAYING) {
    ship.keyTyped();
    cheatKeys();
    shootBullet(30);
  }
  statusCtrl();
}

/*---------Make Alien Function-------------*/
void alienMaker() {
  aList[0]= new Alien(50, 50);
   for (int i=0; i < 53; ++i){
    
    int row = int (i / 12);
    int col = int (i % 12);
 
    int x = 50 + (40*col);
    int y = 50 + (50*row);
    
    aList[i] = new Alien(x, y);
}
}

void drawLife() {
  fill(230, 74, 96);
  text("LIFE:", 36, 455);
  /*---------Draw Ship Life---------*/
  if(life == 3) {
  for(int i=0;i < 3;i++){
  ellipse(78+25*i,459,15,15);
  }
  }else if (life == 2) {
  for(int i=0;i < 2;i++){
  ellipse(78+25*i,459,15,15);
  }   
  }else if (life == 1) {
      for(int i=0;i < 1;i++){
  ellipse(78+25*i,459,15,15);
  }
  }else if (life == 0) {
    status = GAME_LOSE;
  }
}

void drawBullet() {
  for (int i=0; i<bList.length-1; i++) {
    Bullet bullet = bList[i];
    if (bullet!=null && !bullet.gone) { // Check Array isn't empty and bullet still exist
      bullet.move();     //Move Bullet
      bullet.display();  //Draw Bullet on the Screen
      if (bullet.bY<0 || bullet.bX>width || bullet.bX<0) {
        removeBullet(bullet); //Remove Bullet from the Screen
      }
    }
  }
}

void drawLaser() {
  for (int i=0; i<lList.length-1; i++) { 
    Laser laser = lList[i];
    if (laser!=null && !laser.gone) { // Check Array isn't empty and Laser still exist
      laser.move();      //Move Laser
      laser.display();   //Draw Laser
      if (laser.lY>480) {
        removeLaser(laser); //Remove Laser from the Screen
      }
    }
  }
}

void drawAlien() {
  for (int i=0; i<aList.length-1; i++) {
    Alien alien = aList[i];
    if (alien!=null && !alien.die) { // Check Array isn't empty and alien still exist
      alien.move();    //Move Alien
      alien.display(); //Draw Alien
      /*---------Call Check Line Hit---------*/
      checkAlienBut();
      /*--------------------------------------*/
    }
  }
}

/*--------Check Line Hit---------*/
void checkAlienBut() {
  for (int i=0; i<aList.length-1; i++) {
    Alien alien = aList[i];
    if (alien!=null && !alien.die && aList[i].aY>=420) {
      status = GAME_LOSE;
    }
}

}

/*---------Ship Shoot-------------*/
void shootBullet(int frame) {
  if ( key == ' ' && countBulletFrame>frame) {
    if (!ship.upGrade) {
      bList[bulletNum]= new Bullet(ship.posX, ship.posY, -3, 0);
      if (bulletNum<bList.length-2) {
        bulletNum+=1;
      } else {
        bulletNum = 0;
      }
    } 
    /*---------Ship Upgrade Shoot-------------*/
    else {
      bList[bulletNum]= new Bullet(ship.posX, ship.posY, -3, 0); 
      if (bulletNum<bList.length-2) {
        bulletNum+=1;
      } else {
        bulletNum = 0;
      }
    }
    countBulletFrame = 0;
  }
}

/*---------Check Alien Hit-------------*/
void checkAlienDead() {
  for (int i=0; i<bList.length-1; i++) {
    Bullet bullet = bList[i];
    for (int j=0; j<aList.length-1; j++) {
      Alien alien = aList[j];
      if (bullet != null && alien != null && !bullet.gone && !alien.die // Check Array isn't empty and bullet / alien still exist
      && bList[i].bX >= aList[j].aX - (aList[j].aSize*3/2) && bList[i].bY >= aList[j].aY - aList[j].aSize
      && bList[i].bX <= aList[j].aX + (aList[j].aSize*3/2) && bList[i].bY <= aList[j].aY + aList[j].aSize) {
          /*-------do something------*/
          
          removeAlien( aList[j]);
          removeBullet( bList[i]);
          point+=10;
        }
    }
  }
}

/*---------Alien Drop Laser-----------------*/
void alienShoot(int frame){  
    Laser laser;    
    Alien alien;
    
    if(countLaserFrame==frame){
     do{
        alien = aList[int(random(53))];
      }while(!(alien!=null && !alien.die));
      laserNum=(laserNum>=lList.length-1?0:laserNum);
      lList[laserNum++]= new Laser(alien.aX,alien.aY);
      countLaserFrame=0;     
   }
  
   }
/*---------Check Laser Hit Ship-------------*/
void checkShipHit() {
  for (int i=0; i<lList.length-1; i++) {
    Laser laser = lList[i];
    if (laser!= null && !laser.gone // Check Array isn't empty and laser still exist
        && lList[i].lX >= ship.posX && lList[i].lX + lList[i].lSize <= ship.posX + ship.shipSize 
        && lList[i].lY+lList[i].lSize >= ship.posY && lList[i].lY <= ship.posY +ship.shipSize/4*6.6 ) {
        removeLaser(lList[i]);
          life-=1;        
    }
  }
}

/*---------Check Win Lose------------------*/
void checkWinLose() {
  if(point == 530 ) {
      status=GAME_WIN;
  }
  if(life == 0) {
    status=GAME_LOSE;
  }
for (int j=0; j<aList.length-1; j++) {
      Alien alien = aList[j]; 
      int a=0;
 if(alien != null && alien.die == true){
      
      a++;
  }println(a);
  if(a == 52) {
  status=GAME_WIN;
}
}
}


void winAnimate() {
  int x = int(random(128))+70;
  fill(x, x, 256);
  ellipse(width/2, 200, 136, 136);
  fill(50, 50, 50);
  ellipse(width/2, 200, 120, 120);
  fill(x, x, 256);
  ellipse(width/2, 200, 101, 101);
  fill(50, 50, 50);
  ellipse(width/2, 200, 93, 93);
  ship.posX = width/2;
  ship.posY = 200;
  ship.display();
}

void loseAnimate() {
  fill(255, 213, 66);
  ellipse(ship.posX, ship.posY, expoInit+200, expoInit+200);
  fill(240, 124, 21);
  ellipse(ship.posX, ship.posY, expoInit+150, expoInit+150);
  fill(255, 213, 66);
  ellipse(ship.posX, ship.posY, expoInit+100, expoInit+100);
  fill(240, 124, 21);
  ellipse(ship.posX, ship.posY, expoInit+50, expoInit+50);
  fill(50, 50, 50);
  ellipse(ship.posX, ship.posY, expoInit, expoInit);
  expoInit+=5;
}

/*---------Check Ruby Hit Ship-------------*/
void checkRubyDrop(){
  if (point == 200) {
    ruby.show = true;
    }
}

/*---------Check Level Up------------------*/


/*---------Print Text Function-------------*/


void removeBullet(Bullet obj) {
  obj.gone = true;
  obj.bX = 2000;
  obj.bY = 2000;
}

void removeLaser(Laser obj) {
  obj.gone = true;
  obj.lX = 2000;
  obj.lY = 2000;
}

void removeAlien(Alien obj) {
  obj.die = true;
  obj.aX = 1000;
  obj.aY = 1000;
}

/*---------Reset Game-------------*/
void reset() {
  for (int i=0; i<bList.length-1; i++) {
    bList[i] = null;
    lList[i] = null;
  }

  for (int i=0; i<aList.length-1; i++) {
    aList[i] = null;
  }

  point = 0;
  expoInit = 0;
  countBulletFrame = 30;
  bulletNum = 0;
  life = 3;
  /*--------Init Variable Here---------*/
  

  /*-----------Call Make Alien Function--------*/
  alienMaker();

  ship.posX = width/2;
  ship.posY = 460;
  ship.upGrade = false;
  ruby.show = false;
  ruby.pX = int(random(width));
  ruby.pY = -10;
}

/*-----------finish statusCtrl--------*/
void statusCtrl() {
  if (key == ENTER) {
    switch(status) {

    case GAME_START:
      status = GAME_PLAYING;
      break;

      /*-----------add things here--------*/
/*    case GAME_PAUSE:
      status = GAME_PLAYING;
      break;
      
    case GAME_WIN:
      status = GAME_PLAYING;
      break;
    
    case GAME_LOSE:
      status = GAME_PLAYING;
      break;
  */  }
  }
}

void cheatKeys() {

  if (key == 'R'||key == 'r') {
    ruby.show = true;
    ruby.pX = int(random(width));
    ruby.pY = -10;
  }
  if (key == 'Q'||key == 'q') {
    ship.upGrade = true;
  }
  if (key == 'W'||key == 'w') {
    ship.upGrade = false;
  }
  if (key == 'S'||key == 's') {
    for (int i = 0; i<aList.length-1; i++) {
      if (aList[i]!=null) {
        aList[i].aY+=50;
      }
    }
  }
}
