## Proyecto Integrador (I) — SLAM en entornos logísticos con robot MiR100.

# 1. Enunciado.

En este proyecto integrador se implementa un sistema SLAM (Simultaneous Localization and 
Mapping) para el robot móvil diferencial MiR100 en entornos logísticos semiestructurados como lo 
es en un ambiente logístico dentro de una empresa como lo es un almacén con pasillos definidos, 
estaciones fijas y zonas de cruce. 

Este ejercicio se elabora mediante la construcción de un mapa con percepción sensorial en un robot 
móvil. Puesto que el objetivo de este proyecto es implementar un algoritmo de construcción de 
mapas de ocupación usando la información que viene de un sensor de ultrasonidos colocado sobre 
el robot móvil como tipo diferencial para lograr un mapa preciso a partir de los datos reales de 
sensores y también integrando LiDAR 2D, odometría y IMU, incluyendo parámetros ajustados a la 
logística para mejorar precisión, robustez y consistencia (Thrun et al., 2005, caps. 6 y 9; Yue & 
He, 2024). 

Puesto que el mapa generado será una representación en rejilla de cada celda almacena la 
probabilidad de estar ocupada o libre, que se representa en log-odds. Cada lectura del sensor, el 
mapa se ira actualizando de forma acumulativa y lineal, viéndose reflejado la evidencia de la 
recolección a lo largo del recorrido (Thrun et al., 2005, cap. 9). 

La solución se basará en modelos probabilísticos de movimiento, medición y técnicas de SLAM de 
las cuales son AMCL, GraphSLAM, FastSLAM, Occupancy Grid, que se toman en cuenta según las 
recomendaciones del libro Probabilistic Robotics y estándares de evaluación de desempeño 
para AGVs (Thrun et al., 2005, caps. 5–6, 8–13; Bostelman, 2016). 

• En un entorno del robot será representada en logístico que se representa en un mapa de 
2D en rejilla con una resolución de 5 cm por celda, también una imagen de 500x500 
pixeles con escala de 5 cm por pixel para la superposición visual (Thrun et al., 2005, cap. 
9). 

• El robot MiR100 se desplaza en un entorno y recolecta información mediante el LiDAR 
2D con ≥ 270°, un alcance de 30 m y el IMU; también la odometría de lo encoders se usa 
para reconstruir la pose y orientación (Peng et al., 2023; Yue & He, 2024). 
• Mediante los encoders de cada rueda y la cinemática diferencial se va reconstruyendo la 
trayectoria del robot móvil; de manera opcional se estabiliza con el AMCL, FastSLAM, 
GraphSLAM, es decir, manteniendo coherencia TF (Open Robotics, 2025; Thrun et al., 
2005, caps. 8 y 11). 

• Con la recolección de información sensorial, se actualiza el mapa ocupación usando 
modelo inverso, dado que refuerza ocupada entorno o retornos y libre antes del retorno 
a lo largo del rayo (Thrun et al., 2005, cap. 6). 

• Finalmente se mostrará la trayectoria seguida en las zonas ocupadas junto las de 
superposición con el mapa de referencia de rosbag con sus métricas de calidad y las 
guias de ASTM F45 (Thrun et al., 2005; Bostelman, 2016). 

<img width="199" height="228" alt="image" src="https://github.com/user-attachments/assets/6b50abd3-cd29-4e32-b84d-471b98b97d46" />

<img width="506" height="217" alt="image" src="https://github.com/user-attachments/assets/0ab6a559-26c1-4cd5-9ccc-db132145392a" />

# 2. Objetivos. 

• Es la construcción de mapa precisos que se recolecta a partir de datos reales de sensores 
con ello garantizando la robustez ante los obstáculos y condiciones que pueden generar 
variables de error. 

• Comprender el pipeline de SLAM en la adquisición, preprocesado, estimación y validación 
(Yue & He, 2024; Thrun et al., 2005). 

• Selección y justificación de la técnica de mapeo más idónea para el proyecto (Thrun et al., 
2005). 

• Implementación de un sistema sobre el rosbag del MiR100 con parámetros nuevos. 

• Evaluación de la calidad del mapa y su trayectoria mediante métricas cualitativas y 
cuantitativas (Thrun et al., 2005; Bostelman, 2016). 

• Diseño con la explicación de la arquitectura. 

# 2.1. Detalles de entrega 

Datos del rosbag. 

De lo cual contendrá los siguientes mensajes: 

• Sensores: /scan, /imu_data. 

• Movimiento / control: /cmd_vel, /odom, /odometry/filtered, /joint_states, /mir/joint_states. 

• Referencia: /base_pose_ground_truth, /amcl_pose, /particlecloud. 

• Mapas: /map, /map_metadata, /map_updates. 

• Transformaciones y tiempo: /tf, /tf_static, /clock 

• Eventos de usuarios: /initialpose, /move_base_simple/goal. 

# 2.2. Lenguaje de programación. 

El proyecto se hará en Matlab el código de programación dado que los miembros del equipo, 
mediante una votación y evaluación se hizo más favorable. 

El codigo principal esta en slam_mir100, de lo cual tiene archivos auxiliares que se crearon para que se pudiera funcionar y crear el entorno logistico de lo cuales son los siguientes archivos
1. analyze_bag.m
2. dibujarMapaOccupacion.
3
4
5
6
7
8
9
10.

# 3. Conceptos.

Mapas de ocupación basados en rejillas. 

En este proyecto integrador en el entorno del almacén se va a representar en una rejilla 
bidimensional conocida como occupancy grid (Thrun et al., 2005, cap. 9). Cada celda almacena la 
posibilidad de estar ocupada, libre o desconocida; esto es fundamental en el SLAM dado que permite 
integrar lecturas sensoriales con la planificación de rutas seguras en el entorno logístico (Thrun et 
al., 2005; Yue & He, 2024). 

▪ Ocupada: es la presencia de un obstáculo como es una pared, rack o pallet. 

▪ Libre: es aquel espacio sin obstáculos y favorable para navegación 

▪ Desconocida: es un estado inicial o con baja evidencia, es decir, sin mediciones suficientes. 

Puesto que esta representación es estándar en lo algoritmos que son ampliamente usados en los 
robots móviles industriales de lo cuales entre ellos son el Gmapping, Hector SLAM y Cartographer. 
Representacion en log-odds. 

Para una actualización del mapa de manera eficiente y acumulativa, en cada celda se almacena el 
formato log-odds.

<img width="401" height="219" alt="image" src="https://github.com/user-attachments/assets/195cf18c-a07b-4f05-bb6d-237508791512" />

Actualización del mapa. 

Cada lectura nueva del LiDAR se traduce en log-odds y es acumulativa:

<img width="703" height="138" alt="image" src="https://github.com/user-attachments/assets/f81478c5-d342-4eb9-b5b1-231abb0b7b83" />

Este método está explicado en Probabilistic Robotics (Thrun et al., Cap. 9) y es la base de los 
mapas de ocupación en SLAM. 

Componentes del sistema. 

Robot y movimiento. 

• Robot MiR100 que utiliza odometría en los encoders, con un IMU y LiDAR 2D con un 
FoV ≥ 270°, alcance hasta 30 m. 

<img width="258" height="79" alt="image" src="https://github.com/user-attachments/assets/94721eb5-fa46-40a7-a940-fd9e5e29834d" />

 En el modelo del movimiento es cinematica diferencial para estimar la posición. 
Y el movimiento se describe de la siguiente manera: 

<img width="204" height="113" alt="image" src="https://github.com/user-attachments/assets/04a3f182-33bd-4dd5-b3bf-be358f93b2bf" />

(Thrun et al., 2005, cap. 5; Siegwart, Nourbakhsh, & Scaramuzza, 2011, cap. 3). 

Sensor LiDAR es el simula que cada escaneo de rayos que detecta el primer obstáculo que se 
encuentre en su recorrido con apertura efectiva α=20° y actualiza las celdas, porque tiene un 
alcance de 𝑟𝑚𝑎𝑥 = 30 m, de lo cual dependerá de la zona: 

<img width="520" height="75" alt="image" src="https://github.com/user-attachments/assets/2dbae26a-5896-4eff-9d13-71b5242c0450" />

Planificación de movimiento 

Escogido el mapa en el punto anterior, se ha adoptado el algoritmo mejorado A* gracias a su perfecto 
encaje con las occupancy grids debido a que opera directamente sobre celdas discretas 
aprovechando sus estructuras regulares y permitiendo calcular costes y heurísticas eficientes. 
Además, este tipo de representación puede obtener un alto grado de optimización en la penalización 
angular favoreciendo trayectorias más rectas reduciendo el número de giros innecesarios, reducción 
de números puntos de paso o waypoints y de nodos redundantes. 

Para llevar a cabo esta optimización en el MiR100, se ha optado por los siguientes tres puntos: - - - 

Introducción de términos de coste angular y estrategias de tie-breaking, favoreciendo a la 
priorización de segmentos rectos para reducir el número de giros y cambios de rumbo en 
zonas extensas como pudieran ser pasillos largos (*1).   

Ajuste en el número de nodos donde el robot decide, en función de contexto de la zona de 
trabajo, optar por un modelo 4-vecinos o de 8-vecinos. En caso de actuar en un pasillo o 
zona estrecha trabajaría con el modelo de 4-vecinos. En cambio, en un espacio más abierto 
la decisión que debe tomar es la de aplicar el modelo 8-vecinos ayudando a que el 
movimiento pueda tomar trayectorias más diagonales (*2). 

Eliminación de nodos redundantes para una optimización en el número de waypoints o 
puntos de paso (*3). 

La ecuación empleada para este proyecto es la siguiente: 

<img width="214" height="105" alt="image" src="https://github.com/user-attachments/assets/ce4b6901-38a3-471f-ac21-47558f98c4d3" />

<img width="565" height="123" alt="image" src="https://github.com/user-attachments/assets/675133c8-0023-4beb-b38a-f540fa164b6f" />

<img width="290" height="368" alt="image" src="https://github.com/user-attachments/assets/35504998-eb22-493c-8e21-9f0071ace3e4" />

<img width="445" height="451" alt="image" src="https://github.com/user-attachments/assets/113fe3ae-d987-44aa-bae9-6609180f4fc5" />

En el presente diagrama de arquitectura de solución representa una estructura viable para el sistema 
SLAM que es aplicado en un robot MiR100, de lo cual estima su propia posición, usando datos 
sensoriales que son extraídos del rosbag. 

En el bloque azul 1 Sensores , de lo cual como se puede ver en la entrada esta el archivo ROSBAG 
que tiene los siguientes tópicos como /odom (odometría) y /scan (LiDAR); por lo cual los sensores 
dan información sobre la pose del robot junto con las distancias a los obstáculos. Fundamentado con 
lo redactado por Thrun, Burgard y Fox (2005), esta combinación es esencial para que los sensores 
den la estimación de probabilística del estado y del entorno. 

En los bloques de color anaranjado es el procesamiento, de lo cual esta dividido en tres bloques que 
son: 

La incializacion del mapa en log-odds que este crea una matriz de ocupación mediante la 
incertidumbre inicial = 0.5, aquí el log-odds es para facilitar la suma de evidencias (Stachniss et al., 
2006). 

El segundo es el modelo inverso que es la actualización de cada celda del mapa según las lecturas 
del LiDAR, que se asignan como ocupadas, libres o inciertas. 

El tercero es la actualización del mapa que es donde se acumulas evidencias sensoriales de cada 
celda mediante la formula de modelo Bayesiano que es fundamento por Leonard y Durrant-Whyte 
(2001), que la observación refina la creencia del estado en el entorno. 

El bloque verde de visualización es la salida del sistema, donde incluye dos cosas:  Mapa de 
ocupación que este elabora la conversión de log-odds a las probabildades para representar zonas 
ocupadas y libres. El segundo es la trayectoria del robot que se superpone a la trayectoria estimada 
sobre el mapa, esto valida el desempeño de SLAM. Esta visualización se usa para evaluar la precisión
del sistema como lo describe Stachniss et al. (2006) quien destaca la importancia de la comparación 
de trayectorias que son como referencias externas.

<img width="672" height="418" alt="image" src="https://github.com/user-attachments/assets/3442b7e1-5026-456f-b4c0-f3a4a9b15e95" />

Referencias (APA). 

• Abu Bakar, M. A., Kamarudin, K., Qistina, N., Heng, H., Imran, H., & Rahiman, W. (2025). 
Parameters tuning for enhanced automated guided vehicle navigation in ROS/Gazebo 
simulation environment. Journal of Advanced Research in Applied Mechanics, 133(1), 63
77. 

• Bostelman, R. (2016). Navigation performance evaluation for automatic guided vehicles. National Institute of Standards and Technology 
https://tsapps.nist.gov/publication/get_pdf.cfm?pub_id=918241 [github.com] 
(NIST). 

• Open Robotics Discourse. (2025). Learn ROS AI Robotics Integration with New 
Launched 
Logistics 
https://discourse.openrobotics.org/t/learn-ros-ai-robotics-integration-with-new-launched
logistics-kit/43466 [cs.columbia.edu] 
Kit. 

• Peng, G., et al. (2023). LiDAR SLAM for mobile robot. In Introduction to Intelligent Robot System Design. Springer. 
https://link.springer.com/chapter/10.1007/978-981-96-4967-9_56 

• Siegwart, R., Nourbakhsh, I. R., & Scaramuzza, D. (2011). Introduction to Autonomous 
Mobile Robots (2nd ed.). MIT Press. (Cap. 3: cinemática diferencial). 
• Thrun, S., Burgard, W., & Fox, D. (2005). Probabilistic Robotics. MIT Press. (Caps. 5–6, 
8–9, 10–13). 

• Yue, X., & He, M. (2024). LiDAR-based SLAM for robotic mapping: State of the art and new frontiers. 
https://arxiv.org/abs/2311.00276 [aicompetence.org] 

• MathWorks. (s. f.). arXiv lidarSLAM https://www.mathworks.com/help/nav/ref/lidarslam.html preprint. (MATLAB). 

• (*1) Xie, J., Xu, C., & Yang, Q. (2025). Robot path planning model based on improved A 
algorithm*. International Journal of Advanced Computer Science and Applications, 16(5). 

• (2*) Mi, Z. (2024). Robot path planning based on improved A algorithm*. IEEE Xplore. 

• (*3) Wang, F., Sun, W., Yan, P., Wei, H., & Lu, H. (2024). Research on path planning for 
robots with improved A algorithm under bidirectional JPS strategy*. Applied Sciences, 14(13).









