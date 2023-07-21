import 'dart:convert';
import 'dart:math';
//Kendala di hadir kemarin gaada sinyal. Karena tidak ada sinyal foto tidak bisa masuk
import 'package:flutter/material.dart';
import 'package:pt_coronet_crown/account/createacount.dart';
import 'package:pt_coronet_crown/account/login.dart';
import 'package:pt_coronet_crown/admin/attendence/dailyvisit.dart';
import 'package:pt_coronet_crown/admin/company/daftarkota.dart';
import 'package:pt_coronet_crown/admin/jabatan/daftarjabatan.dart';
import 'package:pt_coronet_crown/admin/personel/addpersonelgroup.dart';
import 'package:pt_coronet_crown/admin/personel/personeldata.dart';
import 'package:pt_coronet_crown/admin/personel/personelgroup.dart';
import 'package:pt_coronet_crown/admin/company/daftarproduk.dart';
import 'package:pt_coronet_crown/drawer.dart';
import 'package:pt_coronet_crown/laporan/event/buatproposal.dart';
import 'package:pt_coronet_crown/laporan/event/daftarevent.dart';
import 'package:pt_coronet_crown/laporan/event/daftarproposal.dart';
import 'package:pt_coronet_crown/laporan/pembelian/buatlaporanbeli.dart';
import 'package:pt_coronet_crown/laporan/pembelian/daftarpembelian.dart';
import 'package:pt_coronet_crown/laporan/penjualan/buatlaporanjual.dart';
import 'package:pt_coronet_crown/laporan/penjualan/daftarpenjualan.dart';
import 'package:pt_coronet_crown/mainpage/history.dart';
import 'package:pt_coronet_crown/mainpage/home.dart';
import 'package:pt_coronet_crown/mainpage/visit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image/image.dart' as img;

String username = "", idjabatan = "", idcabang = "";
var avatar = "";

Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString("username") ?? '';
}

Future<String> getIdJabatan() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString("idJabatan") ?? '';
}

Future<String> getAvatar() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString("avatar") ?? '';
}

Future<String> getIdCabang() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString("idCabang") ?? '';
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  checkUser().then((String result) {
    if (result == '')
      runApp(MyLogin());
    else {
      username = result;
      runApp(const MyApp());
    }
  });

  getIdJabatan().then((String result) {
    idjabatan = result;
  });

  getAvatar().then((String result) {
    avatar = result;
  });

  getIdCabang().then((String result) {
    idcabang = result;
  });
}

void doLogout() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.remove("username");
  main();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PT Coronet Crown',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Home'),
      debugShowCheckedModeBanner: false,
      routes: {
        "/tambahlaporanpenjualan": (context) =>
            BuatPenjualan(id: Random().nextInt(2)),
        "/tambahlaporanpembelian": (context) => BuatPembelian(),
        "/homepage": (context) => MyApp(),
        "/kunjunganmasuk": (contex) => Visit(),

        "/daftarproposal": (context) => DaftarProposal(),
        // "/daftarevent": (context) => DaftarEvent(),

        //harus dilakukan pengecekan id jabatan
        "/daftarpembelian": (context) => DaftarPembelian(),
        "/daftarpenjualan": (context) => DaftarPenjualan(),
        "/daftarkunjungan": (context) => DailyVisit(),
        "/daftarpersonel": (context) => PersonelData(),
        "/daftargrup": (context) => PersonelGroup(),
        "tambahstaff": (context) => CreateAccount(),
        "tambahgrup": (context) => CreateGroup(),
        "/daftarproduk": (context) => DaftarProduk(),
        "/daftarjabatan": (context) => DaftarJabatan(),
        "/daftaroutlet": (context) => DaftarKota(),
        "/ajukanproposal": (context) => BuatProposal(id_cabang: idcabang, username : username),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final List<Widget> _screens = [Home(), History()];
  // final List<String> _title = ['Home', 'History'];

  Widget myBottomNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      fixedColor: Colors.teal,
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          label: "Home",
          icon: Icon(Icons.home),
        ),
        const BottomNavigationBarItem(
          label: "History",
          icon: Icon(Icons.history),
        ),
        const BottomNavigationBarItem(
          label: "Account",
          icon: Icon(Icons.person),
        ),
      ],
      onTap: (int index) {
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }

  void doLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("username");
    main();
  }

  @override
  Widget build(BuildContext context) {
    if (idjabatan == "1" || idjabatan == "2") {
      return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[],
            ),
          ),
          drawer: MyDrawer());
    } else {
      return Scaffold(
        appBar: AppBar(
            title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/crn.png', height: 50, fit: BoxFit.cover),
            CircleAvatar(
              backgroundImage: Image.memory(base64Decode(avatar)).image,
              radius: 23,
            )
          ],
        )
            // actions: <Widget>[

            // ],
            ),
        body: _screens[_currentIndex],
        bottomNavigationBar: myBottomNavBar(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            doLogout();
          },
          label: Text("Logout", style: TextStyle(color: Colors.white)),
          icon: const Icon(Icons.logout),
        ),
      );
    }
  }
}
