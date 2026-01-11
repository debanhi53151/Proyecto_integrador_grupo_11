# Proyecto_integrador_grupo_11
## Proyecto Integrador (1) Localizacion
En este proyecto integrador de localización se implementará un sistema de estimación de estados que posee un robot móvil que recaba información
a partir de datos reales de los sensores. En el cual este ejercicio práctico se basa en el desarrollo de un robot móvil diferencial 2D AVG MiR100 
para entornos logísticos con necesidad de navegación precisa y evitación de obstáculos dinámicos.

Puesto que será en un entorno conocido como mapa ocupación, mediante un pipeline hibrido que está compuesto por dos algoritmos de estimación con 
ciertas combinaciones para hacer un sistema de navegación más preciso de los cuales son las siguientes: 
Filtro de Kalman Extendido (EKF) para la odometría + IMU, dado que este proporciona una estimación continua de la pose y covarianza por que es mas 
robusto conocido como modo dead- reckoning que es favorable ante ruidos y perdidas temporales de laser. Adaptative Monte Carlo Localization (AMCL) 
cuya finalidad es para localización absoluta en el mapa utilizando lecturas 2D y junto con un modelo probabilístico de observación; también se toma 
en cuenta el NDT (Normal Distributions Transform) cuando se necesite en el entorno.

Cuyo objetivo es implementar las fases principales de cada uno de los estimadores que son predicción y corrección, por lo cual se evaluara 
cuantativamente la precisión, Latencia y consistencia de la trayectoria estimada usando un rosbag de MiR100.
Este ejercicio se ejecuta sobre un entorno con mapa planificador en Matlab, control de movimiento y simulador/registro de sensores.  
Se centra exclusivamente en la implementación correcta de lo estimadores dentro del ciclo predictivo y correctivo, así como la interfaz de 
tópicos TF y de pose.

El modelo de movimiento que es usado es la cinemática diferencial dado que se modela el movimiento en el plano con estado de cual son:
          x_t=x_(t-1)+v∙cos⁡(θ_(t-1))∙∆_t
          y_t=y_(t-1)+v∙cos⁡(θ_(t-1))∙∆_t
          θ_t=θ_(t-1)+v∙ω∙∆_t
Definición de variables:
	x_t  , y_t, son las coordenadas del robot en el instante 𝑡. 
	θ_t,  es la orientación en el instante 𝑡. 
	𝑣 es la velocidad lineal. 
	𝜔 es la velocidad angular. 
	∆𝑡 es el intervalo de integración temporal.  

