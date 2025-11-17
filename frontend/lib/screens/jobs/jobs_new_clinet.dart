import 'package:flutter/material.dart';

class NewClientPage extends StatelessWidget {
  const NewClientPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
	return Scaffold(
	  appBar: AppBar(
		title: const Text('New Client Title'),
	  ),
	  body: Padding(
		padding: const EdgeInsets.all(16.0),
		child: ListView(
		  children: [
			const Text(
			  'Job Postings',
			  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
			),
			const SizedBox(height: 16),
			TextFormField(
			  decoration: const InputDecoration(
				labelText: 'Name of Organisation',
			  ),
			),
			const SizedBox(height: 16),
			TextFormField(
			  decoration: const InputDecoration(
				labelText: 'Reg ID',
			  ),
			),
			const SizedBox(height: 16),
			TextFormField(
			  decoration: const InputDecoration(
				labelText: 'GST ID',
			  ),
			),
			const SizedBox(height: 16),
			TextFormField(
			  decoration: const InputDecoration(
				labelText: 'Branch Name',
			  ),
			),
		  ],
		),
	  ),
	);
  }
}
