
# Pomodoro Personalizado

Aplicación Flutter para la gestión personalizada de sesiones Pomodoro, diseñada para maximizar la productividad y el enfoque mediante ciclos configurables, estadísticas y categorización de actividades.

## Características principales
- Gestión de categorías personalizadas (trabajo, estudio, descanso, etc.).
- Registro y seguimiento de sesiones Pomodoro.
- Visualización de ciclos y estadísticas de productividad.
- Persistencia local de datos usando Hive.
- Modo enfoque con wakelock para mantener la pantalla activa.
- Gráficas interactivas de progreso.

## Instalación
1. Clona el repositorio:
	```sh
	git clone https://github.com/zzzvicczzz/pomodoro_personalizado.git
	```
2. Accede al directorio del proyecto:
	```sh
	cd pomodoro_personalizado
	```
3. Instala las dependencias:
	```sh
	flutter pub get
	```
4. Ejecuta la aplicación:
	```sh
	flutter run
	```

## Estructura del proyecto

```
lib/
  main.dart                # Punto de entrada principal
  config/                  # Configuración global y constantes
  models/                  # Modelos de datos (Category, Session, Cycle, Stats)
  managers/                # Lógica de negocio y controladores
  providers/               # Gestión de estado
  repositories/            # Acceso y gestión de datos
  screens/                 # Pantallas y widgets principales
  services/                # Servicios (persistencia, notificaciones, sonido)
docs/
  architecture.md          # Documentación de arquitectura
  development_plan.md      # Roadmap técnico y plan de desarrollo
  MVP_TECNICO.md           # Definición de MVP técnico
  PRD.MD                   # Documento de requerimientos
  progress/                # Informes de avance por tarea
```

## Requisitos
- Flutter 3.9.2 o superior
- Dart SDK compatible
- Android Studio o VS Code recomendado para desarrollo

## Contribución
Este proyecto sigue una metodología incremental y modular. Si deseas contribuir, revisa el plan de desarrollo en `docs/development_plan.md` y sigue las convenciones de commits y documentación.

## Licencia
Este proyecto es de uso personal y educativo. Puedes modificarlo y adaptarlo según tus necesidades.
