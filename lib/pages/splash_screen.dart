import 'package:flutter/material.dart';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isLoading = false;

  void _onStartPressed() {
    setState(() {
      _isLoading = true;
    });
    
    // Navegar para a página inicial após mostrar o loading por 1.5 segundos
    Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // Verificar o tema atual (claro ou escuro)
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final backgroundColor = Theme.of(context).colorScheme.background;
    
    // Cores adaptativas para o gradiente
    final topGradientColor = isDarkMode 
        ? primaryColor.withOpacity(0.2) 
        : const Color(0xFFEDE7F6);
    final bottomGradientColor = isDarkMode 
        ? backgroundColor.withOpacity(0.9) 
        : const Color(0xFFD1C4E9);
    
    // Cor do texto adaptativa
    final textColor = isDarkMode 
        ? primaryColor 
        : const Color(0xFF6A3DE8);
    
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              topGradientColor,
              bottomGradientColor,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Imagem de capa centralizada
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Image.asset(
                  'imagens/imagem_home.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // Nome do app, botão e/ou animação
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text(
                    'Diário de Emoções',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  _isLoading 
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    )
                  : ElevatedButton(
                      onPressed: _onStartPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: isDarkMode ? Colors.black : Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Começar',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 