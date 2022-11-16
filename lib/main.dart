import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(const MyApp()); //Inflate the given widget and attach it to the screen
  //const - the object is frozen and completely immutable
}

class MyApp extends StatelessWidget {
  //extend - share properties and methods between classes; Stateless Widget: doesn't change
  const MyApp({super.key});

  //override - override superclass's (StatelessWidget's) "Widget" method
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //Return a MaterialApp Widget with title and home properties as defined
      title: 'Startup Name Generator',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.blue,
        ),
      ),
      home: const RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  //StatefulWidget - a widget that has a mutable state
  const RandomWords({Key? key}) : super(key: key);

  @override //override StatefulWidget's "createState()" method
  State<RandomWords> createState() =>
      _RandomWordsState(); //=> execute the code to the right and return it's value
//_RandomWordsState = RandomWords' "State". RandomWords is a StatefulWidget that can change and _RandomWordsState is it's State
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[]; //A string array of word pairs
  final _saved = <WordPair>{};
  final _biggerFont =
      const TextStyle(fontSize: 18); //Text style to define font size

  //Override State's Widget method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // NEW from here ...
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
            tooltip: 'Saved Suggestions',
          ),
        ],
      ),
      body: ListView.builder(
        //returning a ListView with properties as defined below
        padding: const EdgeInsets.all(16.0),
        //itemBuilder - builds the style of the list's rows (i.e. tiles) (i)
        itemBuilder: (context, i) {
          //Return a divider if the index is odd, otherwise we'll return a ListTile
          if (i.isOdd) return const Divider(color: Colors.red);

          final index = i ~/
              2; //This gives the index of the wordpairs (minus the divider widgets)
          //Generate some more wordpairs if the index of the list we are looking at is greater than the length of the array holding the word pairs
          if (index >= _suggestions.length) {
            //generateWordPairs is a method in the English Words library
            _suggestions.addAll(generateWordPairs()
                .take(10)); //.take(10) means were generating 10 word pairs
          }

          final alreadySaved = _saved.contains(_suggestions[index]); //boolean

          //Return ListTile with the following properties
          return ListTile(
            title: Text(
              _suggestions[index].asPascalCase,
              style: _biggerFont,
            ),
            trailing: Icon(
              alreadySaved
                  ? Icons.favorite
                  : Icons.favorite_border, //? indicates conditional statement
              color: alreadySaved ? Colors.red : null,
              semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
            ),
            onTap: () {
              setState(() {
                if (alreadySaved) {
                  _saved.remove(_suggestions[index]);
                } else {
                  _saved.add(_suggestions[index]);
                }
              });
            },
          );
        },
      ),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {

          final tiles = _saved.map(
            (pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          //--------
          //Tiles hold the saved names - if 'tiles' is not empty, add a border
          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
                  context: context,
                  tiles: tiles,
                ).toList()
              : <Widget>[];
          //--------
          return Scaffold(
            appBar: AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }
}
