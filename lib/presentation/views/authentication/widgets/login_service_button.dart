import 'package:flutter/material.dart';

class LoginItem extends StatelessWidget {
  final String serviceName;
  final Function onTap;
  const LoginItem({this.serviceName, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: [
              BoxShadow(
                  blurRadius: 3.0,
                  offset: Offset(0.0, 2.0),
                  color: Color.fromARGB(80, 0, 0, 0))
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              serviceName,
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
