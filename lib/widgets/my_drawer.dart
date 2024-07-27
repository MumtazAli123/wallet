import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallet/app/modules/home/controllers/home_controller.dart';
import 'package:wallet/widgets/privacy_policy.dart';

import '../addressScreen/address_screen.dart';
import '../global/global.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final controller = Get.put(HomeController());

  String name = sharedPreferences!.getString('name') ?? '';
  String email = sharedPreferences!.getString('email') ?? '';
  String profileImage = sharedPreferences!.getString('image') ?? "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.cleanpng.com%2Fpng-computer-icons-user-profile-person-730537%2F&psig=AOvVaw1QX8MH26kPfq4tS6bH9YVm&ust=1716047055827000&source=images&cd=vfe&opi=89978449&ved=0CBIQjRxqFwoTCLjV586DlYYDFQAAAAAdAAAAABAJ";
  String phoneNumber = sharedPreferences!.getString('phone') ?? '';

  var url_launcher = Get.find<HomeController>();
  bool isSelect = false;

  @override
  void initState() {
    super.initState();
    // controller.getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(

      elevation: 10,
      // backgroundColor: Theme.of(context).cardColor,
      surfaceTintColor: Colors.white,
      child: _buildBody(),
    );
  }

  _buildBody() {
    return ListView(
      children: [
        _buildHeader(),
        _buildBodyContent(),
      ],
    );
  }

  _buildHeader() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(color: Colors.brown[400]),
      accountName: Text(name),
      accountEmail: Text(phoneNumber),
      otherAccountsPictures: [
        IconButton(
          onPressed: () {
            // controller.updateSellerName(
            //   name: name,
            // );
          },
          icon: const Icon(Icons.edit),
        ),
      ],
      currentAccountPicture: CircleAvatar(
        backgroundImage: NetworkImage(profileImage),
      ),
    );
  }

  _buildBodyContent() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.email, color: Colors.orange),
          title:  Text(email),
          onTap: () {
            // url_launcher.launch('mailto:$email');
            launch('mailto:$email');

          },
        ),
        ListTile(
          // address
          leading: const Icon(Icons.location_on),
          title: const Text('Address'),
          onTap: () {
            Get.to(() => const AddressScreen());
          },
        ),
        ListTile(
          selectedColor: Colors.orange,
          leading: const Icon(Icons.reorder),
          title: const Text('New Orders'),
          onTap: () {
            // Navigator.of(context).pushNamed('/orders');
          },
        ),
        ListTile(
          leading: const Icon(Icons.hotel),
          title: const Text('Confirmed Orders'),
          onTap: () {
            // Navigator.push(context, MaterialPageRoute(builder: (context)=>const ShiftedOrdersScreen()));
          },
        ),

        ListTile(
          leading: const Icon(Icons.privacy_tip),
          title: const Text('Privacy Policy'),
          onTap: () {
            Get.to(() => const PrivacyPolicyScreen());
          },
        ),
        ListTile(
          leading: const Icon(Icons.wallet_membership),
          title: const Text('Wallet'),
          onTap: () {
            Get.toNamed('/wallet');
          },
        ),
         ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              // Navigator.of(context).pushNamed('/gas');
            },
          ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: () {
            fAuth.signOut();
            Get.offAllNamed('/login');
          },
        ),
      ],
    );
  }

}
