// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallet/app/modules/products/controllers/products_controller.dart';
import 'package:wallet/models/products_model.dart';

import '../../register/controllers/register_controller.dart';

class ProductsEditView extends StatefulWidget {
  final ProductsModel model;
  const ProductsEditView({super.key, required this.model});

  @override
  State<ProductsEditView> createState() => _ProductsEditViewState();
}

class _ProductsEditViewState extends State<ProductsEditView> {
  final controller = Get.put(ProductsController());
  final controller1 = Get.put(RegisterController());




  var hintText = 'Email';

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.model.pName}'),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: controller.pNameController,
                  inputFormatters: [
                    controller1.upperCaseTextFormatter,
                  ],
                  onChanged: (value) {
                    setState(() {
                      widget.model.pName = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Product Name',
                    hintText: '${widget.model.pName}',
                    prefixIcon: Icon(Icons.production_quantity_limits),

      
                  ),
                ),
              ),
              // price
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: controller.pPriceController,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      widget.model.pPrice = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Price',
                    hintText: '${widget.model.pPrice}',
                    prefixIcon: Icon(Icons.money),
                  ),
                ),
              ),
              // discount type
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: 'Discount Type',
                    hintText: 'Discount Type: ${widget.model.pDiscountType}',
                    prefixIcon: const Icon(Icons.money_off),
                  ),
                  value: widget.model.pDiscountType,
                  items: controller.pDiscountTypeList.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      widget.model.pDiscountType = value.toString();
                    });
                  },
                ),
              ),
              // discount
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: controller.pDiscountController,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      widget.model.pDiscount = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Discount',
                    hintText: 'Discount: ${widget.model.pDiscount}',
                    prefixIcon: Icon(Icons.money_off_csred_outlined),
                  ),
                ),
              ),
              // description
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: controller.pDescriptionController,
                  onChanged: (value) {
                    setState(() {
                      widget.model.pDescription = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Description',
                    hintText: '${widget.model.pDescription}',
                    prefixIcon: Icon(Icons.description),
                  ),
                ),
              ),
              // category
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: 'Products Category',
                    hintText: 'Category: ${widget.model.pCategory}',
                    prefixIcon: const Icon(Icons.category),
                  ),
                  value: widget.model.pCategory,
                  items: controller.pCategoryList.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      widget.model.pCategory = value.toString();
                    });
                  },
                ),
              ),
              // color
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: 'Products Color',
                    hintText: 'Color: ${widget.model.pColor}',
                    prefixIcon: const Icon(Icons.color_lens),
                  ),
                  value: widget.model.pColor,
                  items: controller.pColorList.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      widget.model.pColor = value.toString();
                    });
                  },
                ),
              ),
              // size
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: 'Products Size',
                    hintText: 'Size: ${widget.model.pSize}',
                    prefixIcon: const Icon(Icons.format_size),
                  ),
                  value: widget.model.pSize,
                  items: controller.pSizeList.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      widget.model.pSize = value.toString();
                    });
                  },
                ),
              ),
              // stock
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: controller.pQuantityController,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      widget.model.pQuantity = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Stock',
                    hintText: 'Stock: ${widget.model.pQuantity}',
                    prefixIcon: Icon(Icons.inventory),
                  ),
                ),
              ),
      
      
             SizedBox(height: 20.0),
              _buildButton(),
            ],
          ),
        ),
      ),
    );
  }
  _buildButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GFButton(
        size: GFSize.LARGE,
        hoverColor: Colors.green,
        highlightElevation: 81,
        onPressed: () {

          controller.editProducts(widget.model);
          // Get.back();
        },
        text: 'Update',
        textStyle: GoogleFonts.roboto(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        color: Colors.green,
      ),
    );
  }

}
