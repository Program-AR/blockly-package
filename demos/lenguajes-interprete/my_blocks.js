Blockly.Blocks['red_color'] = {
  init: function() {
    this.jsonInit({
      "message0": 'Red',
      "output": "Color",
      "colour": 200,
      "tooltip": "Returns number of letters in the provided text.",
      "helpUrl": "http://www.w3schools.com/jsref/jsref_length_string.asp"
    });
  }
};

Blockly.Blocks['green_color'] = {
  init: function() {
    this.jsonInit({
      "message0": 'Green',
      "output": "Color",
      "colour": 200,
      "tooltip": "Returns number of letters in the provided text.",
      "helpUrl": "http://www.w3schools.com/jsref/jsref_length_string.asp"
    });
  }
};

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
      "colour": 160,
      "tooltip": "Returns number of letters in the provided text.",
      "helpUrl": "http://www.w3schools.com/jsref/jsref_length_string.asp"
    });
  }
};
