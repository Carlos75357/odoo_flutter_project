import 'package:flutter/material.dart';

class CrmDetail extends StatefulWidget {
  final int leadId;

  const CrmDetail({Key? key, required this.leadId}) : super(key: key);

  @override
  State<CrmDetail> createState() => _CrmDetailState();
}

class _CrmDetailState extends State<CrmDetail> {

  @override
  Widget build(BuildContext context) {
    // TODO: Implementar Pantalla de detalle de la Oportunidad.
    // TODO: Crear clase de estados, eventos y bloc, para enlazar con la vista utilizando flutter_bloc. Revisar ejemplos.
    return Container(
        color: Colors.white,
        child: Center(
            child: Text('Crm Detail ${widget.leadId}'),
        ),
    );
  }
}
