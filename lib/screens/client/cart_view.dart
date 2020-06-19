import 'package:delivery_app/firebase_services/cart_controller.dart';
import 'package:delivery_app/models/cart_product.dart';
import 'package:delivery_app/screens/client/home.dart';
import 'package:delivery_app/screens/client/search.dart';
import 'package:delivery_app/utils/session_manager.dart';
import 'package:flutter/material.dart';

class CartView extends StatefulWidget {

  @override
  _CartViewState createState() => _CartViewState();

}
class _CartViewState extends State<CartView> {
  

  List<CartProduct> cartProductList = [];
  @override
  void initState() {
    getAllCartProducts();
    super.initState();
  }

  getAllCartProducts() async {
    List<CartProduct> _cartProductList = await CartController.getAllCartProducts();
    setState(() {
      cartProductList = _cartProductList;
    });
  }

  void _onItemTapped(int index) {
    if(index == 0){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => Home()),
      );
    }

    else if(index == 1){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => Search()),
      );
    }

    else if(index == 0){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => Home()),
      );
    }
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
        canvasColor: Color.fromRGBO(156, 174, 202, 1),
        // sets the active color of the `BottomNavigationBar` if `Brightness` is light
        textTheme: Theme
          .of(context)
          .textTheme
          .copyWith(caption: new TextStyle(color: Colors.white))),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text(
                  'Home',
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.search),
                title: Text(
                  'Search',
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                title: Text(
                  'Appointments',
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.local_shipping),
                title: Text(
                  'Orders',
                )),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                title: Text(
                  'Notifications',
                )),
            BottomNavigationBarItem(
            icon: Icon(Icons.email),
            title: Text(
              'Contact Us',
            ))
          ],
          currentIndex: 3,
          type: BottomNavigationBarType.fixed,
          fixedColor: Color.fromRGBO(3, 119, 155, 1),
          onTap: _onItemTapped,
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset("assets/images/background.jpg", fit: BoxFit.cover),
          ),

          Column(
            children: <Widget>[
              
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Image.asset("assets/images/small_logo.png"),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back, color: Colors.white,),
                        ),
                        Center(
                          child: Text("CART", style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
                        ),
                        Text("      "),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 11,
                child: ListView(
                  children: <Widget>[
                    Container(
                      height: 300, 
                      child: ListView.builder(
                        primary: false,
                        itemCount: cartProductList.length,
                        itemBuilder: cart_item,
                      ),
                    ),

                    Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("PAYMENT VISA", style: TextStyle(color: Colors.white),),
                          Text("4695 **** **** 6843", style: TextStyle(color: Colors.white),),
                          Icon(Icons.chevron_right, color: Colors.white)
                        ],
                      ),
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: Colors.grey, width: 0.5),)
                      ),
                    ),

                    Container(
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("ADDRESS", style: TextStyle(color: Colors.white),),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Room 67", style: TextStyle(color: Colors.white),),
                              Text("14 Tottenham Court Road", style: TextStyle(color: Colors.white)),
                              Text("London", style: TextStyle(color: Colors.white)),
                              Text("England", style: TextStyle(color: Colors.white)),
                            ],
                          ),
                          Icon(Icons.chevron_right, color: Colors.white)
                        ],
                      ),
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: Colors.grey, width: 0.5),)
                      ),
                    ),

                    Container(
                      height: 120,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom:10),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: Text("SUMMARY", style: TextStyle(color: Colors.white),),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: Text("SUBTOTAL", style: TextStyle(color: Colors.white),),                                ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    margin: EdgeInsets.only(right: 40,),
                                    child: Text("\$180.00", style: TextStyle(color: Colors.white), textAlign: TextAlign.end,),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Container()
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text("TAX", style: TextStyle(color: Colors.white),),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    margin: EdgeInsets.only(right: 40,),
                                    child: Text("\$3.40", style: TextStyle(color: Colors.white), textAlign: TextAlign.end,),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.only(bottom:10),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Container()
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text("DELIVERY", style: TextStyle(color: Colors.white),),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    margin: EdgeInsets.only(right: 40,),
                                    child: Text("\$2.00", style: TextStyle(color: Colors.white), textAlign: TextAlign.end,),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Container()
                                ),
                                
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    padding: EdgeInsets.only(top: 10, bottom: 10),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Text("TOTAL", style: TextStyle(color: Colors.white),),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            margin: EdgeInsets.only(right: 40,),
                                            child: Text("\$185.40", style: TextStyle(color: Colors.white), textAlign: TextAlign.end,),
                                          ),
                                        ),
                                      ],
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(top: BorderSide(width: 0.5, color: Colors.grey))
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: Colors.grey, width: 0.5),)
                      ),
                    ),
                    MaterialButton(
                      height: 50,
                      onPressed: (){},
                      color: Color.fromRGBO(246, 170, 0, 1),
                      child: Text("PLACE ORDER"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget cart_item(BuildContext context, int index){
    return Container(
      height: 100,
      child: Row(
        children: <Widget>[
          Container(
            height: 100,
            width: 50,
            margin: EdgeInsets.only(right: 10, left: 10),
            child: Image.network(cartProductList[index].productImage)
          ),

          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(cartProductList[index].productName, style: TextStyle(color: Colors.white, fontSize: 16),),
                Container(
                  width: 45,
                  child: Theme(
                     data: Theme.of(context).copyWith(
                        canvasColor: Colors.blue.shade200,
                      ),
                    child: DropdownButton<int>(
                      value: cartProductList[index].count,
                      iconSize: 24,
                      iconEnabledColor: Colors.white,
                      elevation: 16,
                      isExpanded: true,
                      style: TextStyle(
                        color: Colors.white
                      ),
                      onChanged: (int newValue) {
                        setState(() {
                          cartProductList[index].count = newValue;
                        });
                      },
                      items: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                        .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(
                              value.toString(),
                            ),
                          );
                        })
                        .toList(),
                    ),
                  ),
                ),
              ],
            )
          ),

          Expanded(
            flex: 2,
            child: Container(),
          ),

          Expanded(
            flex: 1,
            child: Column(
              children: <Widget>[
                Icon(Icons.delete_forever, color: Colors.red),
                SizedBox(height: 5),
                Text("\$" + (double.parse(cartProductList[index].productPrice) * cartProductList[index].count).toString(), style: TextStyle(color: Colors.white),)
              ],
            ),
          ),
        ],
      ),
    );
  }

}