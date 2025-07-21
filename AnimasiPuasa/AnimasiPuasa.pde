// AnimasiMain.pde - File Run Utama
// Animasi Dakwah "Sakti & Permen Karet"
// Canvas Size: 1280x720 px

// Import semua class karakter
Sakti sakti;
Dimas dimas;
Hafi hafi;
IbuWarung ibuWarung;
Scenes scenes;
UIControls uiControls;


// Global variables untuk timing
int currentScene = 1;
float sceneStartTime = 0;
boolean animationPlaying = true;
PFont font;

void setup() {
  size(1920, 1080);
  scenes = new Scenes(this);// Full HD - sesuai permintaan
  
  // Load font untuk dialog
  font = createFont("Arial", 24);
  textFont(font);
  
  // Initialize semua karakter
  sakti = new Sakti();
  dimas = new Dimas();
  hafi = new Hafi();
  ibuWarung = new IbuWarung();
  
  // Initialize scene controller dan UI
  uiControls = new UIControls();
  
  // Set waktu mulai scene pertama
  sceneStartTime = millis();
  
  println("Scene 1: Depan Warung (30 detik)");
}

void draw() {
  background(135, 206, 235);
  
  if (animationPlaying) {
    float elapsedTime = (millis() - sceneStartTime) / 1000.0;
    
    scenes.updateCurrentScene(currentScene, elapsedTime);
    scenes.renderCurrentScene(currentScene, elapsedTime);
    
    renderCharacters(currentScene, elapsedTime);
    
    if (scenes.isSceneComplete(currentScene, elapsedTime)) {
      nextScene();
    }
  }
  
  uiControls.render();
  uiControls.showSceneInfo(currentScene, (millis() - sceneStartTime) / 1000.0);
}

void renderCharacters(int scene, float time) {
  switch(scene) {
    case 1:
      sakti.renderDepanWarung(time);
      break;
    case 2:
      sakti.renderDalamWarung(time);
      ibuWarung.renderDalamWarung(time);
      break;
    case 3:
      sakti.renderBelakangRumah(time);
      if (time > 10) {
        hafi.renderBelakangRumah(time);
        dimas.renderBelakangRumah(time);
      }
      break;
    case 4:
      sakti.renderPerjalanan(time);
      hafi.renderPerjalanan(time);
      dimas.renderPerjalanan(time);
      break;
    case 5:
      sakti.renderTempatWudhu(time);
      hafi.renderTempatWudhu(time);
      dimas.renderTempatWudhu(time);
      break;
    case 6:
      sakti.renderDalamMasjid(time);
      hafi.renderDalamMasjid(time);
      dimas.renderDalamMasjid(time);
      break;
  }
}

void nextScene() {
  currentScene++;
  sceneStartTime = millis();
  
  if (currentScene > 6) {
    println("Animasi selesai!");
    animationPlaying = false;
    return;
  }
  
  String[] sceneNames = {
    "", "Depan Warung", "Dalam Warung", "Belakang Rumah", 
    "Perjalanan ke Masjid", "Tempat Wudhu", "Dalam Masjid"
  };
  int[] sceneDurations = {0, 25, 45, 60, 28, 23, 20};
  
  println("Scene " + currentScene + ": " + sceneNames[currentScene] + 
          " (" + sceneDurations[currentScene] + " detik)");
}

void keyPressed() {
  if (key == ' ') {
    animationPlaying = !animationPlaying;
  } else if (key == 'n' || key == 'N') {
    nextScene();
  } else if (key == 'r' || key == 'R') {
    currentScene = 1;
    sceneStartTime = millis();
    animationPlaying = true;
  }
}

void mousePressed() {
  uiControls.handleMousePress(mouseX, mouseY);
}
