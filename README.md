# Infrastructure as Code (IaC) on OpenStack with Terraform

Despliegue automatizado de una topología de red empresarial escalable y segura.

## Topología Desplegada
Como se detalla en la documentación, este proyecto aprovisiona mediante código:

* **Redes:** Segmentación de red en DMZ (Net1) para servicios expuestos y Red Privada (Net2) para backend aislado.
* **Seguridad:** Configuración de **Security Groups** y reglas de Firewall estrictas.
* **Computación:** Cluster de servidores Web escalables (Nginx) y nodo de Base de Datos (MariaDB) aislado.
* **Alta Disponibilidad:** Load Balancer (Octavia) configurado con algoritmo Round Robin.

## Features
* **Modularidad:** Código organizado en módulos reutilizables (Network, Compute, Security).
* **Bootstrapping:** Uso de **Cloud-init** para la instalación automática de software al inicio.
* **Escalabilidad:** Variable `server_count` para definir la infraestructura elástica.

## Documentación
Puedes ver el reporte completo de la arquitectura y pruebas de despliegue [aquí](./Documentation_Report.pdf).
