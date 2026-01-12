# Proyecto_integrador_grupo_11
## Proyecto Integrador (1) Localizacion
1.	Enunciado.
   
En este proyecto integrador de localización se implementará un sistema de estimación de estados que posee un robot móvil que recaba información a partir de datos reales de los sensores. En el cual este ejercicio práctico se basa en el desarrollo de un robot móvil diferencial 2D AVG MiR100 para entornos logísticos con necesidad de navegación precisa y evitación de obstáculos dinámicos.

Puesto que será en un entorno conocido como mapa ocupación, mediante un pipeline hibrido que está compuesto por dos algoritmos de estimación con ciertas combinaciones para hacer un sistema de navegación más preciso de los cuales son las siguientes: 

Filtro de Kalman Extendido (EKF) para la odometría + IMU, dado que este proporciona una estimación continua de la pose y covarianza por que es mas robusto conocido como modo dead- reckoning que es favorable ante ruidos y perdidas temporales de laser (Wang et al., 2025; Ly et al., 2024). Mientras que el Adaptative Monte Carlo Localization (AMCL) cuya finalidad es para localización absoluta en el mapa utilizando lecturas 2D y junto con un modelo probabilístico de observación; también se toma en cuenta el NDT (Normal Distributions Transform) cuando se necesite en el entorno (Zuo et al., 2025; Gerkey & Ferguson, n.d.).

El objetivo es implementar las fases principales de cada uno de los estimadores que son predicción y corrección, por lo cual se evaluara la precisión de ≤ 3–5 cm, Latencia de <150 ms y consistencia de la trayectoria estimada usando un rosbag de MiR100.

Este ejercicio se ejecuta sobre un entorno con mapa planificador en Matlab, control de movimiento y simulador/registro de sensores.  Se centra exclusivamente en la implementación correcta de lo estimadores dentro del ciclo predictivo y correctivo, así como la interfaz de tópicos TF y de pose.
El modelo de movimiento que es usado es la cinemática diferencial dado que se modela el movimiento en el plano con estado de cual son:


<img width="329" height="149" alt="image" src="https://github.com/user-attachments/assets/335cf08a-e906-4ff7-b040-fc5bb9d86c6a" />

		
Definición de variables:

<img width="655" height="172" alt="image" src="https://github.com/user-attachments/assets/454f33d9-2180-41e9-a2f2-7ccef66a08ed" />
	
(Thrun, Burgard, & Fox, 2005; Siegwart, Nourbakhsh, & Scaramuzza, 2011).

2.	Detalles de entrega.
Requisitos técnicos (software) y lenguaje de programación.
•	Matlab R2021 o superior recomendable el más reciente.


2.1.	Datos del rosbag (MiR100) y tópicos.

El rosbag debe contener los siguientes mensajes: 

- Sensores: /scan (láser principal), /imu_data.

- Movimiento / control: /cmd_vel, /odom, /odometry/filtered (odometría filtrada), /joint_states, /mir/joint_states.

- Referencia: /base_pose_ground_truth (Gazebo), /amcl_pose, /particlecloud. 

- Mapas: /map, /map_metadata, /map_updates. 

- Transformaciones y tiempo: /tf, /tf_static, /clock.

- Eventos de usuario: /initialpose, /move_base_simple/goal.


2.2.	Objetivo y alcance.

Objetivo.

•	Implementar un sistema de localización robusta en tiempo real para el proyecto integrador 

•	Justificar el sistema de localización para un AGV en un entorno logístico dinámico y semiestructurado.

•	Comprensión del pipeline de localización diseñado.

•	Mostrar y explicar la arquitectura a solución con un diagrama de manera coherente de módulos y flujos de datos.

Alcance.

•	Lectura junto con la sincronización del rosbag MiR100

•	Familiarización en la implementación del EKF con modelos de movimiento diferencial y las mediciones de odometría /IMU.

•	Implementación y justificación de por qué se usó AMCL con likehood field sobre el mapa.

•	Integrar de manera hibrida el EKF -AMCL manteniendo la coherencia de TF.

•	Evaluación de precisión APE/RPE, latencia de extremo a extremo, consistencia y la robustez de fallos temporales de sensores.

3.	Entorno operativo y requisitos.
   
Entorno.

Ambiente logístico en un almacén con pasillos, estaciones, cruces, obstáculos movibles como personas, AGVs, montacargas; se contempla la incertidumbre como: la iluminación, superficies, y legibilidad del RFID, QR.

Requisitos funcionales.

•	Localización en tiempo real con meta guiada ≤ 3-5 cm en pasillos marcados.

•	Percepción: Lidar 2D, IMU, odometría y cámara RGB o Depth(opcional); RFID, QR como landmarks.

•	Diagnostico: en el estado de estimación de la covarianza y fallos del sensor.

Requisitos no funcionales.

•	Latencia sensado, estimación en < 100 – 150 ms.

•	Robustez que sea una degradación segura ante la perdida del sensor.

•	Escalabilidad de diseño modular apto para multi-AGV.


	∆𝑡 es el intervalo de integración temporal.  

