# Taller de Ownable

En este taller, aprenderás a crear un contrato Ownable, el cual asigna una `ContractAddress` para ser el propietario del contrato. Además, aprenderás cómo se pueden implementar componentes y, finalmente, usar el componente Ownable de OpenZeppelin.

Este taller es una continuación del [Taller de Counter Versión Oficial](https://github.com/starknet-edu/counter-workshop/tree/master) o [Taller de Counter Versión StarknetEs Pioneros II](https://github.com/Nadai2010/counter-workshop). Si no lo has completado, por favor, hazlo.

Después de completar cada paso, ejecuta el script asociado para verificar que se haya implementado correctamente.

Utiliza el [libro de Cairo](https://book.cairo-lang.org/ch00-00-introduction.html) y la [documentación de Starknet](https://docs.starknet.io/documentation/) como referencia.

## Configuración

1. Clona este repositorio.
2. Crea un nuevo archivo llamado `counter.cairo` dentro de la carpeta `src`.
3. Copia el código final del [Taller de Counter Versión Oficial](https://github.com/starknet-edu/counter-workshop/blob/step6/src/prev_solution.cairo) o [Taller de Counter Versión StarknetEs Pioneros II](https://github.com/Nadai2010/counter-workshop/blob/step6/src/prev_solution.cairo) en el archivo `counter.cairo`.

> **Nota:** Trabajarás en los archivos `counter.cairo` y `ownable.cairo` para completar los requisitos de cada paso. La carpeta `prev_solution` aparecerá en futuros pasos como una forma de ponerte al día con el taller si te quedas atrás. **No modifiques ese archivo**.

Los siguientes pasos de configuración dependerán de si prefieres usar Docker para gestionar dependencias globales o no.

### Opción 1: Sin Docker

4. Instala Scarb 2.4.4 ([instrucciones](https://docs.swmansion.com/scarb/download.html#install-via-asdf)).
5. Instala Starknet Foundry 0.17.0 ([instrucciones](https://foundry-rs.github.io/starknet-foundry/getting-started/installation.html)).
6. Instala la extensión Cairo 1.0 para VSCode ([mercado](https://marketplace.visualstudio.com/items?itemName=starkware.cairo1)).
7. Ejecuta las pruebas para verificar que el proyecto esté configurado correctamente.

```bash
scarb test
```

### Opción 2: Con Docker

4. Asegúrate de que Docker esté instalado y funcionando.
5. Instala la extensión de Dev Containers para VSCode ([marketplace](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)).
6. Lanza una instancia de VSCode dentro del contenedor yendo a **Ver -> Paleta de comandos -> Dev Containers: Reconstruir y reabrir en contenedor**.
7. Abre el terminal integrado de VSCode y ejecuta las pruebas para verificar que el proyecto esté configurado correctamente.

```bash
scarb test
```

> **Nota:** Todos los comandos mostrados a partir de este punto asumirán que estás utilizando el terminal integrado de una instancia de VSCode ejecutándose dentro del contenedor. Si deseas ejecutar las pruebas en un terminal diferente, necesitarás usar el comando `docker compose run test`.

## Paso 1

### Objetivo

En este paso, necesitarás hacer lo siguiente:

- Almacenar una nueva variable llamada `owner` como tipo `ContractAddress` en la estructura `Storage`.
- Modificar la función del constructor para que acepte una nueva variable de entrada llamada `initial_owner` y luego actualice la variable `owner` en `Storage` con este valor.
- Implementar una función pública llamada `owner()` que devuelve el valor de la variable `owner`.

> **Nota:** Si te quedaste atrás, la carpeta prev_solution contiene la solución al paso anterior.

### Verificación

Al completar, ejecuta la suite de pruebas para verificar que has cumplido con todos los requisitos de esta sección.

```bash
snforge test
```

### Consejos

- Crea una nueva interfaz pública llamada `IOwnable<T>{}` y añade la función `owner()`.
- Crea una nueva `impl` que implemente la interfaz `IOwnable` y añade `#[abi(embed_v0)]` para exponer la `impl`.

## Paso 2

### Objetivo

En este paso, necesitarás hacer lo siguiente:

- Crear una función privada llamada `assert_only_owner` que verifica:
- Proteger la función `increase_counter` con la función `assert_only_owner`.

> **Nota:** Si te quedaste atrás, la carpeta prev_solution contiene la solución al paso anterior.

### Requisitos

La función `assert_only_owner` debe:

- Verificar que el `caller` no sea la dirección cero, de lo contrario, entrará en pánico con el siguiente mensaje: `Caller is the zero address`.
- Verificar que el `caller` sea el mismo que el `owner` almacenado en `Storage`, de lo contrario, entrará en pánico con el siguiente mensaje: `Caller is not the owner`.

### Verificación

Al completar, ejecuta la suite de pruebas para verificar que has cumplido con todos los requisitos de esta sección.

```bash
snforge test
```

### Consejos

- Puedes leer quién es el llamante usando el syscall `get_caller_address` disponible en el módulo `starknet`.
- Puedes verificar la dirección cero con la función `.is_zero()` en la variable misma.
- Para leer más sobre Funciones Privadas, consulta [Capítulo 12.3.2 Funciones Privadas](https://book.cairo-lang.org/ch14-02-contract-functions.html#3-private-functions).

## Paso 3

### Objetivo

En este paso, necesitarás crear una función pública llamada `transfer_ownership()` que recibe como variable de entrada `new_owner` como tipo `ContractAddress` y actualiza `owner` en `Storage` con el nuevo valor.

> **Nota:** Si te quedaste atrás, la carpeta prev_solution contiene la solución al paso anterior.

### Requisitos

La función `transfer_ownership()` debe:

- Estar en la interfaz `IOwnable`.
- Verificar que la variable `new_owner` no sea la dirección cero, de lo contrario, entrará en pánico con el siguiente mensaje: `New owner is the zero address`.
- Verificar que solo el propietario pueda acceder a la función.
- Actualizar la variable `owner` con `new_owner`.

> **Nota:** Puedes implementar una función privada que solo actualice la variable `owner` con la variable `new_owner`. Llamaremos varias veces a esta función privada y hace el código modular. Puedes nombrar esta función privada como `_transfer_ownership()`.

### Verificación

Al completar, ejecuta la suite de pruebas para verificar que has cumplido con todos los requisitos de esta sección.

```bash
snforge test
```

### Consejos

- Asegúrate de que los mensajes de pánico sean los mismos que se indican en las secciones de **Requisitos**, de lo contrario, algunas pruebas fallarán.

## Paso 4

### Objetivo

En este paso, necesitarás hacer lo siguiente:

- Implementar un evento llamado `OwnershipTransferred` que emite las variables `previous_owner` y `new_owner`.
- Emitir este evento cuando transfieras exitosamente la propiedad del contrato.

> **Nota:** Si te quedaste atrás, la carpeta prev_solution contiene la solución al paso anterior.

### Verificación

Al completar, ejecuta la suite de pruebas para verificar que has cumplido con todos los requisitos de esta sección.

```bash
snforge test
```

### Consejos

Los eventos son estructuras de datos personalizadas que son emitidas por un contrato. Puedes encontrar más información sobre Eventos en [Capítulo 12.3.3 - Eventos de Contratos](https://book.cairo-lang.org/ch14-03-contract-events.html#contract-events).

## Paso 5

### Objetivo

En este paso, necesitarás crear una función pública llamada `renounce_ownership()` que elimina al actual `owner` y lo cambia por la dirección cero.

> **Nota:** Si te quedaste atrás, la carpeta prev_solution contiene la solución al paso anterior.

### Requisitos

La función `renounce_ownership()` debe:

- Estar en la interfaz `IOwnable`.
- Verificar que solo el propietario pueda llamar a esta función.

### Verificación

Al completar, ejecuta la suite de pruebas para verificar que has cumplido con todos los requisitos de esta sección.

```bash
snforge test
```

### Consejos

- Puedes usar `Zeroable::zero()` para la dirección cero, que está disponible en el módulo `starknet`.
- Puedes usar la función privada `_transfer_ownership` que creaste en el `Paso 3` para evitar la duplicación de código.

## Paso 6

### Objetivo

En este paso, necesitarás crear una función privada llamada `initializer()`, que inicializa la variable del propietario. Modifica la función del constructor para que llames a la función privada `initializer()` e inicialices al propietario.

> **Nota:** Si te quedaste atrás, la carpeta prev_solution contiene la solución al paso anterior.

### Verificación

Al completar, ejecuta la suite de pruebas para verificar que has cumplido con todos los requisitos de esta sección.

```bash
snforge test
```

### Consejos

- Puedes usar la función privada `_transfer_ownership` que creaste en el `Paso 3` para evitar la duplicación de código.

## Paso 7

### Objetivo

En este paso, necesitarás crear un nuevo archivo llamado `ownable.cairo` y mover todo el código relacionado al ejercicio de `Ownable`. El archivo `ownable.cairo` debe ser creado como un contrato normal de starknet.

> **Nota:** Si te quedaste atrás, la carpeta prev_solution contiene la solución al paso anterior.

### Requisitos

- Nombra el contrato `ownable.cairo` de la siguiente manera:

```rust
#[starknet::contract]
mod OwnableComponent {
}
```

- Añade todo el código relevante a este archivo, esto incluye:
  - La interfaz
  - La implementación de la interfaz
  - Storage para almacenar la variable `owner`
  - Las funciones privadas

### Verificación

Al completar, ejecuta la suite de pruebas para verificar que has cumplido con todos los requisitos de esta sección.

```bash
snforge test
```

## Paso 8

### Objetivo

En este paso, cambiarás el `ownable.cairo` de un contrato de starknet a un componente de starknet. Luego, importarás el componente y lo usarás dentro de tu `counter.cairo`.

Antes de trabajar en este paso, asegúrate de leer [Capítulo 12.4: Componentes](https://book.cairo-lang.org/ch16-02-02-component-dependencies.html#component-dependencies) y ver cómo funcionan los Componentes.

> **Nota:** Si te quedaste atrás, la carpeta prev_solution contiene la solución al paso anterior.

### Requisitos

- El nombre de tu bloque de implementación de componente debe ser `OwnableImpl`
- Usa el `component!()` en el `counter.cairo` para importarlo
- En tu `counter.cairo`, almacena la ruta de almacenamiento del componente como `ownable` dentro de `Storage`
- En tu `counter.cairo`, almacena la ruta de eventos del componente como `OwnableEvent`

### Verificación

Al completar, ejecuta la suite de pruebas para verificar que has cumplido con todos los requisitos de esta sección.

```bash
snforge test
```

### Consejos

- Para migrar un contrato a un componente necesitarás:

  - Usar el `#[starknet::component]` en lugar del `#[starknet::contract]`
  - Cambiar el `#[abi(embed_v0)]` a `#[embeddable_as(name)]` para el bloque de implementación
  - Añadir parámetros genéricos para el bloque de implementación como `TContractState` y `+HasComponent<TContractState>`
  - Cambiar el argumento `self` a `ComponentState<TContractState>`

    > **Nota:** Lee más en [Capítulo 12.4: Migrar un Contrato a un Componente](https://book.cairo-lang.org/ch16-02-00-composability-and-components.html#migrating-a-contract-to-a-component)

- Para usar el componente dentro del `counter.cairo` necesitarás

  - Declarar el componente con la macro `component!()`
  - Añadir la ruta al almacenamiento y eventos del componente a tu contrato `Storage` y `Events`
  - Instanciar la implementación del componente

    > **Nota:** Lee más en [Capítulo 12.4: Usar Componentes dentro de un Contrato](https://book.cairo-lang.org/ch16-02-00-composability-and-components.html#using-components-inside-a-contract)

## Paso 9

### Objetivo

En este paso, usarás [la implementación Ownable de OpenZeppelin](https://github.com/OpenZeppelin/cairo-contracts/tree/main/src/access/ownable) en tu contrato. Solo necesitarás cambiar la ruta de importación del `OwnableComponent` para que coincida con la de OpenZeppelin.

> **Nota:** Si te quedaste atrás, la carpeta prev_solution contiene la solución al paso anterior.

### Verificación

Al completar, ejecuta la suite de pruebas para verificar

 que has cumplido con todos los requisitos de esta sección.

```bash
snforge test
```

### Consejos

- La biblioteca de OpenZepplin ya ha sido añadida a tu configuración de `Scarb.toml`
- Solo necesitas modificar tu importación de ownable para que coincida con el [OwnableComponent](https://github.com/OpenZeppelin/cairo-contracts/blob/main/src/access/ownable/ownable.cairo)

## Paso 10 (final)

### Objetivo

Verifica que has creado correctamente un contrato de cuenta para Starknet ejecutando la suite completa de pruebas:

```bash
snforge test
```

Si la suite de pruebas pasa, felicidades, has creado tu primer Contrato de Contador personalizado en Starknet que implementa la característica de componente y usa exitosamente la biblioteca de OpenZeppelin.
