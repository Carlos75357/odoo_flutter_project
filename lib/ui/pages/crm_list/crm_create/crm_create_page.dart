import 'package:flutter/material.dart';

class CrmCreatePage extends StatefulWidget {
  const CrmCreatePage({Key? key}) : super(key: key);

  @override
  _CrmCreatePageState createState() => _CrmCreatePageState();
}

class _CrmCreatePageState extends State<CrmCreatePage> {
  // Define los controladores de texto para los campos del formulario
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Variable para almacenar la fecha de creación
  late DateTime _creationDate;

  // Variable para almacenar la etapa seleccionada
  String _selectedStage = '';

  // Variable para almacenar los tags seleccionados
  List<String> _selectedTags = [];

  // Variable para almacenar el cliente seleccionado
  String _selectedClient = '';

  // Variable para almacenar el equipo seleccionado
  String _selectedTeam = '';

  // Variable para almacenar el ingreso esperado
  String _expectedIncome = '';

  // Función para manejar la acción de guardar
  void _saveLead() {
    // Aquí puedes implementar la lógica para guardar el nuevo lead
    // Puedes obtener los valores de los campos utilizando los controladores de texto y las variables seleccionadas
    String name = _nameController.text;
    String email = _emailController.text;
    String phone = _phoneController.text;

    // Lógica para guardar el lead
  }

  @override
  void initState() {
    super.initState();
    // Inicializar la fecha de creación con la fecha actual
    _creationDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Nuevo Lead'),
        backgroundColor: Colors.purpleAccent.shade400,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nombre del Lead:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Ingrese el nombre del lead',
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Correo electrónico:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Correo electrónico',
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Teléfono:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Teléfono',
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Fecha de Creación:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              _creationDate.toString(), // Mostrar la fecha actual
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Etapa:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // Aquí puedes agregar un menú desplegable para seleccionar la etapa
            // Ejemplo: DropdownButton<String>(
            //   value: _selectedStage,
            //   onChanged: (newValue) {
            //     setState(() {
            //       _selectedStage = newValue!;
            //     });
            //   },
            //   items: [...], // Lista de opciones de etapas
            // ),
            SizedBox(height: 20),
            // Agrega los otros campos según tus requisitos
            // Por ejemplo: Cliente, Equipo, Ingreso Esperado, Tags, etc.
            // Recuerda usar diferentes tipos de campos según corresponda:
            // DropdownButton, TextField, etc.
            Center(
              child: ElevatedButton(
                onPressed: _saveLead,
                child: Text('Guardar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String title, TextEditingController controller, String type) {
    Widget fieldWidget;

    switch (type) {
      case 'Text':
        fieldWidget = _buildTextField(controller, title);
        break;
      case 'Date':
        fieldWidget = _buildDatePickerField(controller, title);
        break;
      case 'Tags' || 'Client' || 'Company' || 'User' || 'Stage':
        fieldWidget = _buildDropDownField(controller, type);
        break;
      default:
        fieldWidget = _buildTextField(controller, title);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        fieldWidget,
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String title) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: title,
      ),
    );
  }

  Widget _buildDropDownField(TextEditingController controller, String tittle) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.purpleAccent[400]!,
          width: 1,
        )
      )
    );
  }

  Widget _buildDatePickerField(TextEditingController controller, String tittle) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.purpleAccent[400]!,
        )
      )
    );
  }
}
