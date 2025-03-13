import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:uni_platform/uni_platform.dart';

final Map<PhysicalKeyboardKey, String> _knownKeyLabels =
    <PhysicalKeyboardKey, String>{
  PhysicalKeyboardKey.keyA: 'A',
  PhysicalKeyboardKey.keyB: 'B',
  PhysicalKeyboardKey.keyC: 'C',
  PhysicalKeyboardKey.keyD: 'D',
  PhysicalKeyboardKey.keyE: 'E',
  PhysicalKeyboardKey.keyF: 'F',
  PhysicalKeyboardKey.keyG: 'G',
  PhysicalKeyboardKey.keyH: 'H',
  PhysicalKeyboardKey.keyI: 'I',
  PhysicalKeyboardKey.keyJ: 'J',
  PhysicalKeyboardKey.keyK: 'K',
  PhysicalKeyboardKey.keyL: 'L',
  PhysicalKeyboardKey.keyM: 'M',
  PhysicalKeyboardKey.keyN: 'N',
  PhysicalKeyboardKey.keyO: 'O',
  PhysicalKeyboardKey.keyP: 'P',
  PhysicalKeyboardKey.keyQ: 'Q',
  PhysicalKeyboardKey.keyR: 'R',
  PhysicalKeyboardKey.keyS: 'S',
  PhysicalKeyboardKey.keyT: 'T',
  PhysicalKeyboardKey.keyU: 'U',
  PhysicalKeyboardKey.keyV: 'V',
  PhysicalKeyboardKey.keyW: 'W',
  PhysicalKeyboardKey.keyX: 'X',
  PhysicalKeyboardKey.keyY: 'Y',
  PhysicalKeyboardKey.keyZ: 'Z',
  PhysicalKeyboardKey.digit1: '1',
  PhysicalKeyboardKey.digit2: '2',
  PhysicalKeyboardKey.digit3: '3',
  PhysicalKeyboardKey.digit4: '4',
  PhysicalKeyboardKey.digit5: '5',
  PhysicalKeyboardKey.digit6: '6',
  PhysicalKeyboardKey.digit7: '7',
  PhysicalKeyboardKey.digit8: '8',
  PhysicalKeyboardKey.digit9: '9',
  PhysicalKeyboardKey.digit0: '0',
  PhysicalKeyboardKey.enter: '↩︎',
  PhysicalKeyboardKey.escape: '⎋',
  PhysicalKeyboardKey.backspace: '←',
  PhysicalKeyboardKey.tab: '⇥',
  PhysicalKeyboardKey.space: '␣',
  PhysicalKeyboardKey.minus: '-',
  PhysicalKeyboardKey.equal: '=',
  PhysicalKeyboardKey.bracketLeft: '[',
  PhysicalKeyboardKey.bracketRight: ']',
  PhysicalKeyboardKey.backslash: '\\',
  PhysicalKeyboardKey.semicolon: ';',
  PhysicalKeyboardKey.quote: '"',
  PhysicalKeyboardKey.backquote: '`',
  PhysicalKeyboardKey.comma: ',',
  PhysicalKeyboardKey.period: '.',
  PhysicalKeyboardKey.slash: '/',
  PhysicalKeyboardKey.capsLock: '⇪',
  PhysicalKeyboardKey.f1: 'F1',
  PhysicalKeyboardKey.f2: 'F2',
  PhysicalKeyboardKey.f3: 'F3',
  PhysicalKeyboardKey.f4: 'F4',
  PhysicalKeyboardKey.f5: 'F5',
  PhysicalKeyboardKey.f6: 'F6',
  PhysicalKeyboardKey.f7: 'F7',
  PhysicalKeyboardKey.f8: 'F8',
  PhysicalKeyboardKey.f9: 'F9',
  PhysicalKeyboardKey.f10: 'F10',
  PhysicalKeyboardKey.f11: 'F11',
  PhysicalKeyboardKey.f12: 'F12',
  PhysicalKeyboardKey.home: '↖',
  PhysicalKeyboardKey.pageUp: '⇞',
  PhysicalKeyboardKey.delete: '⌫',
  PhysicalKeyboardKey.end: '↘',
  PhysicalKeyboardKey.pageDown: '⇟',
  PhysicalKeyboardKey.arrowRight: '→',
  PhysicalKeyboardKey.arrowLeft: '←',
  PhysicalKeyboardKey.arrowDown: '↓',
  PhysicalKeyboardKey.arrowUp: '↑',
  PhysicalKeyboardKey.controlLeft: '⌃',
  PhysicalKeyboardKey.shiftLeft: '⇧',
  PhysicalKeyboardKey.altLeft: '⌥',
  PhysicalKeyboardKey.metaLeft: (!kIsWeb && Platform.isMacOS) ? '⌘' : '⊞',
  PhysicalKeyboardKey.controlRight: '⌃',
  PhysicalKeyboardKey.shiftRight: '⇧',
  PhysicalKeyboardKey.altRight: '⌥',
  PhysicalKeyboardKey.metaRight: (!kIsWeb && Platform.isMacOS) ? '⌘' : '⊞',
  PhysicalKeyboardKey.fn: 'fn',
  // Add numpad keys
  PhysicalKeyboardKey.numpad0: 'Numpad 0',
  PhysicalKeyboardKey.numpad1: 'Numpad 1',
  PhysicalKeyboardKey.numpad2: 'Numpad 2',
  PhysicalKeyboardKey.numpad3: 'Numpad 3',
  PhysicalKeyboardKey.numpad4: 'Numpad 4',
  PhysicalKeyboardKey.numpad5: 'Numpad 5',
  PhysicalKeyboardKey.numpad6: 'Numpad 6',
  PhysicalKeyboardKey.numpad7: 'Numpad 7',
  PhysicalKeyboardKey.numpad8: 'Numpad 8',
  PhysicalKeyboardKey.numpad9: 'Numpad 9',
  PhysicalKeyboardKey.numpadDecimal: 'Numpad .',
  PhysicalKeyboardKey.numpadAdd: 'Numpad +',
  PhysicalKeyboardKey.numpadDivide: 'Numpad /',
  PhysicalKeyboardKey.numpadEnter: 'Numpad Enter',
  PhysicalKeyboardKey.numpadEqual: 'Numpad =',
  PhysicalKeyboardKey.numpadMultiply: 'Numpad *',
  PhysicalKeyboardKey.numpadSubtract: 'Numpad -',
  PhysicalKeyboardKey.numLock: 'Num Lock',
};

extension KeyboardKeyExt on KeyboardKey {
  String get keyLabel {
    PhysicalKeyboardKey? physicalKey;
    LogicalKeyboardKey? logicalKey;
    
    if (this is LogicalKeyboardKey) {
      logicalKey = this as LogicalKeyboardKey;
      physicalKey = logicalKey.physicalKey;
      
      // Handle numpad keys specifically for consistent behavior
      if (logicalKey.keyId >= 0x100000058 && logicalKey.keyId <= 0x100000067) { // numpad0-9
        return 'Numpad ${logicalKey.keyLabel}';
      } else if (logicalKey.keyId == 0x100000054) { // numpadDivide
        return 'Numpad /';
      } else if (logicalKey.keyId == 0x100000055) { // numpadMultiply
        return 'Numpad *';
      } else if (logicalKey.keyId == 0x100000056) { // numpadSubtract
        return 'Numpad -';
      } else if (logicalKey.keyId == 0x100000057) { // numpadAdd
        return 'Numpad +';
      } else if (logicalKey.keyId == 0x10000007c) { // numpadEnter
        return 'Numpad Enter';
      } else if (logicalKey.keyId == 0x100000067) { // numpadDecimal
        return 'Numpad .';
      } else if (logicalKey.keyId == 0x100000085) { // numLock
        return 'Num Lock';
      } else if (logicalKey.keyId == 0x100000087) { // numpadEqual
        return 'Numpad =';
      }
    } else if (this is PhysicalKeyboardKey) {
      physicalKey = this as PhysicalKeyboardKey;
      logicalKey = physicalKey.logicalKey;
      
      // Check for numpad keys by USB HID usage codes
      if (physicalKey.usbHidUsage >= 0x07000058 && physicalKey.usbHidUsage <= 0x07000067) { // numpad0-9
        return 'Numpad ${physicalKey.usbHidUsage - 0x07000058}';
      } else if (physicalKey.usbHidUsage == 0x07000054) { // numpadDivide
        return 'Numpad /';
      } else if (physicalKey.usbHidUsage == 0x07000055) { // numpadMultiply
        return 'Numpad *';
      } else if (physicalKey.usbHidUsage == 0x07000056) { // numpadSubtract
        return 'Numpad -';
      } else if (physicalKey.usbHidUsage == 0x07000057) { // numpadAdd
        return 'Numpad +';
      } else if (physicalKey.usbHidUsage == 0x07000058) { // numpadEnter
        return 'Numpad Enter';
      } else if (physicalKey.usbHidUsage == 0x07000063) { // numpadDecimal
        return 'Numpad .';
      } else if (physicalKey.usbHidUsage == 0x07000053) { // numLock
        return 'Num Lock';
      } else if (physicalKey.usbHidUsage == 0x07000067) { // numpadEqual
        return 'Numpad =';
      }
    }
    
    // Fall back to known key labels or debug name
    return _knownKeyLabels[physicalKey] ?? physicalKey?.debugName ?? 'Unknown';
  }
}
