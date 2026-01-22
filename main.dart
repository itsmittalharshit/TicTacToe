import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; 

void main() => runApp(TicTacToeApp());

class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe vs Computer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.cyanAccent,
        scaffoldBackgroundColor: Color(0xFF0F172A),
        fontFamily: 'Poppins',
      ),
      home: TicTacToePage(),
    );
  }
}

int findBestMove(List<String> newBoard) {
  int bestScore = -1000;
  int move = -1;
  for (int i = 0; i < 9; i++) {
    if (newBoard[i] == '') {
      newBoard[i] = 'O';
      int score = minimax(newBoard, 0, false);
      newBoard[i] = '';
      if (score > bestScore) {
        bestScore = score;
        move = i;
      }
    }
  }
  return move;
}


int minimax(List<String> boardState, int depth, bool isMaximizing) {
  if (checkWinner(boardState, 'O')) return 10 - depth;
  if (checkWinner(boardState, 'X')) return depth - 10;
  if (!boardState.contains('')) return 0;

  if (isMaximizing) {
    int bestScore = -1000;
    for (int i = 0; i < 9; i++) {
      if (boardState[i] == '') {
        boardState[i] = 'O';
        int score = minimax(boardState, depth + 1, false);
        boardState[i] = '';
        bestScore = score > bestScore ? score : bestScore;
      }
    }
    return bestScore;
  } else {
    int bestScore = 1000;
    for (int i = 0; i < 9; i++) {
      if (boardState[i] == '') {
        boardState[i] = 'X';
        int score = minimax(boardState, depth + 1, true);
        boardState[i] = '';
        bestScore = score < bestScore ? score : bestScore;
      }
    }
    return bestScore;
  }
}


bool checkWinner(List<String> board, String player) {
  List<List<int>> winPatterns = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];
  for (var pattern in winPatterns) {
    if (board[pattern[0]] == player &&
        board[pattern[1]] == player &&
        board[pattern[2]] == player) {
      return true;
    }
  }
  return false;
}

class TicTacToePage extends StatefulWidget {
  const TicTacToePage({super.key});
  @override
  State<TicTacToePage> createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TicTacToePage> {
  // Board state: '' = empty, 'X' = player, 'O' = computer
  List<String> board = List.filled(9, '');
  String currentPlayer = 'X';
  bool gameOver = false;
  String result = '';

  @override
  void initState() {
    super.initState();
  }

  void resetGame() {
    setState(() {
      board = List.filled(9, '');
      currentPlayer = 'X';
      gameOver = false;
      result = '';
    });
  }

  void playerMove(int index) {
    if (board[index] == '' && !gameOver) {
      setState(() {
        board[index] = 'X';
      });
      if (checkWinner(board, 'X')) {
        setState(() {
          result = 'You Win!';
          gameOver = true;
        });
        return;
      } else if (!board.contains('')) {
        setState(() {
          result = 'Draw!';
          gameOver = true;
        });
        return;
      }
      computerMove();
    }
  }



void computerMove() async {
  int bestMove = await compute(findBestMove, board);

  setState(() {
    board[bestMove] = 'O';
  });

  if (checkWinner(board, 'O')) {
    setState(() {
      result = 'Computer Wins!';
      gameOver = true;
    });
  } else if (!board.contains('')) {
    setState(() {
      result = 'Draw!';
      gameOver = true;
    });
  }
}

  Widget buildCell(int index) {
    Color glow = board[index] == 'X'
      ? Colors.blueAccent
      : board[index] == 'O'
          ? Colors.redAccent
          : Colors.white12;

    return GestureDetector(
      onTap: () => playerMove(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        margin: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: glow.withValues(alpha: 0.5),
              blurRadius: 12,
            )
          ],
        ),
        child: Center(
          child: Text(
            board[index],
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: board[index] == 'X'
                ? Colors.cyanAccent
                : Colors.pinkAccent,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Tic Tac Toe",
          style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF020617), Color(0xFF1E293B)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: GridView.builder(
                gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                itemCount: 9,
                itemBuilder: (context, index) => buildCell(index),
              ),
            ),
            SizedBox(height: 20),
            Text(
              result,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.amberAccent,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                backgroundColor: Colors.cyanAccent,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: resetGame,
              child: Text(
                'Reset Game',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
