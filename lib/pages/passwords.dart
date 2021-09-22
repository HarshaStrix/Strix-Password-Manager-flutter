import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:password_manager/controller/encrypter.dart';
import 'package:password_manager/icons_map.dart' as CustomIcons;

class Passwords extends StatefulWidget {
  @override
  _PasswordsState createState() => _PasswordsState();
}

class _PasswordsState extends State<Passwords> {
  Box box = Hive.box('passwords');
  bool longPressed = false;
  EncryptService _encryptService = new EncryptService();
  Future fetch() async {
    if (box.values.isEmpty) {
      return Future.value(null);
    } else {
      return Future.value(box.toMap());
    }
  }

  @override
  Widget build(BuildContext context) {

    Function alternateColor = getAlternate(start: 0);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: Text(
          "Your Passwords",
          style: TextStyle(
            fontFamily: "customFont",
            fontSize: 22.0,
          ),
        ),
      ),
      //
      floatingActionButton: FloatingActionButton(
        onPressed: insertDB,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            20.0,
          ),
        ),
        backgroundColor: Colors.teal.shade500,
      ),
      //
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      //
      body: FutureBuilder(
        future: fetch(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "You have saved no password :(",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontFamily: "customFont",
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40,),
                  Text(
                    "Save some, it's Secure 🔐",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontFamily: "customFont",
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 5,),
                  Text(
                    "Everything will be in your Phone :)",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontFamily: "customFont",
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                Map data = box.getAt(index);
                return Card(
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                    //side: BorderSide( color: Colors.lightBlueAccent.shade100 ,width: 1.5),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  margin: EdgeInsets.all(
                    12.0,
                  ),
                  child: Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        //side: BorderSide( color: Colors.lightBlueAccent.shade100 ,width: 1.5),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 20.0,
                      ),
                      tileColor: alternateColor(),
                      //tileColor: Colors.lightBlue.shade100,
                      leading: CustomIcons.icons[data['type']] ??
                          Icon(
                            Icons.lock,
                            size: 32.0,
                            color: Colors.white,
                          ),
                      title: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            "${data['nick']}",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 22.0,
                              fontFamily: "customFont",
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      subtitle: Text(
                        "Click on the copy icon to copy your Password",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 9.7,
                          fontFamily: "customFont",
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          _encryptService.copyToClipboard(
                            data['password'],
                            context,
                          );
                        },
                        icon: Icon(
                          Icons.copy_rounded,
                          size: 24.0,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: 'Edit',
                        color: Colors.black45,
                        icon: Icons.edit,
                        onTap: () {},
                      ),
                      IconSlideAction(
                        closeOnTap: true,
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () {},
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void insertDB() {
    String type;
    String nick;
    String email;
    String password;
    showModalBottomSheet(
      //backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(32.0),
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(
              12.0,
            ),
            child: Form(
              child: Column(
                //mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Service",
                      hintText: "Google",
                    ),
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: "customFont",
                    ),
                    onChanged: (val) {
                      type = val;
                    },
                    validator: (val) {
                      if (val.trim().isEmpty) {
                        return "Enter A Value !";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Nick Name",
                      hintText: "Will be displayed as a Title",
                    ),
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: "customFont",
                    ),
                    onChanged: (val) {
                      nick = val;
                    },
                    validator: (val) {
                      if (val.trim().isEmpty) {
                        return "Enter A Value !";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Username/Email/Phone",
                    ),
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: "customFont",
                    ),
                    onChanged: (val) {
                      email = val;
                    },
                    validator: (val) {
                      if (val.trim().isEmpty) {
                        return "Enter A Value !";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Password",
                    ),
                    style: TextStyle(
                      fontFamily: "customFont",
                      fontWeight: FontWeight.w400,
                    ),
                    onChanged: (val) {
                      password = val;
                    },
                    validator: (val) {
                      if (val.trim().isEmpty) {
                        return "Enter A Value !";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // encrypt
                      password = _encryptService.encrypt(password);
                      // insert into db
                      Box box = Hive.box('passwords');
                      // insert
                      var value = {
                        'type': type.toLowerCase(),
                        'nick': nick,
                        'email': email,
                        'password': password,
                      };
                      box.add(value);

                      Navigator.of(context).pop();
                      setState(() {});
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: "customFont",
                      ),
                    ),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 30.0,
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(
                        Colors.teal.shade500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Function getAlternate({int start = 0}) {
    int indexNum = start;

    Color getColor() {
      Color color = Colors.teal.shade200;

      if(indexNum % 2 == 0) {
        color = Colors.lightBlue.shade200;
      }
      indexNum++;
      return color;
    }

    return getColor;
  }

  //alternateColor() {}
}
