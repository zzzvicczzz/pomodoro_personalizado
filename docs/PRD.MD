# Documento de Requerimientos del Producto (PRD)
## Nombre del Proyecto
Pomodoro Personalizado

## Descripción General
Aplicación móvil desarrollada en Flutter/Dart, basada en la técnica Pomodoro, orientada al estudio personal. Permite organizar sesiones de estudio y descanso, personalizar categorías de estudio, visualizar estadísticas y gestionar el tiempo dedicado a cada área de interés. La app es de uso privado, sin integración con servidores ni micropagos.

## Objetivo
Facilitar la gestión y optimización del tiempo de estudio mediante la técnica Pomodoro, permitiendo al usuario personalizar sus sesiones y analizar el tiempo invertido en distintas áreas de aprendizaje.

## Público Objetivo
Usuario único (personal), orientado a la autogestión del tiempo de estudio en su dispositivo móvil. La app está diseñada exclusivamente para uso privado y no será distribuida ni compartida.

## Características Principales

- El usuario puede iniciar sesiones de estudio y descanso siguiendo la técnica Pomodoro (ejemplo: 25 minutos de estudio, 5 minutos de descanso).
- Diferenciación clara entre sesión y ciclo: una sesión es un bloque de estudio o descanso, mientras que un ciclo Pomodoro puede contener varias sesiones de estudio y descansos cortos/largos. La app permite configurar ciclos, pero el avance entre sesiones/ciclos es manual, nunca automático.
- Los tiempos de estudio y descanso son completamente personalizables, tanto para sesiones cortas como largas. La app no impone ningún ciclo ni duración; el usuario decide cómo configurar sus tiempos.
- Antes de iniciar cada sesión, el usuario debe seleccionar la categoría de estudio.
- Se permite configurar ciclos Pomodoro compuestos (ejemplo: 4 sesiones de estudio seguidas de un descanso largo), pero el avance entre sesiones no es automático; el usuario decide cuándo iniciar cada sesión.
- Al finalizar cada Pomodoro, la app emite una alarma sonora para indicar el inicio del descanso y una alarma diferente para indicar el inicio del estudio.
- Modo rápido / “modo instantáneo”: el usuario puede iniciar una sesión Pomodoro rápida usando la última configuración o un valor por defecto, sin necesidad de configurar nada.
- Campo opcional de registro textual (“Notas del Pomodoro”) para que el usuario anote qué hizo en cada sesión, visible en las estadísticas.
- Modo enfoque opcional: la app puede mantener la pantalla encendida durante la sesión de estudio para evitar distracciones.

### 2. Creación y Personalización de Categorías
- El usuario puede crear, editar y eliminar categorías de estudio (ejemplo: Matemáticas, Programación, Lectura, etc.).
- Cada categoría puede tener un nombre y un color personalizado.
- No hay límite en la cantidad de categorías que se pueden crear.

- Visualización de estadísticas sobre el tiempo dedicado a cada categoría.
- Gráficas de barras, pastel y líneas dinámicas/interactivas para mostrar la distribución del tiempo de estudio por categoría y por periodo (diario, semanal, mensual, anual).
- Visualización de sesiones completadas y tiempo total de estudio.
- No se permite exportar estadísticas fuera de la app; los informes son solo para consulta interna del usuario.
- Informes detallados sobre qué categorías fueron más y menos estudiadas en los distintos periodos.
- Modo resumen: al finalizar cada sesión, se muestra una vista con el tiempo total acumulado y las categorías más activas del día.

- Interfaz intuitiva y minimalista, enfocada en la facilidad de uso y la personalización.
- No incluye gestión de tareas ni subtareas, solo sesiones de estudio categorizadas.
- No requiere registro, inicio de sesión ni conexión a internet.
- No incluye publicidad ni micropagos.
- No incluye modo oscuro ni temas visuales; la interfaz será sencilla y funcional.
- Esquema de color base: amarillo pastel suave, transmitiendo calma y concentración.

- Desarrollada en Flutter/Dart para dispositivos Android.
- Almacenamiento local de datos persistente (preferiblemente usando SQLite, Hive o similar), asegurando que los datos y estadísticas se conservan incluso tras cerrar la app.
- Soporte para notificaciones locales de todo tipo: sonoras, visuales y vibración (inicio/fin de sesión, recordatorios, alarmas). Las notificaciones deben funcionar tanto en primer plano como en segundo plano, según los permisos de Android y Flutter.
- Configuración de sonidos personalizados: el usuario puede elegir el sonido de las alarmas desde una lista corta o usar sonidos del sistema.

## Flujo de Usuario
1. El usuario abre la app y accede a la pantalla principal.
2. Puede crear y personalizar categorías de estudio.
3. Antes de iniciar una sesión, selecciona la categoría correspondiente.
4. Configura los tiempos de estudio y descanso según su preferencia, incluyendo ciclos compuestos si lo desea.
5. Puede iniciar una sesión rápida con la última configuración o valores por defecto.
6. Inicia la sesión Pomodoro; la app gestiona los temporizadores y notifica los cambios de fase mediante alarmas sonoras, visuales y vibración. Puede activar el modo enfoque para mantener la pantalla encendida.
7. Al finalizar la sesión, los datos se almacenan de forma persistente y se actualizan las estadísticas. El usuario puede añadir una nota opcional sobre la sesión.
8. El usuario puede consultar las estadísticas en cualquier momento, visualizando gráficas dinámicas/interactivas y reportes internos.
9. Al finalizar cada sesión, se muestra un resumen con el tiempo total acumulado y las categorías más activas del día.
10. Los temporizadores solo son visibles en la pantalla principal.



## Exclusiones
- No se implementará sincronización en la nube ni acceso multiusuario.
- No se incluirán tareas, subtareas ni gestión de pendientes.
- No habrá integración con servicios externos ni publicidad.

## Criterios de Éxito
- El usuario puede personalizar completamente sus sesiones y categorías.
- La app registra y muestra estadísticas claras y útiles.
- La experiencia es fluida, privada y sin distracciones.
