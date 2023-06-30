import 'package:allegrocheckin/Products/products_reservas.dart';
import 'package:allegrocheckin/Reservas/add_reserva.dart';
import 'package:allegrocheckin/Service/ReserveService.dart';
import 'package:allegrocheckin/models/commandresult_model.dart';
import 'package:allegrocheckin/models/estadias.dart';
import 'package:flutter/material.dart';

class Reservation {
  final String name;
  final String date;
  final String domo;

  Reservation({required this.name, required this.date, required this.domo});
}

class ReservationList extends StatefulWidget {
  @override
  _ReservationListState createState() => _ReservationListState();
}

class _ReservationListState extends State<ReservationList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var r = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddReserve()),
          );
          setState(() {
            var i = 1;
          });
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<CommandResult>(
        future: ReserveService().getEstadias(),
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
            List<Estadia> reservations =
                Estadia.parseMyDataList(snapshot.data!.data);
            return ListView.builder(
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                Estadia reservation = reservations[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductList(
                                  id: reservation.id,
                                )),
                      );
                    },
                    child: ListTile(
                        leading: const Icon(Icons.bed),
                        title: Text(reservation.nombre),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Fecha: ${reservation.fecha.toString()}'),
                            Text('Domo: ${reservation.domo}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            var res = await ReserveService()
                                .deleteEstadias(reservation.id);
                            setState(() {
                              var i = 1;
                            });
                          },
                        )),
                  ),
                );
                ;
              },
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
