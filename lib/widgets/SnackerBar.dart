import 'package:flutter/material.dart';

successSnackBar(context) {
  const snackBar = SnackBar(
    content: Text('Saved Successfully'),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

failedSnackBar(context) {
  const snackBar = SnackBar(
    content: Text('Failed to update'),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

noUpdateSnackBar(context) {
  const snackBar = SnackBar(
    content: Text('You are not able to update this field'),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
