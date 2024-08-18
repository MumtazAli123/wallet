// ignore_for_file: prefer_const_constructors , prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:wallet/app/modules/products/controllers/products_controller.dart';

class SportsView extends GetView <ProductsController> {
  const SportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: controller.getProducts('Sports'),

      builder: (context, snapshot){
        if(snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }if(snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }if(snapshot.hasData && snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No products found'));
        }else {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;
              return controller.wBuildProductCard(data);
            },
          );
        }
      },
    );

  }
}
