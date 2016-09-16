Definición de bloques
=====================

Un bloque de tipo valor:

    Blockly.Blocks['green_color'] = {
      init: function() {
        this.jsonInit({
          "message0": 'Green',
          "output": "Color",
          "colour": 200
        });
      }
    };

Un bloque tipo primitiva que recibe como parámetro un color:

    Blockly.Blocks['set_color'] = {
      init: function() {
        this.jsonInit({
          "message0": 'Set color to %1',
          "args0": [
            {
              "type": "input_value",
              "name": "COLOR",
              "check": "Color"
            }
          ],
          "previousStatement": true,
          "nextStatement": true,
          "colour": 160
        });
      }
    };

Ver archivo `my_blocks.js`

Definición de las reglas de generación de código ejecutable
=================================================

Hay dos alternativas para generar código, extender un lenguaje existente o definir uno nuevo.

Extendiendo el lenguaje "javascript" para implementar los bloques de green_color, red_color y set_color (`my_language_generator.js`):

    Blockly.MyLanguage = Blockly.JavaScript;

    Blockly.MyLanguage['set_color'] = function(block) {
      var color = Blockly.MyLanguage.valueToCode(block, 'COLOR',
          Blockly.MyLanguage.ORDER_NONE) || '\'\'';
      var code = 'setColor('+color+');\n';
      return code;
    };

    Blockly.MyLanguage['red_color'] = function(block) {
      var code = '"red"';
      return [code, Blockly.MyLanguage.ORDER_ADDITION];
    };

    Blockly.MyLanguage['green_color'] = function(block) {
      var code = '"green"';
      return [code, Blockly.MyLanguage.ORDER_ADDITION];
    };

El archivo `another_language_generator.js` muestra como definir un lenguaje nuevo.

Generar el código ejecutable a partir de los bloques
=====================================================

    var lang = Blockly.MyLanguage;
    lang.addReservedWords('code');
    var code = lang.workspaceToCode(workspace);
    console.log(code);

Ejecutar código javascript en interprete
========================================

Luego de generar el código es necesario instanciar el interprete y configurar sus bindings con el entorno exterior al mismo, esto permite, entre otras cosas, al código que corre en el interprete acceder al DOM e interactuar con código que corre fuera del interprete.

    var initFunc = function(interpreter, scope) {
      // Configurar la funcion setColor para que modifique el color de un elemento DOM `playAreaDiv`.
      var setColorWrapper = function(text, callback) {
        text = text ? text.toString() : '';
        interpreter.createPrimitive(document.getElementById('playAreaDiv').style.backgroundColor = text);
        interpreter.createPrimitive(setTimeout(callback,1000));
      };
      interpreter.setProperty(scope, 'setColor',
        interpreter.createAsyncFunction(setColorWrapper));
    };

La función definida es asincrónica, modifica el color, espera un segundo y recien LUEGO el interprete continuara la ejecución, esto es especialmente útil para esperar a que se finalicen animaciones.

      // Instanciar interprete pasandole el código a ejecutar
      var myInterpreter = new Interpreter(code, initFunc);

      // Ejecutar el código
      runTheCode(myInterpreter);

  Si el interprete encuentra una función asincrónica, se detiene y retorna `true`, hay que volver a llamar `run`, no es necesario chequear si la función asincrónica terminó, eso lo hace el interprete.

    // Correr el interprete hasta terminar
    function runTheCode(myInterpreter) {
      if (myInterpreter.run()) {
        setTimeout(runTheCode, 10, myInterpreter);
      }
    }

Resaltar el bloque en ejecución
===================================

Modificar el generator:

    Blockly.MyLanguage.STATEMENT_PREFIX = 'highlightBlock(%1);\n';
    Blockly.MyLanguage.addReservedWords('highlightBlock');

Agregar binding al interprete:

    var initFunc = function(interpreter, scope) {
      // Add an API function for highlighting blocks.
      var wrapper = function(id) {
        id = id ? id.toString() : '';
        return interpreter.createPrimitive(workspace.highlightBlock(id));
      };
      interpreter.setProperty(scope, 'highlightBlock',
        interpreter.createNativeFunction(wrapper));

      ...

Correr el código:

    workspace.traceOn(true);
    workspace.highlightBlock(null);
    runTheCode(myInterpreter);
