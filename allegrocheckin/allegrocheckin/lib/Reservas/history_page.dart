import 'package:allegrocheckin/Products/products_reservas.dart';
import 'package:allegrocheckin/Reservas/add_reserva.dart';
import 'package:allegrocheckin/Service/ReserveService.dart';
import 'package:allegrocheckin/models/commandresult_model.dart';
import 'package:allegrocheckin/models/estadias.dart';
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
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
        future: ReserveService().getHistory(),
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
                          : Color.fromARGB(255, 230, 234, 240),
                      leading: const Icon(Icons.bed),
                      title: Text(reservation.nombre),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              'Fecha: ${reservation.fecha.toString().substring(0, 10)}'),
                          Text('Domo: ${reservation.domo}'),
                        ],
                      ),
                      //  IconButton(
                      //   icon: Icon(Icons.delete, color: Colors.red),
                      //   onPressed: () async {
                      //     if (await confirm(
                      //       context,
                      //       title: const Text('Eliminar'),
                      //       content: const Text(
                      //           'Estas seguro que deseas continuar?'),
                      //       textOK: const Text('Si'),
                      //       textCancel: const Text('No'),
                      //     )) {
                      //       var res = await ReserveService()
                      //           .deleteEstadias(reservation.id);
                      //       setState(() {
                      //         var i = 1;
                      //       });
                      //     }
                      //     return print('pressedCancel');
                      //   },
                      // )
                    ),
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
