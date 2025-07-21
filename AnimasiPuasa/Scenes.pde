// Scenes.pde - Controller untuk semua scene
import processing.sound.*;

class Scenes {
  PImage belakangRumah, dalamMasjid, dalamWarung;
  PImage jalanPerkampungan, perjalananWarung, tempatWudhu;
  
  SoundFile adzanSound, endingSound;
  boolean adzanPlayed = false;
  boolean adzanStopped = false;
  boolean endingPlayed = false;
  
  int[] sceneDurations = {0, 25, 45, 60, 28, 23, 20};
  String[] sceneNames = {
    "", "Depan Warung", "Dalam Warung", "Belakang Rumah", 
    "Perjalanan ke Masjid", "Tempat Wudhu", "Dalam Masjid"
  };
  
  // Animasi variables
  float cloudX1 = 0, cloudX2 = 300;
  float birdY = 100;
  float treeSwing = 0;
  float sunAngle = 0;
  float grassSway = 0;
  float smokeOffset = 0;
  float waterDrop = 0;
  float prayerSway = 0;
  
  PApplet parent;
  
  Scenes(PApplet p) {
    this.parent = p;
    loadBackgrounds();
  }
  
  void loadBackgrounds() {
    boolean ENABLE_IMAGE_LOADING = true;
    
    if (ENABLE_IMAGE_LOADING) {
      try {
        // Load hanya image yang diperlukan
        dalamMasjid = loadImage("dalamMasjid.jpg");
        dalamWarung = loadImage("dalamWarung.jpg");
        tempatWudhu = loadImage("tempatWudhu.jpg");
        
        // Image lain set ke null untuk menggunakan procedural drawing
        belakangRumah = null;
        jalanPerkampungan = null;
        perjalananWarung = null;
        
        println("Backgrounds: Selected images loaded successfully");
      } catch (Exception e) {
        println("Error loading some images: " + e.getMessage());
      }
      
      try {
        // Load adzan sound
        adzanSound = new SoundFile(parent, "adzan.mp3");
        adzanSound.amp(0.8);
        
        // Load ending sound
        endingSound = new SoundFile(parent, "endingSound.mp3");
        endingSound.amp(0.8);
        
        println("Audio: Sound files loaded successfully");
      } catch (Exception e) {
        println("Error loading audio files: " + e.getMessage());
        adzanSound = null;
        endingSound = null;
      }
    } else {
      belakangRumah = null;
      dalamMasjid = null;
      dalamWarung = null;
      jalanPerkampungan = null;
      perjalananWarung = null;
      tempatWudhu = null;
      
      println("Backgrounds: Using procedural drawing for all scenes");
    }
  }
  
  void updateCurrentScene(int sceneNumber, float time) {
    // Update animasi global
    cloudX1 += 0.5;
    cloudX2 += 0.3;
    if (cloudX1 > width + 100) cloudX1 = -200;
    if (cloudX2 > width + 100) cloudX2 = -150;
    
    birdY = 100 + sin(time * 2) * 20;
    treeSwing = sin(time * 0.5) * 0.05;
    sunAngle += 0.02;
    grassSway = sin(time * 3) * 2;
    smokeOffset += 1;
    waterDrop = sin(time * 4) * 10;
    prayerSway = sin(time * 0.8) * 0.03;
  }
  
  void renderCurrentScene(int sceneNumber, float time) {
    float sceneAlpha = 255;
    if (time < 1) {
      sceneAlpha = map(time, 0, 1, 0, 255);
    }
    
    if (sceneNumber == 4) {
      // Mulai adzan 5 detik sebelum dialog Hafi
      float hafiDialogTime = 20.0; // Waktu dialog Hafi muncul (sesuaikan dengan kode dialog Anda)
      float adzanStartTime = hafiDialogTime - 5.0; // 5 detik sebelum dialog
      
      // Mulai adzan di waktu yang tepat
      if (time >= adzanStartTime && time < hafiDialogTime && !adzanPlayed && !adzanStopped) {
        if (adzanSound != null) {
          adzanSound.play();
          adzanPlayed = true;
          println("Playing adzan sound at time: " + time);
        }
      }
    }
    
    // Reset status saat keluar dari scene 4
    if (sceneNumber != 4) {
      if (adzanPlayed && adzanSound != null) {
        adzanSound.stop();
      }
      adzanPlayed = false;
      adzanStopped = false;
    }
    
    // Manajemen audio untuk scene 6 (ending)
    if (sceneNumber == 6 && !endingPlayed) {
      if (endingSound != null) {
        endingSound.play();
        endingPlayed = true;
        println("Playing ending sound...");
      }
    }
    
    // Render scene berdasarkan nomor
    switch(sceneNumber) {
      case 1:
        renderDepanWarung();
        addDepanWarungAnimations();
        break;
      case 2:
        renderDalamWarung();
        addDalamWarungAnimations();
        break;
      case 3:
        renderBelakangRumah();
        addBelakangRumahAnimations();
        break;
      case 4:
        renderPerjalananMasjid();
        addPerjalananAnimations();
        break;
      case 5:
        renderTempatWudhu();
        addTempatWudhuAnimations();
        break;
      case 6:
        renderDalamMasjid();
        addDalamMasjidAnimations();
        break;
    }
    
    // Tambahkan elemen langit untuk scene outdoor
    if (sceneNumber == 1 || sceneNumber == 4) {
      renderClouds();
      renderBirds();
      renderSun();
    }
    
    // Tampilkan teks adzan saat scene 4
    if (sceneNumber == 4 && adzanPlayed && !adzanStopped) {
      fill(0, 0, 0, 150);
      rect(0, 0, width, 80);
      fill(255, 255, 255);
      textSize(28);
      textAlign(CENTER);
      text("♫ Adzan Berkumandang ♫", width / 2, 50);
    }
    
    // Tampilkan teks ending saat scene 6
    if (sceneNumber == 6 && endingPlayed) {
      fill(0, 0, 0, 100);
      rect(0, height - 100, width, 100);
      fill(255, 255, 255);
      textSize(20);
      textAlign(CENTER);
      text("♫ Sholat Berjamaah Selesai ♫", width / 2, height - 50);
    }
    
    // Fade in effect
    if (sceneAlpha < 255) {
      fill(0, 0, 0, 255 - sceneAlpha);
      rect(0, 0, width, height);
    }
  }
  
  void renderDepanWarung() {
    if (perjalananWarung != null) {
      image(perjalananWarung, width/2, height/2, width, height);
    } else {
      // Gradasi langit
      for (int i = 0; i <= height/2; i++) {
        float inter = map(i, 0, height/2, 0, 1);
        color c = lerpColor(color(135, 206, 235), color(255, 255, 220), inter);
        stroke(c);
        line(0, i, width, i);
      }
      noStroke();
      
      // Tanah
      fill(194, 154, 108);
      rect(0, height/2 + 50, width, height/2);
      
      // Rumput
      fill(34, 139, 34);
      rect(0, height/2, width, 300);
      
      drawWarungBuilding(width * 0.3, height * 0.4 - 80);
      
      // Pohon kiri dan kanan
      drawTree(150, height/2);
      drawTree(width - 150, height/2);
    }
  }
  
  void addDepanWarungAnimations() {
    
    // Ayam berkeliaran
    float chickenX = width * 0.6 + sin(frameCount * 0.05) * 50;
    drawChicken(chickenX, height/2 + 30);
    
  }
  
  void renderDalamWarung() {
    if (dalamWarung != null) {
      image(dalamWarung, width/2, height/2, width, height);
    } else {
      // Fallback - interior warung
      fill(200, 180, 160);
      rect(0, 0, width, height);
      
      // Papan kayu horizontal
      fill(139, 69, 19);
      for (int i = 0; i < 8; i++) {
        rect(width * 0.05, height * 0.1 + i * height * 0.1, width * 0.9, 25);
      }
      
      // Meja/counter warung
      fill(160, 120, 80);
      rect(width * 0.6, height * 0.65, width * 0.35, height * 0.25);
      
      // Peralatan makan
      drawKitchenItems();
    }
  }
  
  void addDalamWarungAnimations() {
    // Lalat terbang
    drawFlies();
  }
  
  void renderBelakangRumah() {
    if (belakangRumah != null) {
      image(belakangRumah, width/2, height/2, width, height);
    } else {
      // Gradasi langit
      for (int i = 0; i <= height; i++) {
        float inter = map(i, 0, height, 0, 1);
        color c = lerpColor(color(135, 206, 235), color(255, 255, 220), inter);
        stroke(c);
        line(0, i, width, i);
      }
      noStroke();
      
      // Atap rumah merah
      fill(#7C2828);
      rect(width * 0.09, height * 0.08, width, height * 0.05);
      fill(200, 50, 0);
      rect(width * 0.08, height * 0.12, width, height * 0.05);
      fill(255, 69, 0);
      rect(width * 0.07, height * 0.16, width, height * 0.05);
      fill(200, 50, 0);
      rect(width * 0.06, height * 0.2, width, height * 0.05);
      
      // Rumput
      fill(34, 139, 34);
      rect(0, height * 0.7, width, height * 0.3);
      
      // Dinding rumah
      fill(222, 184, 135);
      rect(width * 0.1, height * 0.25, width, height * 0.45);
      
      // Jendela
      drawWindow(width * 0.2, height * 0.35);
      
      // Pohon dengan animasi goyang
      pushMatrix();
      translate(width * 0.8, height * 0.7);
      rotate(treeSwing);
      fill(139, 69, 19);
      rect(-30, 0, 60, -height * 0.4);
      fill(34, 139, 34);
      ellipse(0, -height * 0.4, 200, 200);
      popMatrix();
      
      // Batu besar
      fill(128, 128, 128);
      ellipse(width * 0.5, height * 0.78, 180, 90);
    }
  }
  
  void addBelakangRumahAnimations() {
    // Kupu-kupu terbang
    drawButterfly(width * 0.6 + sin(frameCount * 0.08) * 100, 
                  height * 0.5 + cos(frameCount * 0.1) * 50);

  }
  
  void renderPerjalananMasjid() {
    if (jalanPerkampungan != null) {
      image(jalanPerkampungan, width/2, height/2, width, height);
    } else {
      // Gradasi langit
      for (int i = 0; i <= height; i++) {
        float inter = map(i, 0, height, 0, 1);
        color c = lerpColor(color(135, 206, 235), color(255, 255, 220), inter);
        stroke(c);
        line(0, i, width, i);
      }
      noStroke();
      
      // Rumput
      fill(34, 139, 34);
      rect(0, height * 0.7, width, height * 0.15);
      
      // Jalan aspal
      fill(80, 80, 80);
      rect(0, height * 0.85, width, height * 0.15);
      
      // Garis jalan
      stroke(255, 255, 0);
      strokeWeight(3);
      for (int i = 0; i < width; i += 40) {
        line(i, height * 0.92, i + 20, height * 0.92);
      }
      noStroke();
      
      // Rumah-rumah di sepanjang jalan
      for (int i = 0; i < 8; i++) {
        float houseX = i * width * 0.12 + width * 0.02;
        float houseWidth = width * 0.10;
        float houseHeight = height * 0.20;
        
        // Dinding rumah
        fill(180, 160, 140);
        rect(houseX, height * 0.50, houseWidth, houseHeight);
        
        // Atap rumah
        fill(140, 70, 40);
        triangle(houseX - houseWidth * 0.1, height * 0.50, 
                houseX + houseWidth * 0.5, height * 0.38, 
                houseX + houseWidth * 1.1, height * 0.50);
        
        // Jendela kecil
        fill(100, 149, 237);
        rect(houseX + houseWidth * 0.3, height * 0.55, houseWidth * 0.4, houseHeight * 0.3);
      }
    }
  }
  
  void addPerjalananAnimations() {
    
    // Daun berguguran
    drawFallingLeaves();
  }
  
  void renderTempatWudhu() {
    if (tempatWudhu != null) {
      image(tempatWudhu, width/2, height/2, width, height);
    } else {
      // Fallback - tempat wudhu sederhana
      fill(240, 240, 240);
      rect(0, 0, width, height);
      
      // Lantai keramik
      drawTileFloor();
      
      // Kran-kran wudhu
      for (int row = 0; row < 2; row++) {
        for (int col = 0; col < 6; col++) {
          float tapX = width * 0.1 + col * width * 0.13;
          float tapY = height * 0.3 + row * height * 0.4;
          
          fill(100, 100, 100);
          rect(tapX, tapY, 40, 80);
          
          fill(150, 150, 150);
          ellipse(tapX + 20, tapY, 50, 50);
          
          // Handle kran
          fill(200, 200, 200);
          ellipse(tapX + 35, tapY + 10, 8, 8);
        }
      }
    }
  }
  
  void addTempatWudhuAnimations() {
    
    // Tetesan air
    drawWaterDrops();
  }
  
  void renderDalamMasjid() {
    if (dalamMasjid != null) {
      image(dalamMasjid, width/2, height/2, width, height);
    } else {
      // Fallback - interior masjid
      fill(250, 240, 230);
      rect(0, 0, width, height);
      
      // Karpet sholat
      for (int i = 0; i < 15; i++) {
        for (int j = 0; j < 10; j++) {
          fill(150, 100, 100);
          rect(i * width * 0.065, j * height * 0.08 + height * 0.2, 
               width * 0.06, height * 0.075);
        }
      }
      
      // Mihrab
      fill(200, 180, 150);
      arc(width * 0.5, height * 0.15, 300, 300, 0, PI);
      
      // Pilar masjid
      for (int i = 0; i < 4; i++) {
        float pillarX = width * 0.15 + i * width * 0.23;
        fill(220, 200, 180);
        rect(pillarX, height * 0.05, 60, height * 0.9);
        
        // Detail pilar
        fill(200, 180, 160);
        rect(pillarX + 10, height * 0.1, 40, 20);
        rect(pillarX + 10, height * 0.8, 40, 20);
      }
      
      // Lampu gantung
      drawChandelier(width/2, height * 0.15);
    }
  }
  
  void addDalamMasjidAnimations() {
    
    // Cahaya spiritual
    drawSpiritualLight();
  }
  
  // ===== HELPER FUNCTIONS =====
  
  void drawWarungBuilding(float x, float y) {
    // Atap warung (3x lipat)
    fill(255, 69, 0);
    triangle(x - 360, y, x, y - 120, x + 360, y);
    
    // Dinding (3x lipat)
    fill(255, 218, 185);
    rect(x - 300, y, 600, 240);
    
    // Tiang (3x lipat)
    fill(139, 69, 19);
    rect(x - 330, y, 30, 300);
    rect(x + 300, y, 30, 300);
    
    // Papan nama (3x lipat)
    fill(255, 255, 0);
    rect(x - 210, y - 60, 420, 75);
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(42);
    text("Waroeng bu endah", x, y - 22);
    
    // Pintu (3x lipat)
    fill(139, 69, 19);
    rect(x - 240, y + 90, 105, 150);
    
    // Counter (3x lipat)
    fill(160, 120, 80);
    rect(x - 90, y + 120, 240, 120);
}
  
  void drawTree(float x, float y) {
    // Batang
    fill(139, 69, 19);
    rect(x - 8, y - 20, 16, 40);
    
    // Daun bergoyang
    pushMatrix();
    translate(x, y - 40);
    rotate(treeSwing);
    fill(34, 139, 34);
    ellipse(0, 0, 80, 80);
    popMatrix();
  }
  
  void drawSmoke(float x, float y) {
    fill(200, 200, 200, 100);
    for (int i = 0; i < 3; i++) {
      float smokeY = y + i * 20 - (smokeOffset % 60);
      float smokeSize = 15 + i * 5;
      ellipse(x + sin(smokeOffset * 0.1 + i) * 10, smokeY, smokeSize, smokeSize);
    }
  }
  
  void drawChicken(float x, float y) {
    // Badan
    fill(255, 255, 255);
    ellipse(x, y - 5, 20, 15);
    ellipse(x + 8, y - 12, 12, 10);
    
    // Jengger
    fill(255, 0, 0);
    triangle(x + 10, y - 18, x + 12, y - 15, x + 14, y - 18);
    
    // Paruh
    fill(255, 165, 0);
    triangle(x + 14, y - 12, x + 17, y - 11, x + 14, y - 10);
    
    // Kaki
    stroke(255, 165, 0);
    strokeWeight(2);
    line(x - 3, y + 3, x - 3, y + 8);
    line(x + 3, y + 3, x + 3, y + 8);
    noStroke();
  }
  
  void drawSwayingGrass() {
    fill(34, 139, 34);
    for (int i = 0; i < width; i += 30) {
      pushMatrix();
      translate(i, height/2 + 40);
      rotate(sin(frameCount * 0.05 + i * 0.01) * 0.1);
      rect(-2, 0, 4, 15);
      popMatrix();
    }
  }
  
  void drawFlies() {
    fill(0);
    for (int i = 0; i < 3; i++) {
      float flyX = width * 0.3 + sin(frameCount * 0.1 + i * 2) * 100;
      float flyY = height * 0.4 + cos(frameCount * 0.15 + i * 1.5) * 80;
      ellipse(flyX, flyY, 3, 3);
    }
  }
  
  void drawFoodSmoke(float x, float y) {
    fill(255, 255, 255, 120);
    for (int i = 0; i < 4; i++) {
      float smokeY = y - i * 15 - (frameCount % 60);
      float smokeSize = 8 + i * 3;
      float sway = sin(frameCount * 0.1 + i) * 5;
      ellipse(x + sway, smokeY, smokeSize, smokeSize);
    }
  }
  
  void drawWindowLight() {
    fill(255, 255, 200, 80);
    triangle(width * 0.05, height * 0.3, width * 0.05, height * 0.7, width * 0.4, height * 0.5);
  }
  
  void drawShakingItems() {
    float shake = sin(frameCount * 0.2) * 0.5;
    
    pushMatrix();
    translate(shake, shake);
    
    fill(255);
    ellipse(width * 0.7, height * 0.75, 25, 25);
    
    fill(150, 200, 255);
    rect(width * 0.75, height * 0.7, 8, 12);
    
    fill(200, 200, 200);
    ellipse(width * 0.85, height * 0.78, 3, 8);
    
    popMatrix();
  }
  
  void drawKitchenItems() {
    // Panci
    fill(100, 100, 100);
    ellipse(width * 0.7, height * 0.5, 40, 20);
    
    // Sendok kayu
    fill(139, 69, 19);
    rect(width * 0.65, height * 0.45, 3, 15);
    ellipse(width * 0.665, height * 0.43, 8, 8);
  }
  
  void drawWindow(float x, float y) {
    // Frame jendela (5x lipat)
    fill(139, 69, 19);
    rect(x, y, 300, 200);
    
    // Kaca jendela (5x lipat)
    fill(173, 216, 230, 150);
    rect(x + 25, y + 25, 125, 150);
    rect(x + 150, y + 25, 125, 150);
    rect(x + 25, y + 25, 250, 75);
    rect(x + 25, y + 100, 250, 75);
    
    // Frame tengah (5x lipat)
    fill(139, 69, 19);
    rect(x + 135, y + 25, 30, 150);
    rect(x + 25, y + 85, 250, 30);
}
  
  void drawButterfly(float x, float y) {
    pushMatrix();
    translate(x, y);
    
    fill(0);
    ellipse(0, 0, 2, 12);
    
    fill(255, 100, 150, 200);
    pushMatrix();
    rotate(sin(frameCount * 0.3) * 0.3);
    ellipse(-4, -3, 8, 6);
    ellipse(-4, 3, 6, 4);
    popMatrix();
    
    pushMatrix();
    rotate(-sin(frameCount * 0.3) * 0.3);
    ellipse(4, -3, 8, 6);
    ellipse(4, 3, 6, 4);
    popMatrix();
    
    popMatrix();
  }
  
  void drawDetailedGrass() {
    fill(50, 205, 50);
    for (int i = 50; i < width; i += 80) {
      pushMatrix();
      translate(i + grassSway, height * 0.75);
      rotate(grassSway * 0.02);
      ellipse(0, 0, 15, 8);
      triangle(-3, 0, 0, -8, 3, 0);
      popMatrix();
    }
  }
  
  void drawWindowGlow() {
    fill(255, 255, 0, 100 + sin(frameCount * 0.1) * 20);
    rect(width * 0.15, height * 0.35, 60, 40);
  }
  
  void drawWalkingPeople() {
    for (int i = 0; i < 3; i++) {
      float personX = (frameCount * 1.5 + i * 150) % (width + 50) - 25;
      float personY = height * 0.8;
      
      // Orang berjalan
      fill(100, 50, 0);
      ellipse(personX, personY - 25, 15, 15); // kepala
      rect(personX - 5, personY - 20, 10, 15); // badan
      
      // Kaki bergerak
      float legMove = sin(frameCount * 0.2 + i) * 5;
      line(personX - 2, personY - 5, personX - 2 + legMove, personY + 5);
      line(personX + 2, personY - 5, personX + 2 - legMove, personY + 5);
    }
  }
  
  void drawVehicles() {
    float bikeX = (frameCount * 3) % (width + 100) - 50;
    
    // Sepeda motor
    fill(255, 0, 0);
    rect(bikeX, height * 0.88, 30, 8);
    
    // Roda
    fill(0);
    ellipse(bikeX + 5, height * 0.9, 12, 12);
    ellipse(bikeX + 25, height * 0.9, 12, 12);
  }
  
  void drawFallingLeaves() {
    fill(139, 69, 19, 150);
    for (int i = 0; i < 5; i++) {
      float leafX = (width * 0.2 * i + frameCount + i * 50) % width;
      float leafY = (frameCount * 0.8 + i * 80) % height;
      
      pushMatrix();
      translate(leafX, leafY);
      rotate(frameCount * 0.02 + i);
      ellipse(0, 0, 8, 12);
      popMatrix();
    }
  }
  
  void drawTileFloor() {
    for (int i = 0; i < width/40; i++) {
      for (int j = 0; j < height/40; j++) {
        fill((i + j) % 2 == 0 ? 220 : 200);
        rect(i * 40, j * 40, 40, 40);
      }
    }
  }
  
  void drawWaterFlow() {
    fill(100, 150, 255, 150);
    for (int i = 0; i < 6; i++) {
      float tapX = width * 0.1 + i * width * 0.13;
      rect(tapX + 18, height * 0.35, 4, 20 + waterDrop);
    }
  }
  
  void drawWudhuPeople() {
    for (int i = 0; i < 3; i++) {
      float personX = width * 0.15 + i * width * 0.25;
      float personY = height * 0.6;
      
      // Orang berwudhu
      fill(100, 80, 60);
      ellipse(personX, personY - 20, 12, 12); // kepala
      rect(personX - 6, personY - 15, 12, 20); // badan
      
      // Gerakan wudhu
      float armMove = sin(frameCount * 0.1 + i) * 3;
      line(personX - 6, personY - 10, personX - 10 + armMove, personY - 5);
      line(personX + 6, personY - 10, personX + 10 - armMove, personY - 5);
    }
  }
  
  void drawWaterDrops() {
    fill(100, 150, 255, 200);
    for (int i = 0; i < 20; i++) {
      float dropX = random(width);
      float dropY = (frameCount * 2 + i * 30) % height;
      ellipse(dropX, dropY, 3, 6);
    }
  }
  
  void drawChandelier(float x, float y) {
    // Lampu gantung masjid
    fill(255, 215, 0);
    ellipse(x, y, 80, 40);
    
    // Detail lampu
    fill(255, 255, 0, 150);
    ellipse(x, y, 60, 30);
    
    // Rantai gantung
    stroke(100);
    strokeWeight(2);
    line(x, y - 20, x, y - 50);
    noStroke();
  }
  
  void drawPrayingPeople() {
    for (int i = 0; i < 12; i++) {
      for (int j = 0; j < 8; j++) {
        float personX = width * 0.1 + i * width * 0.07;
        float personY = height * 0.3 + j * height * 0.08;
        
        pushMatrix();
        translate(personX, personY);
        rotate(prayerSway);
        
        // Orang sholat
        fill(80, 60, 40);
        rect(-3, -5, 6, 10); // badan membungkuk
        ellipse(0, -8, 6, 6); // kepala
        
        popMatrix();
      }
    }
  }
  
  void drawSpiritualLight() {
    // Cahaya spiritual dari mihrab
    fill(255, 255, 200, 50);
    for (int i = 0; i < 5; i++) {
      float radius = 100 + i * 50;
      ellipse(width/2, height * 0.15, radius, radius);
    }
  }
  
  void drawPeaceEffect() {
    // Efek kedamaian - partikel cahaya
    fill(255, 255, 255, 100);
    for (int i = 0; i < 10; i++) {
      float particleX = width/2 + sin(frameCount * 0.02 + i) * 200;
      float particleY = height * 0.3 + cos(frameCount * 0.02 + i) * 100;
      ellipse(particleX, particleY, 5, 5);
    }
  }
  
  void renderClouds() {
    fill(255, 255, 255, 200);
    noStroke();
    
    // Awan 1
    ellipse(cloudX1, 80, 60, 40);
    ellipse(cloudX1 + 30, 80, 80, 50);
    ellipse(cloudX1 + 60, 80, 60, 40);
    
    // Awan 2
    ellipse(cloudX2, 120, 50, 30);
    ellipse(cloudX2 + 25, 120, 70, 40);
    ellipse(cloudX2 + 50, 120, 50, 30);
  }
  
  void renderBirds() {
    stroke(0);
    strokeWeight(2);
    
    for (int i = 0; i < 3; i++) {
      float birdX = width * 0.7 + i * 80;
      float currentBirdY = birdY + i * 10;
      
      // Bentuk burung sederhana
      line(birdX - 10, currentBirdY, birdX, currentBirdY - 5);
      line(birdX, currentBirdY - 5, birdX + 10, currentBirdY);
    }
    
    noStroke();
  }
  
  void renderSun() {
    pushMatrix();
    translate(width - 150, 100);
    rotate(sunAngle);
    
    // Matahari
    fill(255, 220, 0);
    ellipse(0, 0, 60, 60);
    
    // Sinar matahari
    stroke(255, 255, 0, 150);
    strokeWeight(3);
    for (int i = 0; i < 8; i++) {
      float angle = i * PI / 4;
      line(cos(angle) * 35, sin(angle) * 35, 
           cos(angle) * 50, sin(angle) * 50);
    }
    noStroke();
    popMatrix();
  }
  
  // ===== SCENE MANAGEMENT FUNCTIONS =====
  
  boolean isSceneComplete(int sceneNumber, float elapsedTime) {
    return elapsedTime >= sceneDurations[sceneNumber];
  }
  
  String getSceneName(int sceneNumber) {
    if (sceneNumber >= 1 && sceneNumber <= 6) {
      return sceneNames[sceneNumber];
    }
    return "Unknown Scene";
  }
  
  int getSceneDuration(int sceneNumber) {
    if (sceneNumber >= 1 && sceneNumber <= 6) {
      return sceneDurations[sceneNumber];
    }
    return 0;
  }
  
  // Fungsi untuk reset audio saat restart
  void resetAudio() {
    if (adzanSound != null && adzanSound.isPlaying()) {
      adzanSound.stop();
    }
    if (endingSound != null && endingSound.isPlaying()) {
      endingSound.stop();
    }
    adzanPlayed = false;
    adzanStopped = false;
    endingPlayed = false;
  }
  
  // Fungsi untuk pause/resume audio
  void pauseAudio() {
    if (adzanSound != null && adzanSound.isPlaying()) {
      adzanSound.pause();
    }
    if (endingSound != null && endingSound.isPlaying()) {
      endingSound.pause();
    }
  }
  
  void resumeAudio() {
    // Resume hanya jika sedang di scene yang tepat
    if (adzanPlayed && adzanSound != null) {
      adzanSound.play();
    }
    if (endingPlayed && endingSound != null) {
      endingSound.play();
    }
  }
}
