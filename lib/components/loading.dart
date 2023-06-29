import 'package:flutter/material.dart';

Widget loadingCircularProgressIndicator({String title = "Tunggu sebentar..."}) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 25,
            width: 25,
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
