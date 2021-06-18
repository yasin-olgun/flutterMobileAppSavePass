import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:pratik/data/dbHelper.dart';
import 'package:pratik/models/CreditCard.dart';

class CreditCardFormNew extends StatefulWidget {
  var nameController = TextEditingController();
  final MaskedTextController _cardNumberController =
      MaskedTextController(mask: '0000 0000 0000 0000');
  final TextEditingController _expiryDateController =
      MaskedTextController(mask: '00/00');
  final TextEditingController _cardHolderNameController =
      TextEditingController();
  final TextEditingController _cvvCodeController =
      MaskedTextController(mask: '0000');

  int edit = 1;
  int userid = 0;
  CreditCard tempCreditCard = CreditCard();
  CreditCardFormNew(this.edit, this.userid);
  CreditCardFormNew.withData(this.edit, this.tempCreditCard);
  CreditCardFormNew.edit(this.edit, this.tempCreditCard) {
    _cardNumberController.text = tempCreditCard.cardNumber;

    _expiryDateController.text = tempCreditCard.expiryDate;

    _cardHolderNameController.text = tempCreditCard.cardHolderName;

    _cvvCodeController.text = tempCreditCard.cvvCode;
    nameController.text = tempCreditCard.name;
  }

  @override
  State<StatefulWidget> createState() {
    return CreditCardFormNewState();
  }
}

class CreditCardFormNewState extends State<CreditCardFormNew> {
  var dbHelper = DbHelper();
  String cardName = '';
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (widget.edit == 0) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Credit Card"),
          actions: [
            TextButton(
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'halter',
                    fontSize: 14,
                    package: 'flutter_credit_card',
                  ),
                ),
                onPressed: () {
                  valideteSave();
                })
          ],
        ),
        body: Container(
          margin: EdgeInsets.all(2.0),
          child: Column(
            children: [
              CreditCardWidget(
                  obscureCardCvv: false,
                  obscureCardNumber: false,
                  cardNumber: cardNumber,
                  expiryDate: expiryDate,
                  cardHolderName: cardHolderName,
                  cvvCode: cvvCode,
                  showBackView: isCvvFocused),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      CreditCardForm(
                        formKey: formKey,
                        obscureCvv: false,
                        obscureNumber: false,
                        cardNumber: cardNumber,
                        cvvCode: cvvCode,
                        cardHolderName: cardHolderName,
                        expiryDate: expiryDate,
                        themeColor: Colors.blue,
                        cardNumberDecoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Number',
                          hintText: 'XXXX XXXX XXXX XXXX',
                        ),
                        expiryDateDecoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Expired Date',
                          hintText: 'XX/XX',
                        ),
                        cvvCodeDecoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'CVV',
                          hintText: 'XXX',
                        ),
                        cardHolderDecoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Card Holder',
                        ),
                        onCreditCardModelChange: onCreditCardModelChange,
                      ),
                      Container(
                        margin: EdgeInsets.all(15.0),
                        child: TextField(
                          controller: widget.nameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Card Name',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }
    if (widget.edit == 1) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Show"),
          actions: [
            TextButton(
              style: TextButton.styleFrom(primary: Colors.white),
              child: Text("Edit"),
              onPressed: () async {
                bool result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CreditCardFormNew.edit(2, widget.tempCreditCard)));
                if (result != null) {
                  if (result) {
                    setState(() {
                      Navigator.pop(context, true);
                    });
                  }
                }
              },
            )
          ],
        ),
        body: Container(
          margin: EdgeInsets.all(12.0),
          child: Column(
            children: [
              CreditCardWidget(
                  obscureCardCvv: false,
                  obscureCardNumber: false,
                  cardNumber: widget.tempCreditCard.cardNumber,
                  expiryDate: widget.tempCreditCard.expiryDate,
                  cardHolderName: widget.tempCreditCard.cardHolderName,
                  cvvCode: widget.tempCreditCard.cvvCode,
                  showBackView: isCvvFocused),
              IconButton(
                  icon: Icon(Icons.flip_camera_android),
                  onPressed: () {
                    setState(() {
                      isCvvFocused = !isCvvFocused;
                    });
                  })
            ],
          ),
        ),
      );
    }
    if (widget.edit == 2) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Credit Card"),
          actions: [
            TextButton(
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'halter',
                    fontSize: 14,
                    package: 'flutter_credit_card',
                  ),
                ),
                onPressed: () {
                  widget.tempCreditCard.name = widget.nameController.text;
                  widget.tempCreditCard.cardHolderName =
                      widget._cardHolderNameController.text;
                  widget.tempCreditCard.cardNumber =
                      widget._cardNumberController.text;
                  widget.tempCreditCard.cvvCode =
                      widget._cvvCodeController.text;
                  widget.tempCreditCard.expiryDate =
                      widget._expiryDateController.text;

                  dbHelper.updateData("creditcard",
                      creditCard: widget.tempCreditCard);

                  Navigator.pop(context, true);
                }),
          ],
        ),
        body: Container(
          margin: EdgeInsets.all(2.0),
          child: Column(
            children: [
              CreditCardWidget(
                  obscureCardCvv: false,
                  obscureCardNumber: false,
                  cardNumber: widget.tempCreditCard.cardNumber,
                  expiryDate: widget.tempCreditCard.expiryDate,
                  cardHolderName: widget.tempCreditCard.cardHolderName,
                  cvvCode: widget.tempCreditCard.cvvCode,
                  showBackView: isCvvFocused),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            TextField(
                              controller: widget._cardNumberController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Card Number',
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    margin: const EdgeInsets.only(
                                        left: 0, top: 8, right: 16),
                                    child: TextField(
                                      controller: widget._expiryDateController,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Expired Date',
                                        hintText: 'XX/XX',
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    margin: const EdgeInsets.only(
                                        left: 16, top: 8, right: 0),
                                    child: TextField(
                                      controller: widget._cvvCodeController,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'CVV',
                                        hintText: 'XXX',
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            TextField(
                              controller: widget._cardHolderNameController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Card Holder',
                              ),
                            ),
                            SizedBox(height: 10),
                            TextField(
                              controller: widget.nameController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Card Name',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  void valideteSave() {
    if (formKey.currentState.validate()) {
      widget.tempCreditCard.name = widget.nameController.text;
      widget.tempCreditCard.cardHolderName = cardHolderName;
      widget.tempCreditCard.cardNumber = cardNumber;
      widget.tempCreditCard.cvvCode = cvvCode;
      widget.tempCreditCard.expiryDate = expiryDate;
      widget.tempCreditCard.userid = widget.userid;
      dbHelper.insertData("creditcard", creditCard: widget.tempCreditCard);
      Navigator.pop(context, true);
    } else {}
  }
}
