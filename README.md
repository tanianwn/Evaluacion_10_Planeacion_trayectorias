
# Evaluacion_10_Planeacion_trayectorias

En este repositorio se genera la planeación de trayectorias de un robot móvil de accionamiento diferencial para que su recorrido dibuje el rostro de mi persona. Para lograrlo, se extrajeron coordenadas específicas a partir de una imagen de referencia y se implementó un algoritmo de control para que el robot siguiera la ruta con la mayor presicion posible a los rasgos físicos (ojos, boca, cara, labios, cabello, etc.).

---

## 1. Obtención waypoints
Para garantizar que la trayectoria capturara a la perfección la forma del rostro, se desarrolló un script personalizado en MATLAB, esto debido a que GEOGEBRA tenía complicaciones para marcar todos los puntos de la imegen y extraerlos. 

* **Mapeo en vivo:** El script permite cargar la imagen original y dar clics manuales sobre los bordes y detalles de la imagen.
* **Ajuste del plano Cartesiano:** Las imágenes digitales tienen su origen (0,0) en la esquina superior izquierda, lo que causaba que la ruta saliera de cabeza en el simulador. Para solucionarlo, el algoritmo restó la coordenada Y capturada a la altura total de la imagen, mapeando perfectamente la imagen al plano cartesiano del entorno físico del robot.
* **Densidad de puntos:** Se tomó una alta densidad de puntos en zonas de curvas complejas llegando a hacer **490 puntos** aproximadamente para asegurar que el algoritmo de interpolación tuviera suficiente información.

---

## 2. Justificación de la Estrategia de Control

Para este reto se utilizó el controlador **Pure Pursuit** esto ya que al hacer los ejercicios previos denotó una sobresaliente técnica en el seguimineto de trayectorias, por lo cual se utilizó este. Por el otro lado el robot en el algoritmo sigue un punto virtual a cierta distancia (Lookahead), donde se logra un movimiento continuo con una velocidad lineal optimizada. Esto permite trazar curvas suaves y simples, un comportamiento ideal y estrictamente necesario para dibujar formas naturales o complicadas. 

---

## 3. Ajuste de Parámetros Cinemáticos

Para que la imagen resultara perfecta y no hubiera recortes bruscos, se sintonizaron los parámetros:

* **`LookaheadDistance = 0.4` m:** Es la distancia de visión del robot. Se eligió un valor bajo (0.4) para que el robot se apegara estrictamente a los detalles finos de los waypoints, ya que si el valor fuera muy alto, el robot "recortaría" las esquinas o pasaría a otros puntos que no son los descritos en la secuencia.
* **`DesiredLinearVelocity = 4` m/s:** Una velocidad moderada-alta que permite que el robot complete el dibujo compuesto por cientos de puntos en un tiempo de simulación razonable, sin perder estabilidad.
* **`MaxAngularVelocity = 90` rad/s:** Una velocidad de giro bastante alta para permitirle al robot hacer giros cerrados casi sobre su propio eje, lo cual es vital para los vértices afilados del dibujo. También permite hacer líneas estrechas y seguir la trayectoria de manera perfecta.
* **`sampleTime = 0.1` s:** Un tiempo de muestreo lo suficientemente pequeño para que el control discreto reaccione rápido a los cambios de dirección continuos.

---

```matlab
%% EXAMPLE: Differential drive vehicle following waypoints using the 
% Pure Pursuit algorithm
%
% Copyright 2018-2019 The MathWorks, Inc.

%% Define Vehicle
R = 0.1;                % Wheel radius [m]
L = 0.5;                % Wheelbase [m]
dd = DifferentialDrive(R,L);

%% Simulation parameters
sampleTime = 0.1;               % Sample time [s]
tVec = 0:sampleTime:205000;     % Time array
initPose = [116.0000000000000; 642.0000000000001; 0]; % Initial pose (x y theta)
pose = zeros(3,numel(tVec));    % Pose matrix
pose(:,1) = initPose;

%% Pure Pursuit Controller
controller = controllerPurePursuit;
controller.Waypoints = waypoints;
controller.LookaheadDistance = 0.4; %0.5
controller.DesiredLinearVelocity = 4; %0.75
controller.MaxAngularVelocity = 90;
```

## 4. Resultados y Comparación

Al ejecutar la simulación en MATLAB, se obtuvo una representación visual muy fiel a la imagen. A continuación, se presenta la comparación entre la imagen original utilizada para la extracción de los *waypoints* , como se observa la imagen con los **400+** *waypoints* y el resultado final del seguimiento de trayectoria realizado por el robot diferencial:

<p align="center">
  <img src="https://github.com/user-attachments/assets/00c9bba5-ddc2-48f5-893c-50c97545616d" width="48%" alt="Imagen Original" />
  <img src="https://github.com/user-attachments/assets/1b0b2669-8b4d-4975-ac37-938bffed913c" width="48%" alt="Imagen waypoints" />
  <img src="https://github.com/user-attachments/assets/bbbc249f-b6ce-4c61-b054-9500c1d1eaa2" width="48%" alt="Trayectoria Final en MATLAB" />
</p>

