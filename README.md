# Diário de Emoções

Um aplicativo móvel elegante para registrar e acompanhar seu humor diariamente. Visualize a frequência de suas emoções através de gráficos de barras interativos e mantenha um histórico completo dos seus registros.

## 📱 Capturas de Tela

<div style="display: flex; flex-direction: row; flex-wrap: wrap; justify-content: center; gap: 10px;">
  <img src="screenshots/Captura de tela 2025-04-22 203835.png" alt="Tela de Abertura" width="300"/>
  <img src="screenshots/Captura de tela 2025-04-18 123558.png" alt="Tela de Gráfico" width="300"/>
  <img src="screenshots/Captura de tela 2025-04-18 123606.png" alt="Tela de Histórico" width="300"/>
  <img src="screenshots/Captura de tela 2025-04-18 123217.png" alt="Tela de Registro" width="300"/>
  <img src="screenshots/Captura de tela 2025-04-18 123614.png" alt="Tema Escuro" width="300"/>
</div>

## ✨ Funcionalidades

- Tela de abertura elegante que se adapta ao tema do dispositivo (claro/escuro)
- Seleção intuitiva de emoções com 5 opções (de Péssimo a Excelente)
- Visualização estatística em gráfico de barras mostrando a quantidade de cada emoção registrada
- Histórico completo de registros de humor com emojis correspondentes
- Interface moderna e intuitiva com seleção direta de emoções
- Funciona offline (armazenamento local com Hive)
- Suporte para temas claro e escuro
- Design responsivo para diferentes tamanhos de tela

## 🛠️ Tecnologias Utilizadas

- **Flutter**: Framework para desenvolvimento multiplataforma
- **Hive**: Banco de dados NoSQL leve para armazenamento local
- **fl_chart**: Biblioteca para criação de gráficos interativos
- **Google Fonts**: Tipografia personalizada
- **Material Design 3**: Padrões modernos de interface

## ⚙️ Instalação

### Pré-requisitos

- Flutter SDK (versão 3.7.0 ou superior)
- Dart SDK
- Android Studio / VS Code
- Git

### Passo a passo

1. Clone o repositório:
   ```bash
   git clone https://github.com/seu-usuario/app_diario_emocoes.git
   cd app_diario_emocoes
   ```

2. Instale as dependências:
   ```bash
   flutter pub get
   ```

3. Gere os arquivos necessários para o Hive:
   ```bash
   flutter pub run build_runner build
   ```

4. Execute o aplicativo:
   ```bash
   flutter run
   ```

## 📚 Arquitetura do Projeto

```
lib/
├── models/          # Modelos de dados
│   ├── splash_screen.dart   # Tela de abertura
│   ├── home_page.dart       # Tela principal (gráfico/histórico)
│   └── add_mood_page.dart   # Tela de registro de emoção
├── services/        # Serviços para manipulação de dados
├── widgets/         # Componentes reutilizáveis
└── main.dart        # Ponto de entrada do aplicativo
```

## 🔄 Fluxo de Dados

1. O usuário inicia o aplicativo e é recebido pela tela de abertura
2. Ao tocar em "Começar", o aplicativo navega para a tela principal
3. Os dados de humor são inseridos pelo usuário na tela de registro
4. As entradas são armazenadas localmente usando o Hive
5. Os dados são recuperados e exibidos em formato de gráfico de barras e lista

## 📝 Como Usar

1. Abra o aplicativo e toque no botão "Começar" na tela de abertura
2. Navegue entre as abas "Gráfico" e "Histórico" para visualizar seus registros
3. Toque no botão de "+" para registrar seu humor atual
4. Selecione a emoção desejada entre as opções disponíveis
5. Toque em "Salvar Emoção" para salvar o registro
6. Visualize a frequência de suas emoções no gráfico de barras ou todo o histórico na aba "Histórico"

## 🤝 Contribuições

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues e pull requests.

## 📄 Licença

Este projeto está licenciado sob a [MIT License](LICENSE).
