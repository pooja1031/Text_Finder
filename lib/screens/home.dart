import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyGridSearchWidget extends StatefulWidget {
const MyGridSearchWidget({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyGridSearchWidgetState createState() => _MyGridSearchWidgetState();
}

class _MyGridSearchWidgetState extends State<MyGridSearchWidget> {
  List<List<String>> grid = [];
  TextEditingController rowsController = TextEditingController();
  TextEditingController columnsController = TextEditingController();
  TextEditingController searchTextController = TextEditingController();
  bool textFound = false;
  FocusNode rowsFocusNode = FocusNode();
  FocusNode columnsFocusNode = FocusNode();
  FocusNode searchTextFocusNode = FocusNode();
  FocusNode buttonFocusNode = FocusNode();
  FocusNode searchButtonFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      
      body: SafeArea(
        child: Material(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.04), 
              child: Focus(
                focusNode: buttonFocusNode,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    DefaultTextStyle(
              style: GoogleFonts.kalam(
fontSize: screenWidth * 0.07 ,
 fontWeight: FontWeight.w900   ,
                color: Colors.black),
              child: Padding(
                padding: const EdgeInsets.only(top: 128.0, left: 45, right: 40),
                child: AnimatedTextKit(
                    repeatForever: false,
                    totalRepeatCount: 1,
                    animatedTexts: [
                      TyperAnimatedText("Set the dimensions of the grid by entering the row and column values.",
                          speed: const Duration(milliseconds: 100))
                    ]),
              ),
            ),
                   
                    SizedBox(height: screenWidth * 0.1), 

                    Row(
                      children: [
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(left: screenWidth * 0.04),
                            child: buildTextField("Rows", rowsController, focusNode: rowsFocusNode),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.06), 
                        Flexible(
                          child: buildTextField("Columns", columnsController, focusNode: columnsFocusNode),
                        ),
                      ],
                    ),

                    SizedBox(height: screenWidth * 0.02), 

                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              createGrid();
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              minimumSize: Size(screenWidth * 0.3, screenWidth * 0.08), 
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(screenWidth * 0.02), 
                              ),
                            ),
                            child: Text(
                              'Create Grid',
                              style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.03), 
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: screenWidth * 0.1), 

                    if (grid.isNotEmpty)
                      Column(
                        children: [
                          buildTextField("Search Text", searchTextController, isNumber: false, focusNode: searchTextFocusNode),
                      
                          SizedBox(height: screenWidth * 0.02), 
                      
                          Focus(
                            focusNode: searchButtonFocusNode,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    searchInGrid();
                                    FocusManager.instance.primaryFocus?.unfocus();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    minimumSize: Size(screenWidth * 0.3, screenWidth * 0.08),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(screenWidth * 0.02), 
                                    ),
                                  ),
                                  child: Text(
                                    'Search in Grid',
                                    style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.03),
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.04), 
                              ],
                            ),
                          ),
                      
                          SizedBox(height: screenWidth * 0.02), 
                      
                          textFound
                              ? Text(
                                  'Text found in the grid!',
                                  style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.green), 
                                )
                              : Text(
                                  'Text not found in the grid.',
                                  style: TextStyle(fontSize: screenWidth * 0.04, color: Colors.red), 
                                ),
                      
                          SizedBox(height: screenWidth * 0.02), 
                      
                          buildGridDisplay(),
                      
                          SizedBox(height: screenWidth * 0.01), 
                      
                          ElevatedButton(
                            onPressed: () {
                              resetGrid();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              minimumSize: Size(screenWidth * 0.3, screenWidth * 0.08), 
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(screenWidth * 0.02), 
                              ),
                            ),
                            child: Text(
                              'Reset Grid',
                              style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.03), 
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
 Widget buildTextField(String label, TextEditingController controller, {bool isNumber = false, FocusNode? focusNode}) {
  return SizedBox(
    height: 45,
    width: 160,
    child: TextField(
      style: const TextStyle(fontSize: 18, color: Colors.black),
      controller: controller,
      focusNode: focusNode,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide:const BorderSide(color: Colors.black, width: 2.0),
        ),
      ),
      onEditingComplete: () {
        if (focusNode != null) {
          focusNode.unfocus(); 
        }
      },
    ),
  );
}



  Widget buildGridDisplay() {
    return GridView.builder(
  shrinkWrap: true,
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: grid.isNotEmpty ? grid[0].length : 1,
    childAspectRatio: 1.0,
  ),
  itemBuilder: (context, index) {
    int row = index ~/ grid[0].length;
    int col = index % grid[0].length;

    bool isDiagonal = false;
    bool isHighlighted = false;

    if (grid.isNotEmpty &&
        row < grid.length &&
        col < grid[0].length &&
        grid[row][col] == grid[row][col].toUpperCase()) {
      isDiagonal = true;
    }

    if (grid.isNotEmpty && grid[row][col] != ' ') {
      isHighlighted = true;
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        color: isHighlighted
            ? isDiagonal
                ? const Color.fromARGB(255, 160, 155, 155)
                : (grid[row][col] == grid[row][col].toUpperCase()
                    ? Colors.yellow
                    : Colors.white)
            : null,
      ),
      child: GridTile(
        // ignore: avoid_unnecessary_containers
        child: Container(
          child: Center(
            child: Text(
              grid[row][col],
              style:const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  },
  itemCount: grid.isNotEmpty ? grid.length * grid[0].length : 0,
);

  }

  void createGrid() {
    int? rows = int.tryParse(rowsController.text);
    int? columns = int.tryParse(columnsController.text);

    if (rows == null || columns == null || rows <= 0 || columns <= 0) {
      showSnackBar('Please enter valid rows and columns.');
      return;
    }

    setState(() {
      grid = List.generate(rows, (row) => List.filled(columns, ' '));
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:const Text('Enter alphabets for the grid:'),
          content: SizedBox(
            height: 400.0,
            width: 400.0,
            child: SingleChildScrollView(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                ),
                shrinkWrap: true,
                itemCount: rows * columns,
                itemBuilder: (BuildContext context, int index) {
                  int rowIndex = index ~/ columns;
                  int colIndex = index % columns;

                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          grid[rowIndex][colIndex] = value.isNotEmpty ? value[0] : ' ';
                        });
                      },
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: const TextStyle(fontSize: 18.0),
                      decoration: const InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              child: const Text('Done',style: TextStyle(color: Colors.white),),
            ), 
          ],
        );
      },
    );
  }

  void searchInGrid() {
    String searchText = searchTextController.text.toLowerCase();
    List<List<int>> occurrences = [];

    if (grid.isNotEmpty && searchText.isNotEmpty) {
      for (int i = 0; i < grid.length; i++) {
        for (int j = 0; j < grid[i].length; j++) {
          if (j + searchText.length <= grid[0].length) {
            String east = grid[i].sublist(j, j + searchText.length).join();
            if (east == searchText) {
              occurrences.add([i, j, i, j + searchText.length - 1]);
            }
          }

          if (i + searchText.length <= grid.length) {
            String south = "";
            for (int k = i; k < i + searchText.length; k++) {
              south += grid[k][j];
            }
            if (south == searchText) {
              occurrences.add([i, j, i + searchText.length - 1, j]);
            }
          }

          if (i + searchText.length <= grid.length && j + searchText.length <= grid[0].length) {
            String diagonal = "";
            for (int k = 0; k < searchText.length; k++) {
              diagonal += grid[i + k][j + k];
            }
            if (diagonal == searchText) {
              occurrences.add([i, j, i + searchText.length - 1, j + searchText.length - 1]);
            }
          }

          if (i + searchText.length <= grid.length && j - searchText.length + 1 >= 0) {
            String diagonal = "";
            for (int k = 0; k < searchText.length; k++) {
              diagonal += grid[i + k][j - k];
            }
            if (diagonal == searchText) {
              occurrences.add([i, j, i + searchText.length - 1, j - searchText.length + 1]);
            }
          }
        }
      }
    }

    for (var occurrence in occurrences) {
      highlight(occurrence[0], occurrence[1], occurrence[2], occurrence[3]);
    }

    setState(() {
      textFound = occurrences.isNotEmpty;
    });
  }

  void highlight(int startRow, int startCol, int endRow, int endCol) {
    for (int i = startRow; i <= endRow; i++) {
      for (int j = startCol; j <= endCol; j++) {
        setState(() {
          if (i == startRow && grid[i][j].toLowerCase() != searchTextController.text.toLowerCase()) {
            grid[i][j] = grid[i][j].toUpperCase();
          }
          if (j == startCol && grid[i][j].toLowerCase() != searchTextController.text.toLowerCase()) {
            grid[i][j] = grid[i][j].toUpperCase();
          }
          if (i == j && grid[i][j].toLowerCase() != searchTextController.text.toLowerCase()) {
            grid[i][j] = grid[i][j].toUpperCase();
          }
        });
      }
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void resetGrid() {
    setState(() {
      grid = [];
      rowsController.text = '';
      columnsController.text = '';
      searchTextController.text = '';
      textFound = false;
    });
  }
}
