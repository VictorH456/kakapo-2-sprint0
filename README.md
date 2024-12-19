---

# Projeto2-VictorC-RyanK-IgorP_UFRR_2024

<br />  
<p align="center">
  <a href="">
    <img src="https://user-images.githubusercontent.com/49700354/114078715-a61b2f00-987f-11eb-8eef-6fd7cfc17d33.png" alt="" width="80" height="80">
    <img src="https://github.com/VictorH456/MIC014Aula2-VictorC-RyanK-IgorP_UFRR_2024/blob/main/imagens/maloca.png" alt="" width="80" height="80">
    <img src="https://github.com/VictorH456/MIC014Aula2-VictorC-RyanK-IgorP_UFRR_2024/blob/main/imagens/dcc.png" alt="" width="80" height="80">
  </a>
  <h1 align="center">Aplicativo de Lembretes de Saúde</h1>
  <p align="center">
    <img src="https://github.com/VictorH456/kakapo-2-sprint0/blob/main/Imagens/logo.jpeg">

## 1. Aplicativo para Lembretes de Medicamentos e Consultas

O projeto a ser desenvolvido consiste na criação de um **aplicativo móvel** para lembretes de **medicação** e **consultas médicas**, voltado especialmente para **idosos**, **pessoas com Alzheimer**, **imigrantes**, e qualquer pessoa que precise de um sistema de lembretes intuitivo. O aplicativo ajudará os usuários a se lembrarem de tomar seus medicamentos na dosagem correta, na hora certa, e de suas consultas pendentes.

Além do aplicativo, o projeto inclui a implementação de uma **caixa de remédios inteligente** que monitora o consumo de medicamentos do paciente, integrando com o aplicativo para fornecer um sistema de lembretes mais eficaz e garantir que os medicamentos sejam tomados conforme prescrito. A caixa de remédios inteligente será capaz de **detectar a abertura de compartimentos**, **monitorar o consumo de medicamentos** e enviar essa informação em tempo real para o aplicativo.

O sistema será composto por funcionalidades simples e acessíveis, com uma interface amigável e fácil de usar. O aplicativo permitirá que os usuários configurem lembretes de medicação, indicando o nome do remédio, a dosagem e a frequência. Além disso, incluirá um sistema para lembrar sobre consultas médicas pendentes.

O desenvolvimento será realizado utilizando uma plataforma de desenvolvimento de aplicativos móveis, como **Flutter** ou **React Native**, e integrará notificações para garantir que os lembretes sejam entregues no momento adequado. A caixa de remédios inteligente será alimentada por sensores IoT que monitoram e notificam o consumo de medicamentos, ajudando a garantir a adesão ao tratamento.

### 1.1 Objetivos:
- Criar um aplicativo para lembrar de medicação, dosagem, horários e consultas médicas.
- Desenvolver uma interface simples e intuitiva, especialmente voltada para idosos, pessoas com Alzheimer e imigrantes.
- Permitir configurações de lembretes customizados (hora, dosagem, nome do medicamento).
- Fornecer uma maneira de registrar consultas médicas e lembrar os usuários de sua programação.
- Explorar o uso de tecnologias móveis para melhorar a qualidade de vida e o cuidado de pessoas com necessidades especiais.
- Integrar uma **caixa de remédios inteligente** que monitore o consumo de medicamentos e forneça dados em tempo real sobre a adesão ao tratamento.
- Alertar os usuários quando a medicação não foi retirada, evitando esquecimento ou falhas no tratamento.

## 2. Funcionalidades do Aplicativo:
- **Lembrete de Medicamentos**: O usuário pode cadastrar os medicamentos, indicar a dosagem e a frequência, e o aplicativo enviará notificações conforme os horários estabelecidos.
- **Lembrete de Consultas Médicas**: O aplicativo permite que o usuário registre suas consultas médicas e configure alertas para lembrar antes da consulta.
- **Integração com Caixa de Remédios Inteligente**: O aplicativo receberá dados da caixa inteligente para verificar se o medicamento foi retirado corretamente e se o paciente está seguindo a dosagem correta.
- **Monitoramento de Consumo**: A caixa inteligente detecta a abertura dos compartimentos e monitora o consumo de medicamentos, enviando essas informações para o aplicativo. Isso ajuda a garantir que o paciente tome os remédios conforme indicado.
- **Interface Amigável**: Design simples com grandes ícones e textos legíveis, adequado para idosos e pessoas com dificuldade de navegação em aplicativos complexos.
- **Multilíngue**: O aplicativo será traduzido para várias línguas, atendendo imigrantes e pessoas de diferentes nacionalidades.
- **Notificações**: O sistema de notificações será a principal ferramenta para garantir que os lembretes sejam recebidos de maneira pontual.

## 3. Caixa de Remédios Inteligente:

A **caixa de remédios inteligente** será equipada com **sensores IoT** que monitoram a abertura de cada compartimento de medicamento. Quando o paciente abrir o compartimento para retirar o remédio, a caixa enviará uma notificação para o aplicativo, informando que o medicamento foi retirado. Caso o paciente se esqueça de tomar o remédio ou não abra o compartimento no horário adequado, o aplicativo enviará um lembrete adicional. 

- **Sensores de Abertura de Compartimentos**: Utilização de sensores magnéticos ou de contato, como **sensores de proximidade (PIR)** ou **interruptores de pressão** para detectar quando os compartimentos da caixa são abertos.
- **Conectividade IoT**: O uso de um microcontrolador com conectividade Bluetooth ou Wi-Fi (como **ESP32** ou **nRF52832**) para se comunicar com o aplicativo.
- **Notificações em Tempo Real**: O aplicativo receberá as atualizações em tempo real sobre o consumo dos medicamentos.

## 4. Tecnologias Utilizadas:
- **Desenvolvimento do Aplicativo**: O aplicativo será desenvolvido utilizando **Flutter** ou **React Native** para garantir compatibilidade com dispositivos Android e iOS.
- **Sensores IoT**: A caixa inteligente usará **sensores de abertura** (como sensores magnéticos ou infravermelhos) conectados a um microcontrolador que envia dados para o aplicativo via Bluetooth ou Wi-Fi.
- **Microcontroladores**: O microcontrolador da caixa inteligente será um **ESP32** ou **nRF52832**, que são compatíveis com sensores IoT e têm boa eficiência energética.
- **Plataformas de Notificação**: As notificações serão enviadas utilizando plataformas como **Firebase Cloud Messaging** para garantir que os lembretes sejam recebidos no momento certo.
  
