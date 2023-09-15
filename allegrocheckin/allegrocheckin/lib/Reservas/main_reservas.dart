import 'package:allegrocheckin/Products/products_reservas.dart';
import 'package:allegrocheckin/Reservas/add_reserva.dart';
import 'package:allegrocheckin/Service/ReserveService.dart';
import 'package:allegrocheckin/models/commandresult_model.dart';
import 'package:allegrocheckin/models/estadias.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';

class Reservation {
  final String name;
  final String date;
  final String domo;

  Reservation({required this.name, required this.date, required this.domo});
}

List<Estadia> EstadiasResult = [];

class ReservationList extends StatefulWidget {
  const ReservationList({super.key});
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
      body: FutureBuilder<List<Estadia>>(
        future: fetchEstadias(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error al cargar los datos'),
            );
          } else if (snapshot.data!.isNotEmpty) {
            List<Estadia> reservations = snapshot.data ?? [];
            return ListView.builder(
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                Estadia reservation = reservations[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: GestureDetector(
                    onTap: () async {
                      var r = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductList(
                                  estadia: reservation,
                                )),
                      );
                      if (r ?? false) {
                        setState(() {
                          var i = 1;
                        });
                      }
                    },
                    child: ListTile(
                        tileColor: reservation.estado == "ACTIVO"
                            ? Color.fromARGB(255, 178, 248, 182)
                            : Color.fromARGB(255, 249, 200, 200),
                        leading: const Icon(Icons.bed),
                        title: Text(reservation.nombre),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Id: ${reservation.id}'),
                            Text(
                                'Fecha: ${reservation.fecha.toString().substring(0, 10)}'),
                            Text('Domo: ${reservation.domo}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            if (await confirm(context,
                                title: const Text("Allegro Glamping"),
                                content: const Text(
                                    "¿Está seguro que desea eliminar la reserva?"))) {
                              await ReserveService()
                                  .deleteEstadias(reservation.id);
                              setState(() {
                                var i = 1;
                              });
                            }
                            return;
                          },
                        )),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text('No hay reservas activas'),
            );
          }
        },
      ),
    );
  }
}

Future<List<Estadia>> fetchEstadias() async {
  CommandResult result = await ReserveService().getEstadias();
  var data = result.data;
  var estadias = Estadia.parseMyDataList(data);
  return estadias;
}
