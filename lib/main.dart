import 'package:flutter/material.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter RFID Scanner Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

final _userDataList = [
  UserModel(
    name: 'Khabib Nurmagomedov',
    cardId: '0050995178',
  ),
  UserModel(
    name: 'Andrew Tate',
    cardId: '0050304282',
  ),
  UserModel(
    name: 'Mohammed Hijab',
    cardId: '0050441610',
  ),
  UserModel(
    name: 'Khamzat Kamaru',
    cardId: '0051931111',
  ),
  UserModel(
    name: 'Islam Makachev',
    cardId: '0052086890',
  ),
];

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  UserModel scannedUser = UserModel.empty();

  @override
  Widget build(BuildContext context) {
    return BarcodeKeyboardListener(
      bufferDuration: const Duration(milliseconds: 200),
      onBarcodeScanned: (code) {
        bool isUserExist = _userDataList.any(
          (element) => element.cardId.toLowerCase().contains(
                code.toLowerCase(),
              ),
        );
        if (isUserExist) {
          setState(() {
            scannedUser = _userDataList.firstWhere(
              (element) => element.cardId.toLowerCase().contains(
                    code.toLowerCase(),
                  ),
            );
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('User is not exist'),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Flutter RFID Scanner Demo',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _UserInfo(scannedUser),
                const SizedBox(height: 24),
                const _UserListView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Show scanned user from database with RFID Scanner
class _UserInfo extends StatelessWidget {
  const _UserInfo(this.user);
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Name',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Text(
                    ': ${user.name}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Card ID',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Text(
                    ': ${user.cardId}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

/// Show list of user in database
class _UserListView extends StatelessWidget {
  const _UserListView();

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Card(
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: _userDataList.length,
          separatorBuilder: (context, index) => const SizedBox(),
          itemBuilder: (context, index) {
            final user = _userDataList[index];

            return ListTile(
              title: Text(
                user.name,
              ),
              subtitle: Text(user.cardId),
            );
          },
        ),
      ),
    );
  }
}

class UserModel {
  final String name;
  final String cardId;

  UserModel({required this.name, required this.cardId});

  UserModel.empty()
      : this(
          name: '',
          cardId: '',
        );
}
