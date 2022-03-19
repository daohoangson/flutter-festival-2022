import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:english_words/english_words.dart';

class AuthWidget extends StatefulWidget {
  final Widget child;
  final void Function(AuthUser user)? onUserSignedIn;

  const AuthWidget({
    required this.child,
    Key? key,
    this.onUserSignedIn,
  }) : super(key: key);

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  @override
  void initState() {
    super.initState();
    _signInAnonymously();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  Future<void> _signInAnonymously() async {
    final userCredential = await FirebaseAuth.instance.signInAnonymously();
    final user = userCredential.user;
    if (user == null) {
      debugPrint('_signInAnonymously: user is null');
      return;
    }

    var isNew = false;
    var name = user.displayName ?? '';
    if (name.isEmpty) {
      isNew = true;

      final pair = generateWordPairs().take(1).first;
      name = pair.asString;
      debugPrint("_signInAnonymously: update ${user.uid}'s name $name");
      await user.updateDisplayName(name);
    } else {
      debugPrint("_signInAnonymously: $name uid=${user.uid} signed in");
    }

    widget.onUserSignedIn?.call(AuthUser._(
      isNew: isNew,
      name: name,
      uid: user.uid,
    ));
  }
}

class AuthUser {
  final bool isNew;
  final String name;
  final String uid;

  AuthUser._({
    required this.isNew,
    required this.name,
    required this.uid,
  });
}
