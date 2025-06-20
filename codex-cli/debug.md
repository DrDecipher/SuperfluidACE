after typing 1,2,3
}
[TextBuffer] insert { ch: '2', beforeCursor: [ 0, 1 ] }
[TextBuffer] pushUndo { cursor: [ 0, 1 ], text: '1' }
[TextBuffer] insert:after { cursor: [ 0, 2 ], line: '12' }
[TextBuffer] handleInput:after { cursor: [ 0, 2 ], text: '12' }
[MultilineTextEditor:stdin] data "3"
[MultilineTextEditor] event {
  input: '3',
  key: {
    upArrow: false,
    downArrow: false,
    leftArrow: false,
    rightArrow: false,
    pageDown: false,
    pageUp: false,
    return: false,
    escape: false,
    ctrl: false,
    shift: false,
    tab: false,
    backspace: false,
    delete: false,
    meta: false
  }
}
[MultilineTextEditor] key event {
  input: '3',
  key: {
    upArrow: false,
    downArrow: false,
    leftArrow: false,
    rightArrow: false,
    pageDown: false,
    pageUp: false,
    return: false,
    escape: false,
    ctrl: false,
    shift: false,
    tab: false,
    backspace: false,
    delete: false,
    meta: false
  }
}
[TextBuffer] handleInput {
  input: '3',
  key: {
    upArrow: false,
    downArrow: false,
    leftArrow: false,
    rightArrow: false,
    pageDown: false,
    pageUp: false,
    return: false,
    escape: false,
    ctrl: false,
    shift: false,
    tab: false,
    backspace: false,
    delete: false,
    meta: false
  },
  cursor: [ 0, 2 ]
}
[TextBuffer] insert { ch: '3', beforeCursor: [ 0, 2 ] }
[TextBuffer] pushUndo { cursor: [ 0, 2 ], text: '12' }
[TextBuffer] insert:after { cursor: [ 0, 3 ], line: '123' }
[TextBuffer] handleInput:after { cursor: [ 0, 3 ], text: '123' }
╭─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ 123

after pressing home

[TextBuffer] insert { ch: '3', beforeCursor: [ 0, 2 ] }
[TextBuffer] pushUndo { cursor: [ 0, 2 ], text: '12' }
[TextBuffer] insert:after { cursor: [ 0, 3 ], line: '123' }
[TextBuffer] handleInput:after { cursor: [ 0, 3 ], text: '123' }
[MultilineTextEditor:stdin] data "\u001b[H"
[MultilineTextEditor] event {
  input: '',
  key: {
    upArrow: false,
    downArrow: false,
    leftArrow: false,
    rightArrow: false,
    pageDown: false,
    pageUp: false,
    return: false,
    escape: false,
    ctrl: false,
    shift: false,
    tab: false,
    backspace: false,
    delete: false,
    meta: false
  }
}
[MultilineTextEditor] key event {
  input: '',
  key: {
    upArrow: false,
    downArrow: false,
    leftArrow: false,
    rightArrow: false,
    pageDown: false,
    pageUp: false,
    return: false,
    escape: false,
    ctrl: false,
    shift: false,
    tab: false, upd date the debug file
    backspace: false,
    delete: false,
    meta: false
  }
}
[TextBuffer] handleInput {
  input: '',
  key: {
    upArrow: false,
    downArrow: false,
    leftArrow: false,
    rightArrow: false,
    pageDown: false,
    pageUp: false,
    return: false,
    escape: false,
    ctrl: false,
    shift: false,
    tab: false,
    backspace: false,
    delete: false,
    meta: false
  },
  cursor: [ 0, 3 ]
}
[TextBuffer] handleInput:after { cursor: [ 0, 3 ], text: '123' }
╭─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ 123                                                                                                                                                                                 │
╰───────────────────────────────────────────────────────────────────────────────────────