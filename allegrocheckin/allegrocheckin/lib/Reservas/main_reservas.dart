import 'package:allegrocheckin/Products/products_reservas.dart';
import 'package:allegrocheckin/Reservas/add_reserva.dart';
import 'package:flutter/material.dart';

class Reservation {
  final String name;
  final String date;
  final String domo;

  Reservation({required this.name, required this.date, required this.domo});
}

class ReservationService {
  Future<List<Reservation>> fetchReservations() async {
    // Simulación de un retardo en la respuesta del servicio
    await Future.delayed(Duration(seconds: 2));

    // Datos de ejemplo
    List<Reservation> reservations = [
      Reservation(
          name: 'John Doe',
          date: DateTime.now().toString().substring(0, 10),
          domo: 'Domo 1'),
      Reservation(
          name: 'Jane Smith',
          date: DateTime.now().toString().substring(0, 10),
          domo: 'Domo 2'),
      Reservation(
          name: 'Alice Johnson',
          date: DateTime.now().toString().substring(0, 10),
          domo: 'Domo 3'),
    ];

    return reservations;
  }
}

class ReservationList extends StatefulWidget {
  @override
  _ReservationListState createState() => _ReservationListState();
}

class _ReservationListState extends State<ReservationList> {
  final ReservationService _reservationService = ReservationService();
  late Future<List<Reservation>> _reservationsFuture;

  @override
  void initState() {
    super.initState();
    _reservationsFuture = _reservationService.fetchReservations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddReserve()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Reservation>>(
        future: _reservationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error al cargar los datos'),
            );
          } else if (snapshot.hasData) {
            List<Reservation> reservations = snapshot.data!;
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductList()),
                );
              },
              child: ListView.builder(
                itemCount: reservations.length,
                itemBuilder: (context, index) {
                  Reservation reservation = reservations[index];
                  return ReservationCard(
                    name: reservation.name,
                    date: reservation.date,
                    domo: reservation.domo,
                  );
                },
              ),
            );
          } else {
            return const Center(
              child: Text('No hay datos disponibles'),
            );
          }
        },
      ),
    );
  }
}

class ReservationCard extends StatelessWidget {
  final String name;
  final String date;
  final String domo;

  const ReservationCard({
    Key? key,
    required this.name,
    required this.date,
    required this.domo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        leading: const Icon(Icons.bed),
        title: Text(name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fecha: ${date.toString()}'),
            Text('Domo: $domo'),
          ],
        ),
      ),
    );
  }
}
