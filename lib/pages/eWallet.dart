import 'package:flutter/material.dart';
import '../widgets/components.dart';
import 'package:hive/hive.dart'; // Import Hive package
import 'topUpPage.dart';
import '../functions/functions.dart';

class EWalletPage extends StatefulWidget {
  const EWalletPage({Key? key}) : super(key: key);

  @override
  State<EWalletPage> createState() => _EWalletPageState();
}

class _EWalletPageState extends State<EWalletPage> {
  final Box _filipay = Hive.box('filipay');
  pageFunctions _functions = pageFunctions();
  pageComponents myComponents = pageComponents();
  late double balance;

  @override
  void initState() {
    super.initState();
    // Retrieve balance from Hive box using current user's ID
    int currentUserId = _functions.current_user_id;
    balance = _filipay.get('balance_$currentUserId', defaultValue: 0.0);
  }

  // Method to update balance
  void updateBalance(double newBalance) {
    setState(() {
      balance = newBalance;
      // Retrieve current user's ID
      int currentUserId = _functions.current_user_id;
      // Update balance in Hive box using current user's ID
      _filipay.put('balance_$currentUserId', balance);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            myComponents.headerPageLabel(context, "E-Wallet"),
            Expanded(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: myComponents.background(),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(30.0),
                          decoration: BoxDecoration(
                            color: Color(0xffe6e7e8),
                            borderRadius: BorderRadius.circular(7.0),
                            border: Border.all(
                              color: Color(0xffa6a8ab),
                              width: 2.0,
                            ),
                          ),
                          child: Text(
                            "PHP $balance", // Display dynamic balance
                            style: TextStyle(
                              fontSize: 40.0,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff18467e),
                            ),
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "FILIPAY Credits",
                              style: TextStyle(
                                color: Color(0xffef8b06),
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            SizedBox(width: 10.0),
                            Image(
                              width: 20.0,
                              height: 20.0,
                              image: AssetImage(
                                "assets/general/coin-regular.png",
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            myComponents.transportaionMode(
                              padding: 20.0,
                              context: context,
                              page: TopUpPage(),
                              modeText: "Top Up",
                              path: "assets/e-wallet/top-up.png",
                            ),
                            myComponents.transportaionMode(
                              padding: 20.0,
                              context: context,
                              page: Placeholder(),
                              modeText: "FCP Rewards",
                              path: "assets/e-wallet/FCP-Logo.png",
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            myComponents.transportaionMode(
                              padding: 20.0,
                              context: context,
                              page: Placeholder(),
                              modeText: "Request",
                              path: "assets/e-wallet/Request.png",
                            ),
                            myComponents.transportaionMode(
                              padding: 20.0,
                              context: context,
                              page: Placeholder(),
                              modeText: "Send",
                              path: "assets/e-wallet/Send_icon.png",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
