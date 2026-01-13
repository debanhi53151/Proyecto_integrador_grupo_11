## Proyecto Integrador (I) — SLAM en entornos logísticos con robot MiR100.

# 1. Enunciado.

En este proyecto integrador se implementa un sistema SLAM(Simultaneous Localization and 
Mapping) para el robot móvil diferencial MiR100 en entornos logísticos semiestructurados como lo 
es en un ambiente logístico dentro de una empresa como lo es un almacén con pasillos definidos, 
estaciones fijas y zonas de cruce. 

Este ejercicio se elabora mediante la construcción de un mapa con percepción sensorial en un robot 
móvil. Puesto que el objetivo de este proyecto es implementar un algoritmo de construcción de 
mapas de ocupación usando la información que viene de un sensor de ultrasonidos colocado sobre 
el robot móvil como tipo diferencial para lograr un mapa preciso a partir de los datos reales de 
sensores y también integrando LiDAR 2D, odometría y IMU, incluyendo parámetros ajustados a la 
logística para mejorar precisión, robustez y consistencia. 

Puesto que el mapa generado será una representación en rejilla de cada celda almacena la 
probabilidad de estar ocupada o libre, que se representa en log-odds. Cada lectura del sensor, el 
mapa se ira actualizando de forma acumulativa y lineal, viéndose reflejado la evidencia de la 
recolección a lo largo del recorrido. 

La solución se basará en modelos probabilísticos de movimiento, medición y técnicas de SLAM de 
las cuales son AMCL, GraphSLAM, FastSLAM, Occupancy Grid, que se toman en cuenta según las 
recomendaciones de…. (libro y justificación) y estándares de evaluación de desempeño para AGVs. 
Referencias clave: Thrun–Burgard–Fox (Probabilistic Robotics), capítulos 5–6 (modelos), 8–9 
(AMCL, occupancy grids), 10–13 (SLAM); NIST (ASTM F45, métricas de navegación para AGV).

• En un entorno del robot será representada en logístico que se representa en un mapa de 
2D en rejilla con una resolución de 5 cm por celda, también una imagen de 500x500 
pixeles con escala de 5 cm por pixel para la superposición visual. 

• El robot MiR100 se desplaza en un entorno y recolecta información mediante el LiDAR 
2D con ≥ 270°, un alcance de 30 m y el IMU; también la odometría de lo encoders se usa 
para reconstruir la pose y orientación. 

• Mediante los encoders de cada rueda y la cinemática diferencial se va reconstruyendo la 
trayectoria del robot móvil; de manera opcional se estabiliza con el AMCL, FastSLAM, 
GraphSLAM, es decir, manteniendo coherencia TF. 

• Con la recolección de información sensorial, se actualiza el mapa ocupación usando 
modelo inverso, dado que refuerza ocupada entorno o retornos y libre antes del retorno 
a lo largo del rayo. 

• Se mostrará la trayectoria seguida en las zonas ocupadas y las de superposición con el 
mapa de referencia de rosbag con sus métricas de calidad.
