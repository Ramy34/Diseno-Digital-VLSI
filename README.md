# Diseno-Digital-VLSI
Repositorio de la clase de Diseño Digital VLSI.

Este repositorio contiene tutoriales y prácticas orientadas al diseño de circuitos digitales utilizando FPGAs libres (específicamente la placa **Lattice iCEstick**) y herramientas Open Source.

## Herramientas Necesarias
Para la simulación, síntesis y carga de los diseños, se utilizan las siguientes herramientas:
* **Icarus Verilog**: Para la compilación y simulación del código.
* **GTKWave**: Para la visualización de formas de onda y resultados gráficos de la simulación.
* **Project IceStorm / iceprog**: Herramientas libres para la síntesis de hardware y volcado del bitstream a la FPGA iCEstick.
* **Make**: Para la automatización del flujo de construcción y pruebas.
* **Python**: Utilizado para la generación automática de tablas de constantes en Verilog (por ejemplo, los divisores para reproducir notas musicales).
* **PlatformIO** (Opcional): Entorno de desarrollo compatible con la plataforma Lattice iCE40.

## Índice de Proyectos y Prácticas
Basado en el material de los tutoriales incluidos (`tutorial/ICESTICK/`), el repositorio aborda los siguientes componentes y módulos:

* **T01-setbit**: "Hola mundo" en hardware. Fija un pin de salida a '1' para encender de forma continua un LED (D1).
* **T02-Fport**: Módulo para sacar un dato fijo de 4 bits por los LEDs (por defecto envía el dato `1010` para encender D2 y D4).
* **T07-contador-prescaler**: Implementación de un contador de 4 bits que incluye un prescaler.
* **T11-mux-2-1**: Ejemplo de uso de un multiplexor de 2 a 1 para generar una secuencia de dos estados en los LEDs.
* **T12-mux-4-1**: Ejemplo de uso de un multiplexor de 4 a 1 para secuencias de cuatro estados.
* **T14-regreset**: Implementación de un registro de N bits con señal de reset síncrono.
* **T15-divisor**: Divisor de frecuencias genérico (incluye ejemplos de división entre 3 y entre M) para ralentizar señales, como hacer parpadear un LED a 1 Hz.
* **T18-notas / T27-rom-param**: Scripts en Python (`notas_gen.py`) que calculan frecuencias y divisores de reloj para reproducir las 12 notas musicales en distintas octavas, generando el código Verilog correspondiente.

## Comandos Generales (Flujo de Trabajo)
La mayoría de los proyectos están configurados para compilarse y ejecutarse a través de un `Makefile`.

### Simulación
Para simular un diseño, entra en el directorio de la práctica correspondiente y ejecuta:
```bash
make sim
```
Automáticamente se invocará a *Icarus Verilog* para la simulación y se abrirá *GTKWave* para inspeccionar las señales gráficamente.

### Síntesis y Carga a la FPGA
Para generar el archivo `.bin` que contiene la configuración del circuito digital y cargarlo en la iCEstick, ejecuta:
```bash
make sint
sudo iceprog <nombre_del_proyecto>.bin
```
