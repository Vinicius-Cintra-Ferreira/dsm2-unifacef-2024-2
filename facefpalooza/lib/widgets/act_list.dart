import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/act.dart';

class ActList extends StatelessWidget {
  const ActList({super.key});

  final data = lineup;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('acts')
            .orderBy('day') // Aplicando a ordenação por dia
            .orderBy('relevance') // Depois por relevância
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var list = snapshot.data?.docs ?? [];

          return ListView(
            children: list.map<Widget>((act) {
              return ListTile(
                title: Text(
                  act['name'] ?? 'Sem nome',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: (act['tags'] as List<dynamic>?)
                          ?.map<Widget>((tag) => Chip(
                                backgroundColor: Colors.deepPurple,
                                label: Text(
                                  "#$tag",
                                ),
                              ))
                          .toList() ??
                      [],
                ),
                trailing: CircleAvatar(
                  child: Text("${act['day']}"),
                ),
              );
            }).toList(),
          );
        });
  }
}
