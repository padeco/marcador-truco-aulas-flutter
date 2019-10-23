import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:marcador_truco/models/player.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _playerOne = Player(name: "Nós", score: 0, victories: 0);
  var _playerTwo = Player(name: "Eles", score: 0, victories: 0);



  @override
  void initState() {
    super.initState();
    _resetPlayers();
  }

  void _resetPlayer({Player player, bool resetVictories = true}) {
    setState(() {
      player.score = 0;
      if (resetVictories) player.victories = 0;
    });
  }

  void _resetPlayers({bool resetVictories = true}) {
    _resetPlayer(player: _playerOne, resetVictories: resetVictories);
    _resetPlayer(player: _playerTwo, resetVictories: resetVictories);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text("Marcador Pontos (Truco!)"),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              _showDialog(
                  title: 'Zerar',
                  message:
                      'Deseja recomeçar um(a)?',
                  confirm: () {
                    _resetPlayers(resetVictories: true);
                    _playerOne = Player(name: "Nós", score: 0, victories: 0);
                    _playerTwo = Player(name: "Eles", score: 0, victories: 0);
                  },
                  match: () {
                    _resetPlayers(resetVictories: false);
                  });
            },
            icon: Icon(Icons.refresh),
          )
        ],
      ),
      body: Container(padding: EdgeInsets.all(20.0), child: _showPlayers()),
    );
  }

  TextEditingController _name = TextEditingController();


  void _resetFields() {
    _name.text = '';
  }



  Widget _editPlayerName(Player player){
    return GestureDetector(
      onTap: (){ 
        showDialog(context: context,
            builder: (context){
              return AlertDialog(title: Text("Alterar nome"),
                  content: TextField(controller: _name,
                  decoration: InputDecoration(hintText: "Novo nome")),
                  actions: <Widget>[FlatButton(child: Text("Cancelar"),
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                  ),
                    FlatButton(child: Text("Ok"),
                        onPressed: (){
                          setState((){
                            player.name = _name.text;
                            Navigator.of(context).pop();
                            if (_playerOne.name == '' && _name.text == ''){
                              player.name= "Nós";
                            }
                            if (_playerTwo.name == '' && _name.text == ''){
                              player.name= "eles";
                            }
                            _resetFields();
                          });
                        }
                    )
                  ]
              );
            }
        );
      },
      child: Container(
          child: _showPlayerName(player.name)
      ),
    );
  }


  Widget _showPlayerBoard(Player player) {
    return Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _editPlayerName(player),
          _showPlayerScore(player.score),
          _showPlayerVictories(player.victories),
          _showScoreButtons(player),
        ],
      ),
    );
  }

  Widget _showPlayers() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _showPlayerBoard(_playerOne),
        _showPlayerBoard(_playerTwo),
      ],
    );
  }

  Widget _showPlayerName(String name) {
    return Text(
      name.toUpperCase(),
      style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
          color: Colors.indigoAccent),
    );
  }

  Widget _showPlayerVictories(int victories) {
    return Text(
      "vitórias ( $victories )",
      style: TextStyle(fontWeight: FontWeight.w300),
    );
  }

  Widget _showPlayerScore(int score) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 52.0),
      child: Text(
        "$score",
        style: TextStyle(fontSize: 120.0),
      ),
    );
  }

  Widget _buildRoundedButton(
      {String text, double size = 52.0, Color color, Function onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: ClipOval(
        child: Container(
          color: color,
          height: size,
          width: size,
          child: Center(
              child: Text(
            text,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          )),
        ),
      ),
    );
  }

  Widget _showScoreButtons(Player player) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _buildRoundedButton(
          text: '-1',
          color: Colors.black.withOpacity(0.1),
          onTap: () {
            if (player.score > 0)
              setState(() {
                player.score--;
              });
          },
        ),
        _buildRoundedButton(
          text: '+1',
          color: Colors.indigoAccent,
          onTap: () {
            if (player.score < 12)
              setState(() {
                player.score++;
              });

              if (_playerOne.score == 11 && _playerTwo.score == 11){
                _showIronhand(
                  title: 'Mão de Ferro.',
                  message: 'que vença o melhor!'
                );
              }

            if (player.score == 12) {
              _showDialog(
                  title: 'Fim do jogo',
                  message: '${player.name} ganhou!',
                  match: () {
                    setState(() {
                      player.victories++;
                    });

                    _resetPlayers(resetVictories: false);
                  },
                  confirm: () {
                    _resetPlayers(resetVictories: true);
                  },
                  cancel: () {
                    setState(() {
                      player.score--;
                    });
                  });
            }
          },
        ),
        _buildRoundedButton(
          text: '+3',
          color: Colors.black.withOpacity(0.5),
          onTap: () {
            if (player.score < 12)
              setState(() {
                player.score=player.score+3;
              });

            if (_playerOne.score == 11 && _playerTwo.score == 11){
              _showIronhand(
                  title: 'Mão de Ferro.',
                  message: 'que vença o melhor!'
              );
            }

            if (player.score >= 12) {
              _showDialog(
                  title: 'Fim do jogo',
                  message: '${player.name} ganhou!',
                  match: () {
                    setState(() {
                      player.victories++;
                    });

                    _resetPlayers(resetVictories: false);
                  },
                  confirm: () {
                    _resetPlayers(resetVictories: true);
                  },
                  cancel: () {
                    setState(() {
                      player.score--;
                      if (player.score >= 12){
                        player.score = 11;
                      }
                    });
                  });
            }
          },
        ),
      ],
    );
  }

  void _showIronhand({
    String title,
    String message,
    Function confirm,
  }) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                  if (confirm != null) confirm();
                },
              ),
            ],
          );
        },
      );
  }

  void _showDialog(
      {String title,
      String message,
      Function confirm,
      Function cancel,
      Function match}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text("CANCEL"),
              onPressed: () {
                Navigator.of(context).pop();
                if (cancel != null) cancel();
              },
            ),
            FlatButton(
              child: Text("NOVO JOGO"),
              onPressed: () {
                Navigator.of(context).pop();
                if (confirm != null) confirm();
              },
            ),
            FlatButton(
              child: Text("NOVA PARTIDA"),
              onPressed: () {
                Navigator.of(context).pop();
                if (match != null) match();
              },
            ),
          ],
        );
      },
    );
  }
}
