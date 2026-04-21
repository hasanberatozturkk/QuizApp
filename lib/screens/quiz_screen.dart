import 'package:flutter/material.dart';
import '../screens/result_screen.dart';
import 'dart:async';
import '../screens/start_screen.dart';
import '../data/database_helper.dart';
import '../data/database_loader.dart';
import 'dart:convert';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DatabaseLoader.loadDataIfEmpty();
  runApp(QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: MenuScreen());
  }
}

class QuizAppState extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const QuizAppState({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<QuizAppState> createState() => QuizAppStateHome();
}

class QuizAppStateHome extends State<QuizAppState> {
  Timer? timer;
  int remainingTime = 15;
  int score = 0;
  int questionIndex = 0;
  bool isAnswered = false;
  List<Map<String, Object>> questions = [];
  bool isLoading = true;

  static final categoryMap = {
    'Spor': 1,
    'Tarih': 2,
    'Bilim': 3,
    'Sanat': 4,
    'Genel Kültür': 5,
    'Coğrafya': 6,
    'Sinema': 7,
    'Din Kültürü': 8,
    'Karışık': 9,
  };
  // DB'den soruları çekme
  Future<void> loadQuestions() async {
    final questions = await DatabaseHelper.instance.getQuestionsByCategory(
      widget.categoryId,
      limit: 12,
    );
    final mapped = questions.map((question) {
      final options = (jsonDecode(question.options) as List)
          .map((option) => option.toString())
          .toList();
      options.shuffle();
      return <String, Object>{
        'question': question.question,
        'answer': question.correctAnswer,
        'options': options,
      };
    }).toList();

    if (!mounted) return;

    setState(() {
      this.questions = mapped.cast<Map<String, Object>>();
      questionIndex = 0;
      isAnswered = false;
      score = 0;
      isLoading = false;
    });
    if (questions.isNotEmpty) {
      startTimer();
    }
  }

  void startTimer() {
    timer?.cancel();
    remainingTime = 15;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        return;
      }
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          timer.cancel();
          nextQuestion('');
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void nextQuestion(String selectedOption) {
    if (isAnswered) {
      return;
    }
    setState(() {
      isAnswered = true;
      if (selectedOption.toString().trim() ==
          questions[questionIndex]['answer'].toString().trim()) {
        score++;
      }
    });

    timer?.cancel();

    Future.delayed(const Duration(milliseconds: 1200), () {
      setState(() {
        if (questionIndex < questions.length - 1) {
          questionIndex++;
          isAnswered = false;
          startTimer();
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ResultScreen(score: score, totalQuestions: questions.length),
            ),
          ).then((_) => loadQuestions());
        }
      });
    });
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: false,
      backgroundColor: const Color.fromARGB(255, 56, 157, 240),
      title: const Text(
        'Bil Bakalım',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.white,
          letterSpacing: 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // burası yüklenirken gösterilen ekran
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.blue[100],
        appBar: _buildAppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // burası soru bulunamadığında gösterilen ekran
    if (questions.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.blue[100],
        appBar: _buildAppBar(),
        body: const Center(
          child: Text(
            'Bu kategori için soru bulunamadı.',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    final currentQuestion = questions[questionIndex];

    // burası ise soru gösterilirken gösterilen ekran
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: const Color.fromARGB(255, 56, 157, 240),
        title: const Text(
          'Bil Bakalım',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.timer, size: 30, color: Colors.orange[800]),
                const SizedBox(width: 10),
                Text(
                  'Kalan Süre: $remainingTime saniye',
                  style: TextStyle(
                    fontSize: 16,
                    color: remainingTime <= 5
                        ? const Color.fromARGB(255, 161, 28, 19)
                        : Colors.orange[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 50),
            const Text(
              'Bilgi Yarışmasına Hoşgeldiniz!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              "Soru : ${questionIndex + 1} / ${questions.length}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              currentQuestion['question'] as String,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.blueAccent.withAlpha(45)),
                ),
                child: Column(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final option
                            in currentQuestion['options'] as List<String>)
                          Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            child: ElevatedButton(
                              onPressed: isAnswered
                                  ? null
                                  : () => nextQuestion(option),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isAnswered
                                    ? (option.toString().trim() ==
                                              currentQuestion['answer']
                                                  .toString()
                                                  .trim()
                                          ? Colors.green
                                          : Colors.red)
                                    : const Color.fromARGB(255, 56, 157, 240),
                                padding: const EdgeInsets.all(15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Text(
                                option,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
