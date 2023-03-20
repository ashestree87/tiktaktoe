import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TicTacToe(),
    );
  }
}

class TicTacToe extends StatefulWidget {
  @override
  _TicTacToeState createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  late List<List<String>> board;
  late bool player1Turn;
  late String winner;
  late String currentPlayer;

  @override
  void initState() {
    super.initState();
    board = List.generate(3, (_) => List.filled(3, ''));
    player1Turn = true;
    winner = '';
    currentPlayer = 'X';
  }

  void markBox(int row, int col) {
    if (board[row][col] == '') {
      setState(() {
        board[row][col] = player1Turn ? 'X' : 'O';
        player1Turn = !player1Turn;
        currentPlayer = player1Turn ? 'X' : 'O';
        checkWinner();
      });
    }
  }

  void checkWinner() {
    for (int i = 0; i < 3; i++) {
      if (board[i][0] != '' &&
          board[i][0] == board[i][1] &&
          board[i][1] == board[i][2]) {
        setState(() {
          winner = '${board[i][0]} wins!';
        });
        showWinnerDialog();
        return;
      }
      if (board[0][i] != '' &&
          board[0][i] == board[1][i] &&
          board[1][i] == board[2][i]) {
        setState(() {
          winner = '${board[0][i]} wins!';
        });
        showWinnerDialog();
        return;
      }
    }
    if (board[0][0] != '' &&
        board[0][0] == board[1][1] &&
        board[1][1] == board[2][2]) {
      setState(() {
        winner = '${board[0][0]} wins!';
      });
      showWinnerDialog();
      return;
    }
    if (board[0][2] != '' &&
        board[0][2] == board[1][1] &&
        board[1][1] == board[2][0]) {
      setState(() {
        winner = '${board[0][2]} wins!';
      });
      showWinnerDialog();
      return;
    }
    if (board.every((row) => row.every((col) => col != ''))) {
      setState(() {
        winner = 'Draw!';
      });
      showWinnerDialog();
    }
  }

  void showWinnerDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(winner),
      ),
    );
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        board = List.generate(3, (_) => List.filled(3, ''));
        player1Turn = true;
        currentPlayer = 'X';
        winner = '';
      });
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 9, 24),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$currentPlayer turn to go',
              style: const TextStyle(fontSize: 24, color: Colors.white),
            ),
            AspectRatio(
              aspectRatio: 1.0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: 9,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemBuilder: (context, index) {
                    final row = index ~/ 3;
                    final col = index % 3;
                    return InkWell(
                      onTap: winner == '' ? () => markBox(row, col) : null,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Center(
                          child: Text(
                            board[row][col],
                            style: const TextStyle(
                                fontSize: 48, color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
