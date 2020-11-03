import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopApp/providers/product.dart';
import 'package:shopApp/providers/products.dart';

class EditProductScreen extends StatefulWidget {
 static const routeName="/edit-product";
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _pricefocusnode=FocusNode();
  final _imageUrlController= TextEditingController();
    final _imageUrlFocuseNode= FocusNode();
    final  _form=GlobalKey<FormState>();
    bool _isLoading=false;
  
    var _editedproduct=Product(id: null, title: '', description: '', price:0, imageUrl:'');
  @override
  void dispose() {
   // _pricefocusnode.dispose(); focus node already dispose when we close the widget 
    _imageUrlController.dispose();
   // _imageUrlFocuseNode.dispose();
    _imageUrlFocuseNode.removeListener(_UpdateImgURL);
    // TODO: implement dispose
    super.dispose();
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    final id=ModalRoute.of(context).settings.arguments as String;
    if(id!=null){
    _editedproduct=Provider.of<Products>(context).getItemById(id);
_imageUrlController.text=_editedproduct.imageUrl;
    }
    super.didChangeDependencies();
  }
  
@override
  void initState() {
    // TODO: implement initState
    _imageUrlFocuseNode.addListener(_UpdateImgURL);
    super.initState();
  }
  void _UpdateImgURL()
  {    
          
 if(!_imageUrlFocuseNode.hasFocus)
      {
        if(_imageUrlController.text.isEmpty||(!_imageUrlController.text.startsWith("http")&&!_imageUrlController.text.startsWith("https"))
  ||(!_imageUrlController.text.endsWith(".jpg")&&!_imageUrlController.text.endsWith(".png")&&!_imageUrlController.text.endsWith(".jpeg"))
  )
  return  ;
        setState(() {
          
        });
      }
  }
  void _saveForm() async{
    setState(() {
          _isLoading=true;

    });
    final isvalid=_form.currentState.validate();
    if(isvalid==false)
    return;
  _form.currentState.save();
  if(_editedproduct.id!=null)
 {
   await Provider.of<Products>(context,listen: false).editItem(_editedproduct.id, _editedproduct);
        setState(() {
              _isLoading=false;
        });
  Navigator.of(context).pop();
 }

  
  else {
    
///////////////////////////////////////////////////
try{

await Provider.of<Products>(context,listen: false).addItem(_editedproduct);

}
catch(error){
  await showDialog<Null>(context: context, builder: (ctx){ // return null in show dialog (it's future) because .pop() dont erturn anyting, it's return null, and the returnong from the alert is what's coming from .pop
return AlertDialog(title: Text("un error occurred!"),
actions: [
  FlatButton(onPressed: ()=>Navigator.of(context).pop(), child: Text("Ok"))
],
content: Text("something went wrong"),
);
});
}
      

  finally{setState(() {
          _isLoading=false;
    });
  Navigator.of(context).pop();}
    
  }
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
       appBar: AppBar(title: Text("Edit Product"),
       actions: [IconButton(icon: Icon(Icons.save), onPressed: _saveForm)],),
       body:_isLoading? Center(child: CircularProgressIndicator()) :
           Form(key: _form,
         child: ListView(
         children: [
           TextFormField(
             decoration: InputDecoration(labelText: "Title"),
             initialValue: _editedproduct.title,
             textInputAction: TextInputAction.next,
          onFieldSubmitted: (_)=>FocusScope.of(context).requestFocus(_pricefocusnode),
          onSaved: (val){
            _editedproduct=Product(id: _editedproduct.id,isFavorite: _editedproduct.isFavorite ,title: val, description: _editedproduct.description, 
            price: _editedproduct.price, imageUrl: _editedproduct.imageUrl);
          },
          validator: (val){
            if(val.isEmpty)
            return "Please enter title.";
            return null;

          },
           ),
           TextFormField(
             decoration: InputDecoration(labelText: "Price"),
             initialValue: _editedproduct.price.toString(),
             textInputAction: TextInputAction.next,
             keyboardType:TextInputType.number,
             focusNode: _pricefocusnode,
              onSaved: (val){
            _editedproduct=Product(id: _editedproduct.id,isFavorite: _editedproduct.isFavorite , title: _editedproduct.title, description: _editedproduct.description, 
            price: double.parse(val), imageUrl: _editedproduct.imageUrl);
          },
          validator: (val){
            if(val.isEmpty)
            return "Please enter price.";
            if(double.tryParse(val)==null)
            return "Please Enter a Valid number.";
            if(double.parse(val)<=0)
            return "Please Enter number more then zero.";
            return null;

          },

           ),
            TextFormField(
             decoration: InputDecoration(labelText: "Description"),
             keyboardType:TextInputType.multiline,
             initialValue: _editedproduct.description,
             maxLines: 3,
              onSaved: (val){
            _editedproduct=Product(id: _editedproduct.id,isFavorite: _editedproduct.isFavorite ,title: _editedproduct.title, description:val, 
            price: _editedproduct.price, imageUrl: _editedproduct.imageUrl);
          },validator: (val){
            if(val.isEmpty)
            return "Please Enter Description.";
            if(val.length<10)
            return "should be at least 10 characters long";
            return null;

          }

           ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
             children: [ Container(
               margin: EdgeInsets.only(top: 8, right:10),
               width: 100,
               height: 100,
               decoration: BoxDecoration(
                 border: Border.all(color: Colors.grey)
               ),
        child:_imageUrlController.text.isEmpty? Text("Enter Image Url") :FittedBox(child: Image.network(_imageUrlController.text, fit: BoxFit.cover,)),
             )
                ,Expanded(
                  child: TextFormField(
             decoration: InputDecoration(labelText: "Enter Image URL"),
             keyboardType:TextInputType.url,
             textInputAction: TextInputAction.done,
             focusNode: _imageUrlFocuseNode,
             controller: _imageUrlController,
             onEditingComplete: () {
    setState(() {});
  },
   onSaved: (val){
            _editedproduct=Product(id: _editedproduct.id,isFavorite: _editedproduct.isFavorite , title: _editedproduct.title, description: _editedproduct.description, 
            price: _editedproduct.price, imageUrl: val);
          },
          validator: (val){
            if(val.isEmpty)
            return "please enter the image URL";
            if(!val.startsWith("http")&&!val.startsWith("https"))
            return "Please enter valid URL";
            if(!val.endsWith(".jpg")&&!val.endsWith(".png")&&!val.endsWith(".jpeg"))
            return "please enter valid image URL";
            return null;
          },
          onFieldSubmitted: (_){
       _saveForm();
          }
 
           ),
                ),
           ],
           ) 
           
         ],
       )
       
       ),
       
    );
  }
}