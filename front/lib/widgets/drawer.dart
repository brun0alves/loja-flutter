import 'package:flutter/material.dart';
import 'package:trab/routes/routes.dart';

class AppDrawer extends StatelessWidget {
  Widget _createDrawerItem(
      {required IconData icon,
      required String text,
      required GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        /*decoration: BoxDecoration(
          color: Colors.blue,
          /*image: DecorationImage(
                fit: BoxFit.fitHeight,
                image: AssetImage('assets/images/vaca.png')
            )*/
        ),*/
        child: Stack(children: <Widget>[
          Positioned(
              bottom: 12.0,
              left: 16.0,
              child: Text("Cadastro de Clientes",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500))),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          _createDrawerItem(
              icon: Icons.add,
              text: 'Inserir Cliente',
              onTap: () =>
                  Navigator.pushReplacementNamed(context, Routes.insert)),
          Divider(),
          _createDrawerItem(
              icon: Icons.list,
              text: 'Listar Clientes',
              onTap: () =>
                  Navigator.pushReplacementNamed(context, Routes.list)),
          ListTile(
            title: Text('0.0.1'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
