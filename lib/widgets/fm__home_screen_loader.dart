import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FmHomeScreenLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.grey.shade300,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCard(),
              SizedBox(
                height: 10,
              ),
              _buildText(double.infinity),
              SizedBox(
                height: 10,
              ),
              _buildText(MediaQuery.of(context).size.width / 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        title: Text(''),
        subtitle: Text(''),
      ),
    );
  }

  Widget _buildText(double width) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: 20,
        width: width,
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
