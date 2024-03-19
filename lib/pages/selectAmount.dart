import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../widgets/components.dart';
import 'package:hive/hive.dart'; // Import Hive package
import 'enterAmount.dart';
import 'drawer.dart';

class SelectAmountPage extends StatefulWidget {
  const SelectAmountPage({super.key});

  @override
  State<SelectAmountPage> createState() => _SelectAmountPageState();
}

class _SelectAmountPageState extends State<SelectAmountPage> {
  final Box _filipay = Hive.box('filipay');

  double loadAmount = 500.00;
  double balance = 0.0; // Declare balance variable

  bool _isLoading = false;
  String username = "[name]";
  double limit = 10000;
  final FocusNode _focusNode = FocusNode();

  void loadingEnter(double amount) {
    setState(() {
      loadAmount = amount;
    });
  }

  void initState() {
    super.initState();
    // Retrieve balance from Hive box
    balance = _filipay.get('balance', defaultValue: 0.0);
  }

  void updateBalance(double amount) {
    setState(() {
      balance += amount;
      // Update balance in Hive box
      _filipay.put('balance', balance);
    });
  }

  void setTrue() {
    setState(() {
      _isLoading = true;
    });
  }

  void loadingConnect() {
    setTrue();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
        myComponents.slider(
          context,
          () {
            setTrue();
            Future.delayed(Duration(seconds: 2), () {
              setState(() {
                _isLoading = false;
                // Update balance when confirmation is completed
                updateBalance(loadAmount);
                myComponents.loadConfirmed(context, () {
                  Navigator.pop(context);
                }, "LOADING CONFIRMED", "Cash In", loadAmount);
              });
            });
          },
          "${loadAmount}",
        );
      });
    });
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  pageComponents myComponents = pageComponents();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> buttonData = [
      {
        'text': '10',
        'onPressed': () {
          loadAmount = 10;
          // loadingConnect();
          _controller.text = "${loadAmount}";
        },
      },
      {
        'text': '20',
        'onPressed': () {
          loadAmount = 20;
          // loadingConnect();
          _controller.text = "${loadAmount}";
        },
      },
      {
        'text': '30',
        'onPressed': () {
          loadAmount = 30;
          // loadingConnect();
          _controller.text = "${loadAmount}";
        },
      },
      {
        'text': '40',
        'onPressed': () {
          loadAmount = 40;
          // loadingConnect();
          _controller.text = "${loadAmount}";
        },
      },
      {
        'text': '50',
        'onPressed': () {
          loadAmount = 50;
          _controller.text = "${loadAmount}";
        },
      },
      {
        'text': '100',
        'onPressed': () {
          loadAmount = 100;
          _controller.text = "${loadAmount}";
        },
      },
      {
        'text': '250',
        'onPressed': () {
          loadAmount = 250;
          _controller.text = "${loadAmount}";
        },
      },
      {
        'text': '500',
        'onPressed': () {
          loadAmount = 500;
          _controller.text = "${loadAmount}";
        },
      },
      {
        'text': '1000',
        'onPressed': () {
          loadAmount = 1000;
          _controller.text = "${loadAmount}";
        },
      },
      // {
      //   'text': 'Enter Amount',
      //   'onPressed': () {
      //     loadingEnter();
      //   },
      // },
    ];
    return Scaffold(
        key: scaffoldKey,
        appBar: myComponents.appBar(scaffoldKey: scaffoldKey),
        drawer: NavDrawer(),
        body: SafeArea(
            child: Stack(children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: myComponents.background(),
          ),
          SingleChildScrollView(
            child: Column(children: [
              myComponents.headerPageLabel(context, ""),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                child: Center(
                  child: Text(
                    "Choose denomination to generate QR code.",
                    style: TextStyle(
                      color: Color(0xff18467e),
                      fontSize: 28.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 5.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Enter desired load amount",
                        ),
                        AmountField(
                          focusNode: _focusNode,
                          controller: _controller,
                        ),
                        SizedBox(height: 30.0),
                        Text(
                          "Or you can also choose from the amount selection below?",
                        ),
                        SizedBox(height: 10.0),
                        GridView.builder(
                          shrinkWrap: true, // Add this line
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 15.0,
                            crossAxisSpacing: 15.0,
                            childAspectRatio:
                                1.5, // Aspect ratio of each grid item
                          ),
                          itemCount: buttonData.length,
                          itemBuilder: (BuildContext context, int index) {
                            return mainButtons.loadButtons(
                              context: context,
                              onPressed: buttonData[index]['onPressed'],
                              text: buttonData[index]['text'],
                              BackgroundColor: Colors.white,
                              textColor: Color(0xff53a1d8),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10.0),
                              radius: BorderRadius.circular(8.0),
                            );
                          },
                        ),
                        SizedBox(height: 30.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 80.0),
                          child: mainButtons.mainButton(
                            context: context,
                            onPressed: () {
                              _focusNode.unfocus();
                              if (_formKey.currentState!.validate()) {
                                setTrue();
                                loadingConnect(); // Call loadingConnect method here
                              }
                            },
                            text: 'CONFIRM',
                            BackgroundColor: Color.fromRGBO(47, 50, 145, 1.0),
                            padding: EdgeInsets.symmetric(
                                horizontal: 40.0, vertical: 20.0),
                            BorderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                        SizedBox(height: 20.0),
                      ]),
                ),
              ),
            ]),
          ),
          Center(
            child: _isLoading
                ? myComponents.simulateLoading(
                    context: context, loadText: "Processing")
                : Text(''),
          ),
        ])));
  }
}

class AmountField extends StatelessWidget {
  final FocusNode focusNode;
  final TextEditingController controller;

  const AmountField({
    Key? key,
    required this.focusNode,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter a valid amount';
        }
        return null;
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        prefix: Text(
          'PHP ',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.transparent, width: 0),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
      ),
    );
  }
}
