
import gab.opencv.*;
//import KinectPV2.*;
import themidibus.*; 
//import spout.*;
import codeanticode.syphon.*;
import processing.video.*;

//import codeanticode.syphon.*;

Capture video;

//KinectPV2 kinect;


OpenCV opencv;

MidiBus busA; 

//Spout spout;
SyphonServer server;





//PImage threshold, blur, adaptive, gray, contra;


PImage img, kinectIMG, liveIMG;
long lastTime = 0;
//long lastTime2 = 0;

PFont Ntext;


int x2;
int y2;
int ii;
int high;
int tickN=0;

int note1;
int note2 = 72;
int note3 = 74;
int tickT = 0;

int vel=127;
int lan=127;

int cTick;


int fade=0;
int openFade=255;
int rebootFade=0;


int cellSizeW; 
int cellSizeH;


int cols, rows;
int hue;
int sat;
int satV;

int num;

//박자 빠르기(스텝이동속도)
int time = 400;

int midiCH;


int Xpos = 0;
int Ypos = 0;


int camBri=0;




boolean ok=true;
boolean camMode = false;
boolean empty = false;
boolean[][] emptyC;


int[][] bri;
int[][] bri2;
int[][] Hue;
int[][] Sat;
int[][] SatV;
int[] noOff;

int[] major;






int back=200;
float con = 1; //웹캠영상컨트라스트조절






int[][] reloff;
color[][] cell;

color CC;


int channel = 0;
int pitch = 64;
int velocity = 127;

//Capture video;

Note[] note;


int tick;  

void settings() {
  size(640, 320, P3D);
  PJOGL.profile=1;
}
void setup() {



  background(back, back, back);

  opencv = new OpenCV(this, 640, 320); 


  //kinect = new KinectPV2(this);
  //kinect.enableColorImg(true);
  //kinect.init();

  //spout = new Spout(this);
  //spout.createSender("Spout Processing");
  server = new SyphonServer(this, "Processing Syphon");

  lastTime = millis();



  // Set up columns and rows
  cols = 16;
  rows = 16;


  colorMode(RGB, 255, 255, 255, 100);
  rectMode(CENTER);

  Ntext = createFont("나눔바른고딕OTF", 20);

  cellSizeW = width / cols; 
  cellSizeH = height / rows;


  img = loadImage("IMG_7989.jpg");
  kinectIMG = new PImage(1920, 1080);
  liveIMG = new PImage(640, 320);


  cell = new color[16+3][16+2];
  bri = new int[16+3][16+2];
  bri2 = new int[16+3][16+2];

  Hue = new int[16+3][16+2];
  Sat = new int[16+3][16+2];
  SatV = new int[16+3][16+2];
  noOff = new int[16+3];
  reloff = new int[16+3][16+2];

  emptyC = new boolean[16][16];




  major = new int[32];


  major[0] = 36;
  major[1] = 38;
  major[2] = 40;
  major[3] = 41;
  major[4] = 43;
  major[5] = 45;
  major[6] = 47;
  major[7] = 48;
  major[8] = 50;
  major[9] = 52;
  major[10] = 53;
  major[11] = 55;
  major[12] = 57;
  major[13] = 59;
  major[14] = 60;
  major[15] = 62;
  major[16] = 64;
  major[17] = 65;
  major[18] = 67;
  major[19] = 69;
  major[20] = 71;



  String[] cameras = Capture.list();

  if (cameras == null) {
    println("Failed to retrieve the list of available cameras, will try the default...");
    video = new Capture(this, 640, 480);
  } 
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    printArray(cameras);

    // The camera can be initialized directly using an element
    // from the array returned by list():

    //video = new Capture(this, cameras[6]);
    video = new Capture(this, 1920, 1080, "ManyCam Virtual Webcam", 30);


    // Or, the settings can be defined based on the text in the list
    //cam = new Capture(this, 640, 480, "Built-in iSight", 30);

    // Start capturing the images from the camera
    video.start();
  }


  //video = new Capture(this, 640, 480, "ManyCam Virtual Webcam", 30);
  //video = new Capture(this, 640, 360, "FaceTime HD Camera", 30);





  // Start capturing the images from the camera
  video.start();  





  MidiBus.list(); //List all available Midi devices. This will show each device's index and name.

  //This is a different way of listing the available Midi devices.
  println(); 
  println("Available MIDI Devices:"); 

  System.out.println("----------Input (from availableInputs())----------");
  String[] available_inputs = MidiBus.availableInputs(); //Returns an array of available input devices
  for (int i = 0; i < available_inputs.length; i++) System.out.println("["+i+"] \""+available_inputs[i]+"\"");

  System.out.println("----------Output (from availableOutputs())----------");
  String[] available_outputs = MidiBus.availableOutputs(); //Returns an array of available output devices
  for (int i = 0; i < available_outputs.length; i++) System.out.println("["+i+"] \""+available_outputs[i]+"\"");

  System.out.println("----------Unavailable (from unavailableDevices())----------");
  String[] unavailable = MidiBus.unavailableDevices(); //Returns an array of unavailable devices
  for (int i = 0; i < unavailable.length; i++) System.out.println("["+i+"] \""+unavailable[i]+"\"");


  //busA = new MidiBus(this, 0, 1, "busA"); //기본 윈도우 미디
  busA = new MidiBus(this, 0, 3, "busA");
}







void draw() {
  if (video.available() == true) {
    video.read();
  }




  //println("mouseX = " + mouseX);
  //println("mouseY = " + mouseY);

  //kinectIMG.copy(kinect.getColorImage(), 656, 292, 874, 273,     0, 0, 1920, 1080);



  // kinectIMG.copy(video, Xpos, Ypos, 520, 260,     0, 0, 640, 320);

  kinectIMG.copy(video, 0, 0, 1920, 1080,     0, 0, 640, 320);
  
  
  
  //kinectIMG.copy(kinect.getColorImage(), Xpos, Ypos, 520, 260, 0, 0, 640, 320);
  //kinectIMG.copy(kinect.getColorImage(), 760, 290, 600, 260, 0, 0, 640, 320);





  // kinectIMG.brightness((int)map(camBri, 0, 640, 0, 255));


  //배경에 라이브 영상 표시
  //pushMatrix();
  //scale(-1, 1);

  //opencv.loadImage(kinectIMG);
  //opencv.brightness((int)map(camBri, 0, 640, 0, 255));

  //image(kinectIMG, 0, 0, 640, 320);
  //image(kinectIMG.get(), -640, 0);
  //image(opencv.getOutput(), -640, 0);


  //image(video.get(), -width, 0);  
  //tint(255, 15);
  //popMatrix();

  //image(kinectIMG, 0, 0);   
  //tint(255, 15);



  //pushMatrix();
  //scale(-1, 1);
  //image(kinectIMG.get(), -640, 0);
  //popMatrix();
  //loadPixels();



  kinectIMG.loadPixels();
  
  
  

  if (keyPressed) {

    if (key == ' ') {
      camMode = true;

      //웹캠영상 미러 (좌우반전)
      //pushMatrix();
      //scale(-1, 1);
      //image(kinectIMG.get(), -640, 0);
      //popMatrix();
      //loadPixels();
      image(kinectIMG, 0, 0);  
      
    } 

    //else if (mouseButton == RIGHT) {
    //  camMode = false;
    //  image(img, 0, 0);
    //} else {
    //}
  } else {
    pushMatrix();

    camMode=false;

    // Begin loop for columns
    for (int i = 0; i < cols; i++) {

      // Begin loop for rows
      for (int j =0; j < rows; j++) {

        if (mouseButton == RIGHT) {  //color test
          // Where are we, pixel-wise?

          int x = i * cellSizeW;
          int y = j * cellSizeH;

          int loc = (img.width + x) + y*img.width; // Reversing x to mirror the image
          //int loc = (img.width - x - 1) + y*img.width; // Reversing x to mirror the image


          // Each rect is colored white with a size determined by brightness
          color c = img.pixels[loc];
          hue = int(map(hue(c), 0, 255, 0, 180));
          sat = int(map(saturation(c), 0, 255, 0, 180));




          int bris = int(map(brightness(c), 0, 255, 0, 255));
          int bris2 = int(map(brightness(c), 0, 100, 127, 0));




          cell[i][j] = c;

          CC = c;

          bri[i][j] = bris;
          bri2[i][j] = bris2;

          Hue[i][j] = hue;
          Sat[i][j] = sat;


          x2 = x;
          y2 = y;
        } else {

          background(150);

          // Where are we, pixel-wise?
          int x = i * cellSizeW;
          int y = j * cellSizeH;
          int loc = (kinectIMG.width + x) + y*kinectIMG.width; // Reversing x to mirror the image
          //int loc = (this.width - x - 1) + y*this.width; // Reversing x to mirror the image


          // Each rect is colored white with a size determined by brightness
          color c = kinectIMG.pixels[loc];
          hue = int(map(hue(c), 0, 255, 0, 180));
          sat = int(map(saturation(c), 0, 255, 0, 180));
          satV = int(map(saturation(c), 0, 255, 0, 127));




          int bris = int(map(brightness(c), 0, 255, 0, 255));
          int bris2 = int(map(brightness(c), 0, 100, 127, 0));




          cell[i][j] = c;
          bri[i][j] = bris;
          bri2[i][j] = bris2;

          Hue[i][j] = hue;
          Sat[i][j] = sat;
          SatV[i][j] = satV;


          x2 = x;
          y2 = y;
        }
      }
    }

    popMatrix();

    //liveIMG.updatePixels();

    //background(0);

    //image(liveIMG,100,100,100,100);

    if ( millis() - lastTime > time ) {



      if (tickT < 15) {
        tickT = tickT +1 ;
      } else {
        tickT = 0;
      }



      lastTime = millis();



      if (ii == 0) {
        for (int n= 19; n >= 0; n--) {

          busA.sendNoteOff(0, major[n], 127);
          busA.sendNoteOff(1, major[n], 127);
          busA.sendNoteOff(2, major[n], 127);
          busA.sendNoteOff(3, major[n], 127);
          busA.sendNoteOff(4, major[n], 127);
          busA.sendNoteOff(5, major[n], 127);
          busA.sendNoteOff(6, major[n], 127);
          busA.sendNoteOff(7, major[n], 127);
        }
      }







      for (int c=15; c >= 0; c--) {


        // 빨강검출 (댐퍼패달효과, 건반을누고있는효과)
        if ( Hue[ii][15-c]<=15 && Sat[ii][15-c] > 20 && bri[ii][15-c] > 30)
        {
          empty = false;  
          midiCH = 1;

          if ( ii >= 1) {              
            if (Hue[ii-1][15-c]<=15 && Sat[ii-1][15-c] > 20 && bri[ii-1][15-c] > 30) {
              reloff[ii][c] = 1;
            } else {
              reloff[ii][c] = 2;
              empty = false;
              busA.sendNoteOn(midiCH, major[c]+high, 127);
            }
          } else {
            empty = false;
            reloff[ii][c] = 2;
            busA.sendNoteOn(midiCH, major[c]+high, 127);
          }
          
          println("it's RED!");
          
          
        } 

        // 노랑검출
        else if (Hue[ii][15-c]<=50 && Hue[ii][15-c] > 15 && Sat[ii][15-c] > 100 && bri[ii][15-c] > 30 )
        {
          //empty = false;            
          //midiCH = 2;
          //busA.sendNoteOn(midiCH, major[c]+high, 127);
          //println("it's yellow!");
        } 

        // 녹색검출
        else if (Hue[ii][15-c]<90 && Hue[ii][15-c] > 50 && Sat[ii][15-c] > 30 && bri[ii][15-c] > 30 )
        {
          empty = false;            
          midiCH = 3;
          busA.sendNoteOn(midiCH, major[c]+high, 127);
        } 

        // 파랑검출
        else if (Hue[ii][15-c]<130 && Hue[ii][15-c] > 90 && Sat[ii][15-c] > 30 && bri[ii][15-c] > 30)
        {
          empty = false;            
          midiCH = 4;
          high= 0;  //ony CH4 key up
          busA.sendNoteOn(midiCH, major[c]+high, 127);
        } 

        // 보라색 검출
        else if (Hue[ii][15-c]<=180 && Hue[ii][15-c] > 130 && Sat[ii][15-c] > 30 && bri[ii][15-c] > 30)
        {
          empty = false;
          println("it's puple!");
          midiCH = 2;
          busA.sendNoteOn(midiCH, major[c]+high, 127);
        } 


        // 검정색 검출
        else if (bri[ii][15-c] < 80 && Sat[ii][15-c] < 30)
        {
          empty = false;
          midiCH = 0;
          busA.sendNoteOn(midiCH, major[c]+high, 127);
        } else {
          empty = true;
        }




        emptyC[ii][15-c] = empty;

        tick = ii;

        high= 0;
      }


      for (int d=15; d >=0; d--) {
        if (reloff[ii][d] == 0) {


          busA.sendNoteOff(0, major[d], 127);
          busA.sendNoteOff(1, major[d], 127);
          busA.sendNoteOff(2, major[d], 127);
          busA.sendNoteOff(3, major[d], 127);
          busA.sendNoteOff(4, major[d], 127);
          busA.sendNoteOff(5, major[d], 127);
          busA.sendNoteOff(6, major[d], 127);
          busA.sendNoteOff(7, major[d], 127);
        }
      }


      if (ii < 15) {
        ii = ii +1 ;
      } else {
        ii = 0;
      }
    }
  }




  for (int i=0; i<width; i+=cellSizeW) {

    stroke(100, 100, 100, 255-rebootFade*4);
    strokeWeight(0.5);
    line(i, 0, i, height);
  }
  for (int w=0; w<height; w+=cellSizeH) {

    line(0, w, width, w);
  }



  //바컬러선택
  if (camMode==false) {
    for (int n = 0; n < 16; n++) {

      //컬러가 검출 되었을 때
      if (emptyC[tickT][n] == false && tickT >= 0) {


        fill(cell[tickT][n]);   //검출된 컬러로 표시 
        //fill(255,0);   //무조건 흰색으로 표시
        rect((tickT * cellSizeW) + cellSizeW/2, (n * cellSizeH) + cellSizeH/2, cellSizeW, cellSizeH);
      } 

      //컬러가 없을 때
      else {        
        fill(255);
        rect((tickT * cellSizeW) + cellSizeW/2, (n * cellSizeH) + cellSizeH/2, cellSizeW, cellSizeH);
      }
    }
  }


  //배경 컬러
  for (int i=0; i < 16; i++) {

    for (int j=0; j < 16; j++) {

      //스탭바 전체 현재 컬러
      if (i == tickT) {
        //stroke(0);
        fill(0, 0);
        //fill(cell[i][j]);
        rect(i * cellSizeW + cellSizeW/2, j * cellSizeH + cellSizeH/2, cellSizeW, cellSizeH);
      } 

      //스탭바를 제외한 배경 컬러
      else {
        //fill(back, back, back,30);
        fill(120,120,120, 5);
        //stroke(100);
        rect(i * cellSizeW + cellSizeW/2, j * cellSizeH + cellSizeH/2, cellSizeW, cellSizeH);
      }
    }
  }


  if (openFade >= 0) {
    openFade = openFade-5;
    fill(0, 0, 0, openFade);      
    noStroke();
    rect(width/2, height/2, 656, 480);
  }

  fill(0, 0, 0, fade);      
  noStroke();
  rect(width/2, height/2, 656, 480);
  // }








  //spout.sendTexture();
  server.sendScreen();
}



void delay(int time) {
  int current = millis();
  while (millis () < current+time) Thread.yield();
}




void keyPressed() {

  if (key == CODED) {

    if (keyCode == UP) {
      camBri += 5;

      println("briUP" + camBri);
    }
    if (keyCode == DOWN) {
      camBri -= 5;
      println("briDOWN" + camBri);
    }
  }
}

void mousePressed() {
  println("mouseX = " + mouseX);
  println("mouseY = " + mouseY);
}

void mouseDragged() {

  Xpos = mouseX;
  Ypos = mouseY;
}