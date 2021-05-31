import 'package:provider/provider.dart';

import '../Providers/products.dart';
import 'package:flutter/material.dart';
import '../Providers/product_providers.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrrlFocus = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: null, title: '', price: 0, description: '', imageUrl: '');

  // to Provide initial values to the field in case of edit
  var _initValues = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _isloading = false;
  @override
  void initState() {
    // TODO: implement initState
    _imageUrrlFocus.addListener(imageUpdate);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void>  _saveForm() async{
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isloading = true;
    });
    if (_editedProduct.id != null)  {
    await Provider.of<Products>(context, listen: false).updateProduct(_editedProduct.id, _editedProduct);
     
    } else {
      try{
     await  Provider.of<Products>(context, listen: false)
          .addProduct(_editedProduct);
          }catch(error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('An error occurred!'),
                content: Text('Something went wrong.'),
                actions: <Widget>[
                  FlatButton(child: Text('Okay'), onPressed: () {
                    Navigator.of(ctx).pop();
                  },)
                ],
              ),
        );
      }
     
    }
     setState(() {
        _isloading=false;
      });
      Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _imageUrrlFocus.addListener(imageUpdate);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrrlFocus.dispose();
    super.dispose();
  }

  void imageUpdate() {
    if (!_imageUrrlFocus.hasFocus) {
      setState(() {});
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Manage Product'),
          actions: [IconButton(icon: Icon(Icons.save), onPressed: _saveForm)],
        ),
        body: _isloading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: EdgeInsets.all(16.0),
                child: Form(
                    key: _form,
                    child: SingleChildScrollView(
                      child: Column(children: [
                        TextFormField(
                          initialValue: _initValues['title'],
                          decoration: InputDecoration(labelText: 'Title'),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_priceFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please provide a Title';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                              description: _editedProduct.description,
                              imageUrl: _editedProduct.imageUrl,
                              price: _editedProduct.price,
                              title: value,
                              id: _editedProduct.id,
                              isFavorite: _editedProduct.isFavorite,
                            );
                          },
                        ),
                        TextFormField(
                          initialValue: _initValues['price'],
                          decoration: InputDecoration(labelText: 'Price'),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          focusNode: _priceFocusNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_descriptionFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please Enter a Price';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please Enter a valid number';
                            }
                            if (double.parse(value) <= 0) {
                              return 'Please enter a price greater than 0';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                              description: _editedProduct.description,
                              imageUrl: _editedProduct.imageUrl,
                              price: double.parse(value),
                              title: _editedProduct.title,
                              id: _editedProduct.id,
                              isFavorite: _editedProduct.isFavorite,
                            );
                          },
                        ),
                        TextFormField(
                          initialValue: _initValues['description'],
                          decoration: InputDecoration(labelText: 'Description'),
                          maxLines: 3,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.multiline,
                          focusNode: _descriptionFocusNode,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please Enter a description';
                            }
                            if (value.length < 10) {
                              return 'Please provide more detail';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedProduct = Product(
                              description: value,
                              imageUrl: _editedProduct.imageUrl,
                              price: _editedProduct.price,
                              title: _editedProduct.title,
                              id: _editedProduct.id,
                              isFavorite: _editedProduct.isFavorite,
                            );
                          },
                        ),
                        Row(
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              margin: EdgeInsets.only(
                                top: 8,
                                right: 10,
                              ),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              )),
                              child: _imageUrlController.text.isEmpty
                                  ? Text(
                                      'Enter Image URL',
                                      textAlign: TextAlign.center,
                                    )
                                  : FittedBox(
                                      child: Image.network(
                                          _imageUrlController.text),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            Expanded(
                                child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Image URL'),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageUrrlFocus,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Enter a Url';
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return 'Please enter a valid Url';
                                }
                                if (!value.endsWith('.png') &&
                                    !value.endsWith('.jpg') &&
                                    !value.endsWith('jpeg')) {
                                  return 'Please enter a valid Url';
                                }
                                return null;
                              },
                              onFieldSubmitted: (_) {
                                _saveForm();
                              },
                              onEditingComplete: () {
                                setState(() {});
                              },
                              onSaved: (value) {
                                _editedProduct = Product(
                                  description: _editedProduct.description,
                                  imageUrl: value,
                                  price: _editedProduct.price,
                                  title: _editedProduct.title,
                                  id: _editedProduct.id,
                                  isFavorite: _editedProduct.isFavorite,
                                );
                              },
                            ))
                          ],
                        )
                      ]),
                    )),
              ));
  }
}
