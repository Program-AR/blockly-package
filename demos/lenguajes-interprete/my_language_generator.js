'use strict';

// MyLanguage extendiendo JavaScript

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

Blockly.MyLanguage.STATEMENT_PREFIX = 'highlightBlock(%1);\n';
Blockly.MyLanguage.addReservedWords('highlightBlock');
