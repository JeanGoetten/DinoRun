// VARIÁVEIS 
PImage img_dino; // variável do tipo imagem para armazenar o idle do dino 
PImage img_dinoWalk; // variável do tipo imagem para armazenar o andar do dino
PImage img_dinoJump; // variável do tipo imagem para armazenar o pulo do dino 
PImage img_bird; // variável do tipo imagem paraarmazenar o idle do pássaro 
PImage img_birdFly; // variável do tipo imagem para armazenar o voo do pássaro 
PImage img_cactus; // variável do tipo imagem apar azrmazenar o idle do cacto 

PImage img_dinoLogo; // variável do tipo imagem para armazenar a logo (face do dino)

// variáveis de coordenadas 
float dinoY; // variável numérica para armazenar a posição vertical do dino 
float dinoX; // variável numérica para armazenar a posição horizonteal do dino 
float startY; // variável numérica para armazenar a posição vertical inicial do dino 
float y_bird; // variável numérica para armazenar a posição vertical do pássaro 
float x_bird; // variável numérica para armazenar a posição horizontal do pássaro 
float y_cactus; // variável numérica para armazenar a posição vertical do cato (parado)
float x_cactus; // variável numérica para armazenar a posição horizontal do cacto (movimento)

// variáveis de deslocamento 
float speedBird; // variável numérica para armazenar o incremento de posiç´~ao horizontal do pássaro 
float speedCactus; // variável numérica paa armazenar o incremento de posição horizontal do cacto

float dinoYIncrease; // variável numérica para azrmazenar o incremento vertical do dino (pulo)
float jumpSpeed; // variável numérica para armazenar a velocidade do incremento vertical do dino
float fallSpeed; // variável numérica usada para armazenar a velocidade do decremento vertical do dino 
float maxJump; // variável numérica para armazenar o valor máximo vertical que o dino pode ter com o pulo 
float maxFallSpeed; // variável numérica para armazenar o valor máximo da velocidade de deslocamento vertical 

// variáveis de tempo 
float delta; // armazena a diferença de tempo entre dois momentos 
int lastTime; // armazena o tempo de um determinado evento (cool down de pulo)
int score; // armazena a passagem do tempo como pontuação 
int tempoNaoJogado; // armazena o tempo não jogado para subtrair do score

// variáveis de controle e mecânica 
float jumpCD;  // cooldown do pulo
boolean canJump;  // armazena se o jogador pode pular num dado momento 
boolean grounded; // armazena se o dino está no chão 
boolean fall; // armazena se o dino está caindo após o pulo 

int animDinoWalkSpeed; // armazena quantos frames durará a animação andar do dino (walk cicle)
int animBirdFlySpeed; // armazena quantos frames durará a animação andar do dino (walk cicle)
int lastFrame; 
int countFrame; 

boolean gamming; // registra se o jogo está rodando ou não 

int i = 0; // contador para testes

float deltaY; 

// INICIALIZAÇÃO
void setup(){
  background(0); // define a cor do background 
  size(900,500); // define o tamanho da janela 
  frameRate(60); // fixa o frame rate 
  
  img_dino = loadImage("dino.png"); // carrega a imagem e armazena na variável de tipo correspondete
  img_dinoWalk = loadImage("dinoWalk.png"); // carrega a imagem e armazena na variável de tipo correspondete
  img_dinoJump = loadImage("dinoJump.png"); // carrega a imagem e armazena na variável de tipo correspondete
  img_dinoLogo = loadImage("dinoLogo.png"); // carrega a imagem e armazena na variável de tipo correspondete
  img_bird = loadImage("bird.png"); // carrega a imagem e armazena na variável de tipo correspondete
  img_cactus = loadImage("cactus.png"); // carrega a imagem e armazena na variável de tipo correspondete
  
  dinoX = 100; // posição horizontal inicial do dino 
  startY = 260; // posição vertical inicial do dino (verificação de pulo e queda)
  x_bird = 450*PI; // posição horizontal inicial do pássaro 
  x_cactus = 1000; // posição horizontal inicial do cacto
  
  speedBird = 5; // velocidade inicial do pássaro 
  speedCactus = 2; // velocidade inicial do cato 
  
  dinoYIncrease = 10; // variável de incremento vertical do dino (usada para o pulo)
  maxJump = -200; // valor vertical máximo do dino enquanto pula 
  jumpSpeed = 4; // velocidade de subida do pulo do dino 
  fallSpeed = 0; // velocidade de queda do pulo do dino 
  maxFallSpeed = 4; 
  
  delta = 0; // inicia o delta tempo
  lastTime = 0; // inicializa o registro de tempo do evento pulo
  
  jumpCD = 1; // inicializa o valor do cool down do pulo
  canJump = true; // possibilidade de pulo inicial 
  grounded = true; // começa o jogo no chão 
  fall = false; // começo o jogo não caindo 
  
  score = 0; // começa o jogo com zero pontos 
  
  animDinoWalkSpeed = 12; // velocidade da animação walk cycle do dino em frames 
  animBirdFlySpeed = 12; // velocidade da animação de voo do pássaro em frames 
  lastFrame = 0; 
  countFrame = 0; 
  
  gamming = false; // inicia o programa sem acesso ao jogo 
  
  tempoNaoJogado = 0; // inicializa o tempo não jogado 
  
  deltaY = 0; 
}

// LOOP PRINCIPAL 
void draw(){
  if(Start()){ // jogo - retorna falso enquanto o jogador não apertar enter 
    inGame(); // Desenha os elementos estáticos do jogo e o escore
    
    Dino(); // função de print e movimento do Dino
    Bird(); // função de print e movimento do pássaro 
    Cactus(); // função de print e movimento do cacto, simulando o movimento do cenário 
    
    dinoY = (height/2)+dinoYIncrease; // posiciona o dino no eixo Y e incrementa durante o pulo
    y_cactus = height/2-25; // posiciona o cacto um pouco acima do meio da tela 
    x_cactus = x_cactus - (speedCactus+(score/20)); // decrementa crescentemente a medida horizontal pra simular movimento acelerado
    x_bird = x_bird - (PI/3+(score/20)); // movimento horizontal do pássaro 
    y_bird = (sin(x_bird/50)*40) + 150; // incrementa de forma senoidal o movimento vertical do pássaro em relação a x
    
    delta = (millis() - lastTime)/1000; // captura a difença de tempo
    if(delta >= jumpCD){ // verifica se a diferença de tempo é maior que o cool down do pulo
      canJump = true; // pode pular 
    }else{
        canJump = false; // nçao pode pular 
    }
    
    if(OnCollisionEnter(dinoX, dinoY, x_cactus, y_cactus, 25, 45)){ // verifica a distância dino-cacto a cada frame
      gamming = false; // encerra o loop de jogo 
    }
    if(OnCollisionEnter(dinoX, dinoY, x_bird, y_bird, 25, 25)){ // verifica a distância dino-pássaro a cada frame
      gamming = false; // encerra o loop de jogo 
    }
    
  }else{ // Tela de apresentação - aperte enter para jogar 
    tempoNaoJogado = millis()/1000; // armazena o tempo fora do jogo 
    Reset(); 
    startMenu(); // elementos da tela inicial
  }
}


// FUNÇÕES 
// PERSONAGENS 
public void Dino(){ // desenha o personagem principal e define sua posição
  if(AnimationCycle() >= animDinoWalkSpeed/2 && grounded && !fall){ // animação keyframe 1 (walk)
    image(img_dino, dinoX, dinoY, 50, 50);  //img x y w h
    //println("Passo 1"); 
  }else if(AnimationCycle() < animDinoWalkSpeed/2 && grounded && !fall){ // animação keyframe 2 (walk)
    image(img_dinoWalk, dinoX, (height/2)+dinoYIncrease, 50, 50);  //img x y w h
    //println("Passo 2");
  }
  
  if(dinoY > startY){ // controle da posição vertical do dino
    dinoYIncrease = 10; // reposiciona o dino pra cima se estiver abaixo da medida 
  }else if(dinoY < startY){ // verifica se o dino está acima do chão 
    fall = true; // armazena o valor de verdadeiro para dino caindo
    if(deltaY > maxJump){
      deltaY--; 
    }
    //fallSpeed = fallSpeed + (log(pow(sqrt(deltaY), 2))/log(10)); 
    dinoYIncrease = dinoYIncrease + (fallSpeed+(score/20)); // decrementa a medida vertical se estiver acima (gravidade) na medida do tempo de jogo
    image(img_dinoJump, dinoX, (height/2)+dinoYIncrease, 60, 60);  //img x y w h // animação key3 (fall)
  }else{
    fall = false; // armazena o valor de falso para dino caindo
  }
  
  if(!grounded){ // incrementa o Y do dino enquanto estiver pulando 
    if(dinoYIncrease > maxJump){ // verifica se o incremento em Y ultrapassou o máximo de pulo do dino
      image(img_dinoJump, dinoX, (height/2)+dinoYIncrease, 60, 60);  //img x y w h // animação key3 (pulo)
      dinoYIncrease = dinoYIncrease - (jumpSpeed+(score/10)); // faz o incremento negativo no eixo Y para o pulo na medida do tempo de jogo
    }else{
      grounded = true; // registra como verdadeiro o dino estar no chão 
    }
  }
}
public void Bird(){ // desenha o personagem pássaro e define sua posição

  //if(AnimationCycle(animBirdFlySpeed)){ // animação keyframe 1 (fly) - está gerando um null pointer exception (avaliarei mas a fundo depois)
  image(img_bird, x_bird, y_bird, 50, 50);  //img x y w h
  //}else{ // animação keyframe 2 (fly)
  //  image(img_birdFly, x_bird, y_bird, 50, 50);  //img x y w h
  //} 
  
  //if(x_bird < -250){
  //  x_bird = 1800; 
  //}
  if(x_bird < -50*PI) { // // se a posição horizontal do pássaro for menor que -50*PI (fora da tela à esquerda)
    x_bird = 500*PI;      // reposiciona fora da tela à direita (respawn)
  } 
}
public void Cactus(){ // desenha o personagem cacto e define sua posição
  image(img_cactus, x_cactus, y_cactus, 80, 100);  //img x y w h
  if(x_cactus < -250){ // se a posição horizontal do cacto for menor que -250 (fora da tela à esquerda)
    x_cactus = 1000; // reposiciona fora da tela à direita (respawn)
  }
}

// MECÂNICAS 
boolean OnCollisionEnter(float x1, float y1, float x2, float y2, float s1, float s2){ // verifica colisão tendo como parâmetros x e y (coordenada canto superior esquerdo da img) de 2 objetos e seus s (raio)
    float distanciaMinima = (s1+s2)/2; // armazena a média do tamanho dos dois objetos como 'box collider'
    
    float y1_center = y1+s1; // centraliza o ponto da imagem 
    float x1_center = x1+s1; // centraliza o ponto da imagem 
    float y2_center = y2+s2; // centraliza o ponto da imagem 
    float x2_center = x2+s2; // centraliza o ponto da imagem 
    
    float distancia = sqrt(pow(x2_center - x1_center, 2) + pow(y2_center - y1_center, 2)); // (pitágoras)
    
    // debug
    line(x1_center, y1_center, x2_center, y2_center); // desenha uma linha entre os objetos (debug)
    textSize(18); // define o tamanho do texto 
    fill(255); // define a cor do texto 
    //text(distancia, x2_center - x1_center, y2_center - y1_center); // mostra o texto de debug na posição (tá zoado)

    if (distancia <= distanciaMinima) { // Verifica se a distância é menor ou igual à distância mínima para considerar uma colisão
        return true; // Colisão detectada
    } else {
        return false; // Não há colisão
    }
}
int AnimationCycle(){ // sistema para animações (precisa melhorar para dar independência aos objetos animados - provavelmente fazendo retornar true or false relacionado com o valor passado por parâmetro...) 
  if(countFrame >= 24){ // cria um loop de frames para a animação
    countFrame = 0; // reseta o contador de frames
    lastFrame = frameCount; // registra o último frame
  }else{
    countFrame = frameCount - lastFrame; // registra o delta frame 
  }
  return countFrame; // retorbna a contagem de frames 
}
// FUNÇÕES DO PROGRAMA
boolean Start(){ // retorna a condição de vdd para o estado do jogo 
  if(gamming){
    return true; 
  }else{
    return false;
  }
}
void Reset(){ // reinicia o jogo 
  dinoX = 100; // posição horizontal inicial do dino 
  x_bird = 450*PI; // posição horizontal inicial do pássaro 
  x_cactus = 1000; // posição horizontal inicial do cacto
  
  speedBird = 5; // velocidade inicial do pássaro 
  speedCactus = 2; // velocidade inicial do cato 
  
  dinoYIncrease = 10; // variável de incremento vertical do dino (usada para o pulo)
  maxJump = -120; // valor vertical máximo do dino enquanto pula 
  jumpSpeed = 4; // velocidade de subida do pulo do dino 
  fallSpeed = 2; // velocidade de queda do pulo do dino 
}
void keyPressed(){ // aperte qualquer tecla para pular
  gamming = true; 
  if(canJump){ // verifica de o dino pode pular 
    lastTime = millis(); // registra no tempo atual 
    delta = 0;  // reseta o delta tempo
    grounded = false; // registra que o dino não está no chão
  }
}
// INTERFACE DE USUÁRIO 
void inGame(){ // desenha os elementos estáticos do jogo 
  background(0); // redefine a cor do background 
  
  stroke(255); // define a cor de contorno  
  
  fill(255); // define a cor do texto 
  textSize(16); // define o tamanho do texto 
  score = (millis()/1000) - tempoNaoJogado; // armazena o score com base na passagem do tempo 
  text(score, dinoX+25, dinoY-10); // mostra o score na posição da tela 
  
  stroke(150); // define o contorno 
  fill(0); // define a cor de preenchimento 
  rect(-50, height/2+50, 1000, 300); // desenha um quadrado na parte inferior da tela (chão)
}
void startMenu(){
  background(0); // define a cor do background 
  
  
  drawCircle(50, radians(frameCount*10), mouseX, mouseY); // desenha uma bolinha que gira ao redor do mouse na tela de descanso 
  
  fill(255); // define a cor
  image(img_dinoLogo, 0, 200, 300, 300);  //img x y w h // logo do dino
  
  textSize(100); // define o tamanho do texto 
  fill(255); // define a cor do texto 
  text("Dino", 330, 250); // mostra o texto na posição da tela 
  textSize(50); // define o tamanho do texto 
  fill(255); // define a cor do texto 
  text("(run)", 520, 196); // mostra o texto na posição da tela 
  
  fill(255); // define a cor do texto 
  textSize(26); // define o tamanho do texto 
  text("Press any key...", 350, 450); // mostra o texto na posição da tela 
}

void drawCircle(float raio, float angulo, float xc, float yc) { // desenha um círculo que gira no meio da tela de descanso 
    float x = raio * cos(angulo) + xc; // equação paramétrica X
    float y = raio * sin(angulo) + yc; // equação paramétrica Y
    fill(255, 255, 255, 150); // define a cor
    ellipse(x, y, 20, 20); // desenha o círculo
}
