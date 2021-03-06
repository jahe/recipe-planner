import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.cyan,
      ),
      home: MyHomePage(title: 'Recipe Planner'),
    );
  }
}

class RecipeThumbnail extends StatelessWidget {
  RecipeThumbnail({Key key, this.recipe}) : super(key: key);

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Ink.image(
      image: NetworkImage(recipe.imageUrl),
      fit: BoxFit.cover,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => RecipePage(recipe: recipe)));
        },
      ),
    );
  }
}

class Recipe {
  Recipe({this.imageUrl, this.name});

  final String imageUrl, name;
}

class NewRecipePage extends StatelessWidget {
  NewRecipePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("New Recipe"),
        ),
        body: NewRecipeForm());
  }
}

// Define a Custom Form Widget
class NewRecipeForm extends StatefulWidget {
  @override
  NewRecipeFormState createState() {
    return NewRecipeFormState();
  }
}

// Define a corresponding State class. This class will hold the data related to
// the form.
class NewRecipeFormState extends State<NewRecipeForm> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a `GlobalKey<FormState>`, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above
    return Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a name for the Recipe';
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: () async {
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (_formKey.currentState.validate()) {
                      // obtain shared preferences
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setInt('recipes', counter);






                      // If the form is valid, we want to show a Snackbar
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Processing Data')));
                    }
                  },
                  child: Text('Save Recipe'),
                ),
              ),
            ],
          ),
        ));
  }
}

class RecipePage extends StatelessWidget {
  RecipePage({Key key, @required this.recipe}) : super(key: key);

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(recipe.name),
        ),
        body: Column(
          children: <Widget>[Image.network(recipe.imageUrl)],
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _addNewRecipe() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => NewRecipePage()));

    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: GridView.extent(
        maxCrossAxisExtent: 200,
        padding: EdgeInsets.all(20),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        children: <Widget>[
          RecipeThumbnail(
              recipe: Recipe(
                  imageUrl:
                      "https://www.petazwei.de/mediadb/cache/1440x650/2015-10-04-Spaghetti-Bolognese-01-c-PETA-D.JPG",
                  name: "Bolo")),
          RecipeThumbnail(
              recipe: Recipe(
                  imageUrl:
                      "https://www.veganblatt.com/i/lasagne2-1-1024x640.jpg",
                  name: "Lasagne"))
//          Text(
//            'You have pushed the button this many times:',
//          ),
//          Text(
//            '$_counter',
//            style: Theme.of(context).textTheme.display1,
//          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _addNewRecipe,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
