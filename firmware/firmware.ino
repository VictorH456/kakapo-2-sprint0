#include <WiFi.h>

#include <Firebase_ESP_Client.h>
#indclude "addons/TokenHelper.h"

#define NOME_WIFI "SSID-WIFI"
#define SENHA_WIFI "WIFI-SENHA"

#define PROJETO_ID "PROJECT-ID"
#define CHAVE_API "FIREBASE-API-KEY"
#define URL_BANCO "DATABASE-URL"

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

const int BOTAO = 32;

void conectarWifi() {
  WiFi.begin(NOME_WIFI, SENHA_WIFI);
  
  Serial.print("Connecting to WiFi ..");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print('.');
    delay(1000);
  }
  Serial.print(' ');
  Serial.println(WiFi.localIP());
  Serial.println();
}

void conectarFirebase() {
  config.api_key = CHAVE_API;
  config.database_url = URL_BANCO;

  Serial.print("Fazendo login no Firebase: ");
  
  if (Firebase.signUp(&config,&auth,"","")) {
    Serial.println("SUCESSO");
    
  } else {
    Serial.printf("ERRO\n%s\n", config.signer.signupError.message.c_str());
    while(true) {}
  }
  
  config.token_status_callback = tokenStatusCallback;
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
}

void setup() {
  Serial.begin(115200);

  conectarWifi();
  conectarFirebase();

  pinMode(BOTAO, INPUT_PULLUP);
}

const bool ABERTO = true;
const bool FECHADO = false;

bool detectou_abertura() {
  static bool ultimo_estado = FECHADO;

  bool estado_atual = digitalRead(BOTAO) == LOW? ABERTO : FECHADO;  
  bool caixa_abriu = ultimo_estado == FECHADO && estado_atual == ABERTO;
  
  ultimo_estado = estado_atual;

  if (caixa_abriu) {
    while (digitalRead(BOTAO) == LOW);
  }
  
  return caixa_abriu;
}

void registra_consumo(String nome_remedio) {
  static FirebaseJson json;
  
  Serial.println("Registrando consumo...");
  
  const String caminho_base = "usuario";

  json.set("nome", nome_remedio.c_str());
  json.set("data/.sv", "timestamp");
  
  if (Firebase.RTDB.pushJSON(&fbdo, caminho_base + "/medicamento", &json)) {
    Serial.println(String("SUCESSO: ") + fbdo.to<FirebaseJson>().raw());
  } else {
    Serial.println(String("ERRO: ") + fbdo.errorReason());
  }
}

void loop() {   
  if (detectou_abertura()) {
    registra_consumo("Metamizol");
  }
}
