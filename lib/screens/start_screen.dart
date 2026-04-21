import 'package:flutter/material.dart';
import '../screens/quiz_screen.dart';
import 'package:flutter/services.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 56, 157, 240),
        centerTitle: false,
        title: Text(
          'Quiz Uygulaması',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            style: IconButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              final result = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Çıkış'),
                  content: Text('Çıkış yapmak istediğinize emin misiniz?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Hayır'),
                    ),
                  ],
                ),
              );
              if (result == true) {
                SystemNavigator.pop();
              }
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 3, 101, 182),
              Color.fromARGB(255, 65, 165, 247),
            ],
          ),
        ),
        child: Column(
          children: [
            Icon(Icons.quiz, size: 100),
            SizedBox(height: 20),
            Text(
              'Bir Kategori Seçiniz',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: 40),
            Expanded(
              child: Scrollbar(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      categoryButton(
                        context,
                        'Spor',
                        Icons.sports_soccer,
                        Colors.green,
                      ),
                      categoryButton(
                        context,
                        'Tarih',
                        Icons.history_edu,
                        Colors.orange,
                      ),
                      categoryButton(
                        context,
                        'Bilim',
                        Icons.science,
                        Colors.purple,
                      ),
                      categoryButton(
                        context,
                        'Sanat',
                        Icons.palette,
                        Colors.pink,
                      ),
                      categoryButton(
                        context,
                        'Genel Kültür',
                        Icons.language,
                        Colors.blue,
                      ),
                      categoryButton(
                        context,
                        'Coğrafya',
                        Icons.location_on,
                        Colors.red,
                      ),
                      categoryButton(
                        context,
                        'Sinema',
                        Icons.movie,
                        Colors.teal,
                      ),
                      categoryButton(
                        context,
                        'Din Kültürü',
                        Icons.mosque,
                        Colors.brown,
                      ),
                      categoryButton(
                        context,
                        'Karışık',
                        Icons.shuffle,
                        Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget categoryButton(
  BuildContext context,
  String title,
  IconData icon,
  Color color,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
    child: Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: color,
          minimumSize: const Size(double.infinity, 60),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizAppState(
                categoryId: QuizAppStateHome.categoryMap[title]!,
                categoryName: title,
              ),
            ),
          );
        },
        child: Row(
          children: [
            Icon(icon, size: 30),
            SizedBox(width: 20),
            Text(
              title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ),
  );
}
