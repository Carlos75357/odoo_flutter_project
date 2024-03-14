# Proyecto Práctico de Flutter con Odoo

## Objetivo

El objetivo de este proyecto es desarrollar una aplicación móvil en Flutter que se conecte a un servidor de Odoo para
realizar operaciones CRUD (Crear, Leer, Actualizar, Eliminar) sobre registros del modelo "crm.lead". La aplicación
permitirá autenticar usuarios, listar los leads disponibles, crear nuevos leads, ver detalles de un lead específico,
editarlo y eliminar leads existentes.

## Instalación del Entorno

Para comenzar, asegúrate de tener instalado Flutter en tu sistema operativo Linux. Aquí tienes un ejemplo de cómo
hacerlo:

https://docs.flutter.dev/get-started/install/linux

Es conveniente realizar el siguiente codelab para familiarizarse con el entorno de desarrollo de Flutter:

https://codelabs.developers.google.com/codelabs/flutter-codelab-first?hl=es-419#0

Utilizaremos el IDE de desarrollo IntelliJ IDEA (En su versión Community Edition)

https://www.jetbrains.com/es-es/idea/download/?section=linux

## Arquitectura de la Aplicación

Utilizaremos el patrón Clean Architecture para estructurar nuestra aplicación. Esto implica separarla en capas bien
definidas: Data, Domain y UI.

1-Capa de Datos (data): Esta capa manejará la comunicación con el servidor de Odoo a través de peticiones HTTP. Se
utilizará el cliente HTTP de Dart para realizar las operaciones CRUD sobre los registros del modelo "crm.lead". Además,
se establecerá un repositorio para abstraer la lógica de acceso a los datos.

https://pub.dev/packages/http

2-Capa de Dominio (domain): Aquí se definirán los modelos de datos que representan los objetos de negocio de la
aplicación, como el modelo Lead para representar un lead en Odoo.

3-Capa de Interfaz de Usuario (ui): La interfaz de usuario estará organizada en características (features), donde cada
característica representará una pantalla o funcionalidad de la aplicación. Se utilizará el patrón de diseño flutter_bloc
para manejar el estado de la aplicación de forma eficiente y reactiva.

https://pub.dev/packages/flutter_bloc

https://medium.com/@kadriyemacit/login-screen-with-bloc-pattern-9b667a1cbcad

Ejemplo de la estructura en una app de Aures:

<img width="402" alt="image" src="https://github.com/aurestic/flutter_crm_prove/assets/32957956/e5d22705-b15e-42b0-8f5c-a4b1e5193114">


## flutter_bloc

Gestión de Estado con flutter_bloc:

flutter_bloc es una biblioteca que facilita la implementación del patrón de gestión de estado BLoC (Business Logic
Component) en Flutter. Este patrón separa la lógica de presentación (UI) de la lógica de negocio y del estado de la
aplicación. Aquí hay una descripción de los elementos principales del patrón BLoC:

1-Interfaz de Usuario (UI):
En la interfaz de usuario, se presenta al usuario una pantalla de inicio de sesión donde puede ingresar su nombre de
usuario y contraseña. Además, puede haber botones para enviar los datos de inicio de sesión y para navegar a la pantalla
de registro si es necesario.

2-BLoC (Business Logic Component):
El BLoC encargado del inicio de sesión es responsable de manejar la lógica relacionada con la autenticación del usuario.
Cuando el usuario envía sus credenciales de inicio de sesión desde la interfaz de usuario, el BLoC recibe estos eventos
y realiza las operaciones necesarias, como comunicarse con el servidor de autenticación y verificar las credenciales del
usuario.

3-Estados:
Durante el proceso de inicio de sesión, la aplicación puede pasar por varios estados diferentes. Por ejemplo, puede
haber un estado de "Cargando" mientras se procesa la solicitud de inicio de sesión, un estado de "Éxito" si las
credenciales son válidas y el usuario se autentica correctamente, o un estado de "Error" si se produce algún problema
durante el proceso de inicio de sesión, como credenciales incorrectas o problemas de conexión con el servidor.

4-Eventos:
Los eventos representan las acciones que el usuario realiza en la interfaz de usuario que desencadenan cambios en el
estado del BLoC. Por ejemplo, un evento de "Inicio de Sesión" se desencadena cuando el usuario presiona el botón de
inicio de sesión después de ingresar sus credenciales.

## API de Odoo

https://www.odoo.com/documentation/15.0/es/developer/howtos/web_services.html#json-rpc-library

Se utilizará la API JSON-RPC proporcionada por Odoo para interactuar con el servidor. Los principales métodos que se
emplearán son:

-authenticate: Autentica al usuario en Odoo y devuelve un token de sesión.
-search_read: Realiza una búsqueda de registros según un dominio y devuelve los registros encontrados.
-read: Lee los valores de un registro específico.
-unlink: Elimina un registro específico.
-write: Actualiza los valores de un registro específico.

Ejemplo de petición a Odoo en flutter (Concretamente el método de autenticación):

![image](https://github.com/aurestic/flutter_crm_prove/assets/32957956/52d26aeb-fab4-43b8-923e-970f88f76d24)


## Implementación de Funcionalidades

-Autenticación:
La aplicación permitirá al usuario iniciar sesión en el servidor de Odoo utilizando su nombre de usuario
y contraseña.

<img width="1509" alt="image" src="https://github.com/aurestic/flutter_crm_prove/assets/32957956/a37291c0-2fc5-4bf5-90c9-9f529a7a4f0e">

-Listado de Leads:
Al hacer login se redirigirá a una pantalla que mostrará una lista de todos los leads disponibles en el servidor.

<img width="784" alt="image" src="https://github.com/aurestic/flutter_crm_prove/assets/32957956/7dd83d57-f96b-4e0a-8c33-1c0cedecb63f">

-Creación de Leads:
Los usuarios podrán crear nuevos leads proporcionando los detalles necesarios, a través de un fab en la parte inferior derecha del listado anterior.

<img width="849" alt="image" src="https://github.com/aurestic/flutter_crm_prove/assets/32957956/eca02d43-ac28-4517-81da-c7df12e0755e">

-Detalle de Lead: 
Al seleccionar un lead de la lista, se mostrarán sus detalles, como nombre de la oportunidad, correo
electrónico, ingreso esperado, prioridad, etc. A su vez, dentro del modo detalle, en el la AppBar, habrá un botón de
editar, que habilitará los campos de edición y podrá realizar cambios para posteriormente almacenarlos en el backend, a
través de un botón de guardado también alojado en la AppBar.

<img width="1509" alt="image" src="https://github.com/aurestic/flutter_crm_prove/assets/32957956/8030f13d-9e1f-4fe3-a5e1-643f2378fdcb">

-Eliminación de Leads: 
Los usuarios podrán eliminar leads existentes desde la AppBar de la pantalla del detalle.

<img width="1509" alt="image" src="https://github.com/aurestic/flutter_crm_prove/assets/32957956/1af208bf-e54f-4a4d-93ea-87621e2fe586">


## Diseño

Puedes basarte en este ejemplo, o crear el tuyo propio:

<img width="366" alt="login" src="https://github.com/aurestic/flutter_crm_prove/assets/32957956/ee821f17-f9a6-43b8-aad5-f5effa141da8">

<img width="366" alt="lista_oportunidades" src="https://github.com/aurestic/flutter_crm_prove/assets/32957956/9b02ef77-345e-41f9-ad1d-7bb4980dfe0c">

<img width="366" alt="crear_oportunidad" src="https://github.com/aurestic/flutter_crm_prove/assets/32957956/6e17ed85-61cd-4263-890d-d111f128b97c">


## Datos de acceso

---------------------------------------

URL: https://demos15.aurestic.com

DB: demos_demos15

USERNAME: admin

PASSWORD: admin

---------------------------------------

-Url para listar los leads:

https://demos15.aurestic.com/web?debug=1#cids=1&menu_id=381&action=558&model=crm.lead&view_type=kanban

-Modelo del lead (crm.lead):

https://demos15.aurestic.com/web?debug=1#id=804&cids=1&menu_id=4&action=18&model=ir.model&view_type=form

## Flujo de trabajo

El flujo de trabajo con pull requests es una práctica común en el desarrollo colaborativo de software que permite una
revisión y colaboración efectiva entre los miembros del equipo. Aquí te explico cómo podríamos organizar el trabajo
utilizando pull requests:

-División en Subtareas:
Dividiremos el proyecto en subtareas más pequeñas y manejables. Por ejemplo, podríamos dividir las funcionalidades
solicitadas (autenticación, listado de leads, creación de leads, etc.) en subtareas individuales.

-Asignación de Tareas:
Asignaremos cada subtarea a un miembro del equipo. Cada miembro será responsable de completar su tarea asignada de
manera independiente.

-Creación de Branches:
Para cada subtarea, el desarrollador creará una nueva rama (branch) en el repositorio de Git. Esta rama estará basada en
la rama principal (por ejemplo, main o master).

-Desarrollo y Commit:
El desarrollador trabajará en su rama localmente, implementando la funcionalidad requerida. A medida que avance,
realizará commits frecuentes con mensajes descriptivos que expliquen los cambios realizados.

-Pull Request:
Una vez que la funcionalidad esté completa y probada localmente, el desarrollador abrirá una pull request desde su rama
hacia la rama principal del repositorio. En la pull request, proporcionará una descripción detallada de los cambios
realizados y de la funcionalidad implementada.

-Revisión y Comentarios:
Los demás miembros del equipo revisarán la pull request, analizando el código y proporcionando comentarios y sugerencias
para mejorarlo si es necesario. Se puede discutir y debatir sobre los cambios propuestos en la sección de comentarios de
la pull request.

-Iteración y Mejora:
El desarrollador realizará cambios adicionales según los comentarios recibidos. Este proceso de revisión y iteración
continuará hasta que la pull request sea aprobada por todos los revisores.

-Merge:
Una vez que la pull request haya sido aprobada y todos los problemas hayan sido resueltos, se procederá a fusionar (
merge) los cambios en la rama principal del repositorio.

## Buenas Prácticas en Flutter

-Codificación en Inglés:
Es una buena práctica escribir el código y los comentarios en inglés para mantener la consistencia y facilitar la
colaboración con desarrolladores de todo el mundo.

-Convención de Nombres:
Sigue las convenciones de nombres de Dart y Flutter para variables, funciones, clases, etc. Utiliza nombres descriptivos
y significativos para mejorar la legibilidad del código.

-Organización del Código:
Estructura tu código de manera lógica y coherente. Utiliza carpetas y archivos para organizar los diferentes componentes
de tu aplicación, como modelos, vistas, controladores, etc.

-Documentación:
Documenta tu código utilizando comentarios claros y concisos para explicar la funcionalidad y el propósito de cada
componente. Esto facilita la comprensión del código para otros desarrolladores y para ti mismo en el futuro.

-Pruebas Unitarias y de Integración:
Implementa pruebas unitarias y de integración para verificar el correcto funcionamiento de tu código. Las pruebas
automatizadas son fundamentales para garantizar la calidad y estabilidad de tu aplicación.

https://docs.flutter.dev/cookbook/testing/unit/introduction

-Versionado y Control de Versiones:
Utiliza un sistema de control de versiones como Git para administrar el código fuente de tu proyecto. Realiza commits
frecuentes y descriptivos para mantener un historial claro de los cambios realizados.

-Seguridad:
Ten en cuenta las consideraciones de seguridad al manejar datos sensibles, como contraseñas de usuario. Utiliza técnicas
de cifrado y almacenamiento seguro para proteger la información del usuario.

https://pub.dev/packages/flutter_secure_storage


