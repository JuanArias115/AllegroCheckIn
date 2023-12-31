import 'package:allegrocheckin/Service/ReserveService.dart';
import 'package:allegrocheckin/components/AppBarComponent.dart';
import 'package:allegrocheckin/models/estadias.dart';
import 'package:flutter/material.dart';

class AddReserve extends StatefulWidget {
  @override
  _AddReserveState createState() => _AddReserveState();
}

class _AddReserveState extends State<AddReserve> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _nombre = '';
  String _domo = 'Refugio Del Arbol';
  DateTime _checkIn = DateTime.now();
  int _abono = 0;

  List<String> _domos = [
    'Refugio Del Arbol',
    'Arrullo Del Río',
  ];

  Future<void> _submitForm() async {
    Estadia estadia = Estadia(
        id: "0",
        nombre: _nombre,
        domo: _domo,
        fecha: DateTime.now().toString().substring(0, 10),
        abono: _abono.toString(),
        estado: "ACTIVO");

    var res = await ReserveService().addReserva(estadia);

    Navigator.of(context).pop(res);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponents(),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Card(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  contentPadding: EdgeInsets.all(16.0),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa tu nombre';
                  }
                  return null;
                },
                onChanged: (value) {
                  _nombre = value;
                },
              ),
            ),
            Card(
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Domo',
                  contentPadding: EdgeInsets.all(16.0),
                ),
                value: _domo,
                items: _domos.map((domo) {
                  return DropdownMenuItem<String>(
                    value: domo,
                    child: Text(domo),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _domo = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecciona un domo';
                  }
                  return null;
                },
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Check-In'),
                subtitle: Text(_checkIn.toString().substring(0, 10)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _checkIn,
                    firstDate: DateTime(2021),
                    lastDate: DateTime(2024),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _checkIn = pickedDate;
                    });
                  }
                },
              ),
            ),
            Card(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Abono',
                  contentPadding: EdgeInsets.all(16.0),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el abono';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Ingresa un valor numérico válido';
                  }
                  return null;
                },
                onChanged: (value) {
                  _abono = int.parse(value);
                },
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
              ),
              child: Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }
}
