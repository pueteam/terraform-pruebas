# terraform-pruebas

en el main de nuestra raiz utilizamos un config.yaml para dar valor a las variables de los modulos poudiendo intercambiar el entorno gracias a la declaracion de la variable "entorno", que tiene puesta como default "lab", en un futuro esta variable sera dicha directamente en el plan para que no tener el valor por default y que sea mas facil de manejar

### Modulos 

#### Core
En el modulo de core levantaremos la siguiente infraestructura 

    - Resource-group
    - Vnet
    - Peering

ademas tendremos que añadir el provider de subcription core ademas de la de lab 

