
# Front Flutter App

Repositorio para el codigo fuente del front de la aplicación movil

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)


### TODO 📃
- Entidades, Repositorios, Datasource.
- Formularios crud.
- Dashboard.
- Vista de calendario.

## Algunas Consideraciónes ✏️

La arquitectura de la aplicación está basada en capas, implementando principios solid en lo esencial. También maneja algunos patrones como el Repository y Datasource. Y patrones de diseño como DDD. **No es completamente estricto**

Todo está manejado por capas, y todas las capas tienen una archivo barril para exportar mejor las funciones:

- Lib:
    - Config: _Archivos de configuración, constantes, router, configuración del tema, etc._
    - features: _Son las caracteristicas que tiene la aplicación_
        - fueature: _Ejemplo: Clientes_
            - presentation: _Capa de presentación, se maneja todo lo visual y su lógica_
                - screens: _Pantallas_
                - provider: _O cualquier manejador de estado_
                - widgets: _Widgets abstraidos usados para esta feature_
            - infraestructure: _Todo lo que tiene que ver con el manejo de la data_
                - datasources: _Implementaciones de los datasource_
                - repositories: _Implementaciones de los repository_
                - errors, mappers, etc: _Todo que permite manejar datos de forma limipia_
            - domain: _Acá va toda la lógica de negocio, casos de uso etc._
                - datasources: _definicion de las reglas de la data_
                - repositories: _definicion de la fuente de la data_
        - shared: _acá se pone todo lo que se comparta entre las caracteristicas de la app_

**Nota:** Se divide en caracteristicas porque al momento de hacer los tests escala mejor que los test se hagan por caracteristica.

**Nota:** El datasource y repository me dan la ventaja de que puedo hacer una aplicación agonostica a la fuente de datos, esta fuente puede ser local o un servicio REST, o lo que sea. _Siempre voy a manejar la data en mi aplicacion con mis mapper y mis entidades_

**Nota:** El mapper es diferente del entity, el entity es el objeto que uso en la aplicacion, el mapper es el que estudia la respuesta a la petición o la data que llega y la convierte al entity que necesito en mi app.
## Features

- Log In y Registro
- Manejo de roles y permisos.
- Vista de calendario

