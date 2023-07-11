# eLibLend - LibraryApps

eLinLend is an application that allows you to borrow books online from various libraries across Indonesia. You can search for books that you want based on title, author, genre, or keyword. You can also see book recommendations.

## View Application

<img src="https://i.ibb.co/dbWwT0k/Desain-tanpa-judul.png">

## Download Application

- Github (Available) - <a href="./downloads/">go to Download here</a>
- Playstore (Upcoming) - https://play.google.com/store/apps/details?id=com.superapp.library_app

## Structure Project

```
- lib
--- bloc
--- components
--- helpers
--- models
--- repository
--- route
--- ui
--- main.dart
```

Bloc Folder

- Bloc folder is used to handle every event on a page, change the state of data on buttons, access pages, and so on

```dart
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState()) {
    on<SubmittedLogInEvent>(_submitLogInClicked);
    on<EmailLoginEvent>(_emailEvent);
    on<PasswordLoginEvent>(_passwordEvent);
  }
}

```

Components Folder

- The Components folder is used to create a reusable widget that can later be used from multiple pages

```dart
Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(5),
          border: border,
        ),
        child: title != ''
            ? Text(
                title,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: fontTextColor),
              )
            : Icon(
                icons,
                color: Colors.white,
                size: 25,
              ),
      ),
    );
```

Models

- Represent data in the form of objects that have attributes and methods. Objects are modular units that can interact with other objects via messages.

```dart
class Users {
  final String name;
  final String uid;
  final String email;

  Users({this.name = '', this.uid = '', this.email = ''});

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      uid: json['uuid'],
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'email': email,
      };
}
```

Repository

- The Repository Folder aims to allow applications to connect to perform queries directly with Firebase

Route

- To store a namedRoute on each application page

UI

- The UI folder contains a page from the application
