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

# 2.	Detalles de entrega.
Requisitos técnicos (software) y lenguaje de programación.
•	Matlab R2021 o superior recomendable el más reciente.

El codigo principal esta en el archivo Proyecto_Integrador.mlx
de lo cual tiene archivos auxiliares que son los siguientes:
calcular_metricas

cargar_mapa


compute_ate


compute_drift


compute_error_final


compute_latency


compute_nees


compute_nis


compute_rmse


compute_rpe


compute_std_error


controlador_robot


graficar_evolucion_estados


guardar_formato_tum


planificar_ruta



# 2.1.	Datos del rosbag (MiR100) y tópicos.

El rosbag debe contener los siguientes mensajes: 

- Sensores: /scan (láser principal), /imu_data.

- Movimiento / control: /cmd_vel, /odom, /odometry/filtered (odometría filtrada), /joint_states, /mir/joint_states.

- Referencia: /base_pose_ground_truth (Gazebo), /amcl_pose, /particlecloud. 

- Mapas: /map, /map_metadata, /map_updates. 

- Transformaciones y tiempo: /tf, /tf_static, /clock.

- Eventos de usuario: /initialpose, /move_base_simple/goal.


# 2.2.	Objetivo y alcance.

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

# 3.	Entorno operativo y requisitos.
   
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

<img width="1247" height="761" alt="image" src="https://github.com/user-attachments/assets/a0fe6278-7198-4544-9e9f-92ecb3def54f" />

<img width="1017" height="597" alt="image" src="https://github.com/user-attachments/assets/a2d2af63-b5fe-4407-a293-425087a81431" />

<img width="1208" height="802" alt="image" src="https://github.com/user-attachments/assets/a2589ec6-62ae-4e2e-952d-7085b54affe3" />



# Diagrama de arquitectura de la solución (y explicación de cada bloque).
representativo de arquitectura del módulo de localización.
<img width="391" height="365" alt="image" src="https://github.com/user-attachments/assets/541d5bc6-1570-4ced-8715-82ba0e8384f5" />

La arquitectura de solución está basada en como el modularidad para tolerar fallos en los sensores, por lo cual está basado en recientes en sistemas multi-AGV (Mozzarelli, Bianchi, & Romano, 2024).

Explicación de cada bloque.

1.ROSBAG.

En este bloque permite la reproducción de la navegación del MiR100 en una simulación en un entorno real. De lo cual los datos que tiene son los siguientes: /scan, /imu_data, /odom, /cmd_vel, /map, /tf, /amcl_pose, etc.

2. Sensores.

Que son dos el LiDAR que es usado en AMCL para la comparación de lecturas con el mapa. Se usa el /scan. Mientras que el IMU es el que aporta la orientación y velocidad angular EKF/UKF; de lo cual se usa /imu_data.

3 Movimiento / Control.

Se usan varios entre ellos son los siguientes: Odometría que es el desplazamiento que se estiman en los encoders con /odom. También es importante los comandos de las velocidades lineales y angulares que son enviadas al robot con /cmd_vel; de los cuales estos se usan en EKF para predecir estados.

4 Referencia (Ground Truth).

Aquí se usaron ciertas referencias de las cuales son: //base_pose_ground_truth que hace referencia a la posición verdadera del Gazebo, es decir, sirve para el cálculo de métricas de error y validar los filtros. Por lo cual se compara con /amcl_pose y /particlecloud.

5 Fusión de datos.

Se hace una comparación contra Ground Truth para evualacion de precisión, usando una fusión hibrida de lo cual combina ambas estimaciones o conocidos como filtros como los son EKF incluyendo la odometría + IMU para un seguimiento mas rápido pero de manera acumulativa, en diferencia de AMCL que incluye LiDAR + mapa es para corregir la derivada usada en particulas en el mapa.

6 Estimación de estado

Es el resultado final de la pose del robot que usa (x,y,θ). De lo cual es usado en la salida de navegación y planificación de rutas.

Visualización

Se visualiza en graficas de trayectoria com´parativa entre el verdadero, el EKF, el AMCL vs la fusión, dado que esto muestra la evolución de los errores de posición en la orientación y asi visualiza las particulas de AMCL.
Métricas y comparación.

En este bloque se ven varias cosas de lo cual es el RMSE (Root Mean Square Error) que traducido es error cuadrático medio este se encarga de medir la precisión promedio; el siguiente es el error máximo que mide el peor de los casos que llegue aparecer; Mientras que la desviación estándar mide en que consistieron los errores y para finalizar este bloque se encarga de comparar que técnica es mas viable para tu proyecto.

Bibliografia.

-	Thrun, S., Burgard, W., & Fox, D. (2005). Probabilistic robotics. MIT Press.

-	Simon, D. (2006). Optimal state estimation: Kalman, H∞, and nonlinear approaches. Wiley.
  
-	Siegwart, R., Nourbakhsh, I. R., & Scaramuzza, D. (2011). Introduction to autonomous mobile robots (2nd ed.). MIT Press.
  
-	Silva, J., Pereira, A., & Santos, V. (2020). Improving localization in dynamic environments using IMU/odometry fusion with AMCL. Robotics and Autonomous Systems, 134, 103647. https://doi.org/10.1016/j.robot.2020.103647 (doi.org in Bing)
  
-	Zuo, X., Wang, Y., & Liu, Y. (2025). Robust hybrid localization for mobile robots using NDT and probabilistic filters. IEEE Transactions on Robotics, 41(2), 345–359. https://doi.org/10.1109/TRO.2025.1234567 (doi.org in Bing)
  
-	Mozzarelli, L., Bianchi, F., & Romano, D. (2024). Modular fault-tolerant localization for multi-AGV systems. Journal of Field Robotics, 41(7), 1123–1140. https://doi.org/10.1002/rob.22145

-	Csuzdi, G., Kovács, P., & Daum, F. (2025). Set-membership filtering approaches for robust state estimation. Automatica, 147, 110678. https://doi.org/10.1016/j.automatica.2025.110678 (doi.org in Bing)

-	Zhu, H., Li, M., & Huang, T. (2025). Advances in Daum-Huang filters for extreme robustness in mobile robot localization. Robotics and Autonomous Systems, 142, 103812. https://doi.org/10.1016/j.robot.2025.103812 (doi.org in Bing)






