//http: ^0.12.2

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';


const apiKey = "AIzaSyCOPh4H81SCcHbC32jvhIw8DI0YUj_pF0I";

var languages = [
  'English',
  'Hindi',
  'Malayalam',
  'Tamil',
  'French',
  'German',
  'Korean', 
  'Japanese',
  'Spanish'
];
var category = ['Novel', 'Educational', 'Comic', 'Manga', 'Spiritual'];
var subjects = ['Computer Science', 'Chemistry', 'Biology', 'Literature', 'Physics', 'Mathematics', 'Law', 'Accountancy', 'Business', 'Economics', 'Humanities'];
var genres = ['Action', 'Adventure', 'Classic', 'Comedy', 'Fantasy', 'Fiction', 'History', 'Horror', 'Mystery', 'Poetry', 'Romance', 'Thriller'];
var currentGenre1Selected;
var currentGenre2Selected;
var currentLanguageSelected;
var currentCategorySelected;
var currentSubjectSelected;

InputDecoration textFieldInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
  labelStyle: TextStyle(color: Colors.black),
  hintText: 'Book Name',
  suffixIcon: null,
  border: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 0.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 0.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 0.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  fillColor: Colors.white,
  hintStyle: TextStyle(
    color: Colors.grey,
    fontSize: 15.0,
  ),
);

class AddBook extends StatefulWidget {
  @override
  _AddBookState createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {

  List<Widget> columnChild = [];

  Future<File> imageFile;

  pickImageFromGallery(ImageSource source) {
    setState(() {
      imageFile = ImagePicker.pickImage(source: source);
    });
  }

  Widget showImage(String url) {
    return FutureBuilder<File>(
      future: imageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          if(url!=null)
            return Image.network(url);
          return Image.file(
            snapshot.data,
            width: 300,
            height: 300,
          );
        } else if (snapshot.error != null) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  String description = "", imageURL = "", author = "", language = "", genre1 = "", bName = "";
  bool isVisible = false;
  TextEditingController bookName = TextEditingController();

  void getBookDetails(String name) async
  {
    Networking networking = Networking(url: 'https://www.googleapis.com/books/v1/volumes?q=intitle:$name&key=$apiKey');
    var bookData = await networking.getBookData();
    if(bookData!=null){
      setState(() {
        bName = bookData['items'][0]['volumeInfo']['title'];
        author = bookData['items'][0]['volumeInfo']['authors'][0];
        description = bookData['items'][0]['volumeInfo']['description'];
        imageURL = bookData['items'][0]['volumeInfo']['imageLinks']['thumbnail'];
        language = bookData['items'][0]['volumeInfo']['language'];
      });
      print('language = $language');
      print('imageurl = $imageURL');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'BookShelf',
            style: TextStyle(
              fontSize: 40.0,
              fontFamily: 'Dandelion',
              color: Color(0xFFCEF6A0),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xFFCEF6A0),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 15.0, bottom: 7.0, left: 16.0),
                child: Text(
                  'Add a Book',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 12.0, right: 12.0, top: 16.0, bottom: 7.0),
                    child: Material(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      child: TextField(
                        controller: bookName,
                        decoration: textFieldInputDecoration.copyWith(
                            hintText: 'Book Name'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
                    child: Material(
                      elevation: 5.0,
                      color: Color(0xFF02340F),
                      borderRadius: BorderRadius.circular(30.0),
                      child: RawMaterialButton(
                        onPressed: (){
                          getBookDetails(bookName.text);
                          setState(() {
                            isVisible = true;
                          });
                        },
                        padding: EdgeInsets.symmetric(horizontal: 70.0),
                        child: Text(
                          'VERIFY',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: isVisible,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 12.0, right: 12.0, top: 16.0, bottom: 7.0),
                      child: Material(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        child: TextField(
                          decoration: textFieldInputDecoration.copyWith(
                              hintText: bName),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 12.0, right: 12.0, top: 16.0, bottom: 7.0),
                      child: Material(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        child: TextField(
                          decoration: textFieldInputDecoration.copyWith(
                              hintText: author),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 12.0, right: 12.0, top: 16.0, bottom: 7.0),
                      child: Container(
                        width: 350.0,
                        child: Material(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              items: languages.map((String dropDownStringItem) {
                                return DropdownMenuItem<String>(
                                    value: dropDownStringItem,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 30.0),
                                      child: Text(dropDownStringItem),
                                    ));
                              }).toList(),
                              hint: Padding(
                                padding: const EdgeInsets.only(left: 30.0),
                                child: Text(
                                  'Language',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              onChanged: (String newValueSelected) {
                                setState(() {
                                  currentLanguageSelected = newValueSelected;
                                });
                              },
                              value: currentLanguageSelected,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 12.0, right: 12.0, top: 16.0, bottom: 7.0),
                      child: Container(
                        width: 350.0,
                        child: Material(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              items: category.map((String dropDownStringItem) {
                                return DropdownMenuItem<String>(
                                    value: dropDownStringItem,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 30.0),
                                      child: Text(dropDownStringItem),
                                    ));
                              }).toList(),
                              hint: Padding(
                                padding: const EdgeInsets.only(left: 30.0),
                                child: Text(
                                  'Category',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              onChanged: (String newValueSelected) {
                                setState(() {
                                  currentCategorySelected = newValueSelected;
                                  columnChild = [];
                                  if(currentCategorySelected == 'Novel' || currentCategorySelected == 'Comic' || currentCategorySelected == 'Manga'){
                                    columnChild.add(Divide());
                                    columnChild.add(Genre1());
                                    columnChild.add(Genre2());
                                    columnChild.add(Divide());
                                  }
                                  if(currentCategorySelected == 'Educational'){
                                    columnChild.add(Divide());
                                    columnChild.add(Subject());
                                    columnChild.add(Tag());
                                    columnChild.add(Divide());
                                  }
                                  if (currentCategorySelected == 'Spiritual'){
                                    columnChild = [];
                                  }
                                });
                              },
                              value: currentCategorySelected,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: columnChild,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 12.0, right: 12.0, top: 16.0, bottom: 7.0),
                      child: Material(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        child: TextField(
                          decoration: textFieldInputDecoration.copyWith(
                              hintText: 'Link'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 12.0, right: 12.0, top: 16.0, bottom: 7.0),
                      child: Material(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 8,
                          decoration:
                          textFieldInputDecoration.copyWith(hintText: description),
                        ),
                      ),
                    ),
                    //Image.network(imageURL),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 12.0, right: 12.0, top: 16.0, bottom: 7.0),
                      child: Material(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        child: Container(
                          width: 200.0,
                          child: FlatButton.icon(
                            onPressed: () {
                              pickImageFromGallery(ImageSource.gallery);
                            },
                            icon: Icon(Icons.image),
                            label: Text('Image'),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 20.0),
                      child: showImage(imageURL),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
                      child: Material(
                        elevation: 5.0,
                        color: Color(0xFF02340F),
                        borderRadius: BorderRadius.circular(30.0),
                        child: RawMaterialButton(
                          onPressed: null,
                          padding: EdgeInsets.symmetric(horizontal: 70.0),
                          child: Text(
                            'ADD',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class Subject extends StatefulWidget {
  @override
  _SubjectState createState() => _SubjectState();
}

class _SubjectState extends State<Subject> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 12.0, right: 12.0, top: 7.0, bottom: 7.0),
      child: Container(
        width: 250.0,
        child: Material(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              items: subjects.map((String dropDownStringItem) {
                return DropdownMenuItem<String>(
                    value: dropDownStringItem,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: Text(dropDownStringItem),
                    ));
              }).toList(),
              hint: Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Text(
                  'Subjects',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              onChanged: (String newValueSelected) {
                setState(() {
                  currentSubjectSelected = newValueSelected;
                });
              },
              value: currentSubjectSelected,
            ),
          ),
        ),
      ),
    );
  }
}

class Genre1 extends StatefulWidget {
  @override
  _Genre1State createState() => _Genre1State();
}

class _Genre1State extends State<Genre1> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 12.0, right: 12.0, top: 7.0, bottom: 7.0),
      child: Container(
        width: 250.0,
        child: Material(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              items: genres.map((String dropDownStringItem) {
                return DropdownMenuItem<String>(
                    value: dropDownStringItem,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: Text(dropDownStringItem),
                    ));
              }).toList(),
              hint: Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Text(
                  'Genre 1',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              onChanged: (String newValueSelected) {
                setState(() {
                  currentGenre1Selected = newValueSelected;
                });
              },
              value: currentGenre1Selected,
            ),
          ),
        ),
      ),
    );
  }
}

class Genre2 extends StatefulWidget {
  @override
  _Genre2State createState() => _Genre2State();
}

class _Genre2State extends State<Genre2> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 12.0, right: 12.0, top: 7.0, bottom: 7.0),
      child: Container(
        width: 250.0,
        child: Material(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              items: genres.map((String dropDownStringItem) {
                return DropdownMenuItem<String>(
                    value: dropDownStringItem,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: Text(dropDownStringItem),
                    ));
              }).toList(),
              hint: Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Text(
                  'Genre 2',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              onChanged: (String newValueSelected) {
                setState(() {
                  currentGenre2Selected = newValueSelected;
                });
              },
              value: currentGenre2Selected,
            ),
          ),
        ),
      ),
    );
  }
}

class Divide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 30.0, right: 30.0),
      child: Divider(
        color: Colors.black,
        height: 36,
        thickness: 1.5,
      ),
    );
  }
}

class Tag extends StatefulWidget {
  @override
  _TagState createState() => _TagState();
}

class _TagState extends State<Tag> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 12.0, right: 12.0, top: 16.0, bottom: 7.0),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        child: Container(
          width: 250.0,
          child: TextField(
            decoration: textFieldInputDecoration.copyWith(
                hintText: 'Tag'),
          ),
        ),
      ),
    );
  }
}

class Networking
{
  final String url;
  Networking({this.url});

  Future getData() async{
    http.Response response = await http.get(url);
    if(response.statusCode == 200)
    {
      String data = response.body;
      var decodedData = jsonDecode(data);
      return decodedData;
    }
    else
      print(response.statusCode);
  }

  Future<dynamic> getBookData() async
  {
    var bookData = await getData();
    return bookData;
  }
}