class AsciiToChar {
  static final Map<int, String> _asciiMap = {
    // English Alphabets
    65: 'A', 66: 'B', 67: 'C', 68: 'D', 69: 'E', 70: 'F', 71: 'G', 72: 'H',
    73: 'I', 74: 'J', 75: 'K', 76: 'L', 77: 'M', 78: 'N', 79: 'O', 80: 'P',
    81: 'Q', 82: 'R', 83: 'S', 84: 'T', 85: 'U', 86: 'V', 87: 'W', 88: 'X',
    89: 'Y', 90: 'Z',
    97: 'a', 98: 'b', 99: 'c', 100: 'd', 101: 'e', 102: 'f', 103: 'g', 104: 'h',
    105: 'i', 106: 'j', 107: 'k', 108: 'l', 109: 'm', 110: 'n', 111: 'o',
    112: 'p', 113: 'q', 114: 'r', 115: 's', 116: 't', 117: 'u', 118: 'v',
    119: 'w', 120: 'x', 121: 'y', 122: 'z',

    // French and Spanish Alphabets
    192: 'À', 193: 'Á', 194: 'Â', 195: 'Ã', 196: 'Ä', 197: 'Å', 198: 'Æ',
    199: 'Ç', 200: 'È', 201: 'É', 202: 'Ê', 203: 'Ë', 204: 'Ì', 205: 'Í',
    206: 'Î', 207: 'Ï', 208: 'Ð', 209: 'Ñ', 210: 'Ò', 211: 'Ó', 212: 'Ô',
    213: 'Õ', 214: 'Ö', 215: '×', 216: 'Ø', 217: 'Ù', 218: 'Ú', 219: 'Û',
    220: 'Ü', 221: 'Ý', 222: 'Þ', 223: 'ß', 224: 'à', 225: 'á', 226: 'â',
    227: 'ã', 228: 'ä', 229: 'å', 230: 'æ', 231: 'ç', 232: 'è', 233: 'é',
    234: 'ê', 235: 'ë', 236: 'ì', 237: 'í', 238: 'î', 239: 'ï', 240: 'ð',
    241: 'ñ', 242: 'ò', 243: 'ó', 244: 'ô', 245: 'õ', 246: 'ö', 247: '÷',
    248: 'ø', 249: 'ù', 250: 'ú', 251: 'û', 252: 'ü', 253: 'ý', 254: 'þ',
    255: 'ÿ',

    // Numbers
    48: '0', 49: '1', 50: '2', 51: '3', 52: '4', 53: '5', 54: '6', 55: '7',
    56: '8', 57: '9',

    // Hindi and Marathi Alphabets and Numbers (Devanagari Script)
    2309: 'अ', 2310: 'आ', 2311: 'इ', 2312: 'ई', 2313: 'उ', 2314: 'ऊ',
    2315: 'ऋ', 2319: 'ए', 2320: 'ऐ', 2323: 'ओ', 2324: 'औ',
    2325: 'क', 2326: 'ख', 2327: 'ग', 2328: 'घ', 2329: 'ङ',
    2330: 'च', 2331: 'छ', 2332: 'ज', 2333: 'झ', 2334: 'ञ',
    2335: 'ट', 2336: 'ठ', 2337: 'ड', 2338: 'ढ', 2339: 'ण',
    2340: 'त', 2341: 'थ', 2342: 'द', 2343: 'ध', 2344: 'न',
    2346: 'प', 2347: 'फ', 2348: 'ब', 2349: 'भ', 2350: 'म',
    2351: 'य', 2352: 'र', 2354: 'ल', 2355: 'व', 2356: 'श',
    2357: 'ष', 2358: 'स', 2359: 'ह', 2360: '़',
    2406: '०', 2407: '१', 2408: '२', 2409: '३', 2410: '४',
    2411: '५', 2412: '६', 2413: '७', 2414: '८', 2415: '९',

    // Telugu Alphabets and Numbers
    3072: 'అ', 3073: 'ఆ', 3074: 'ఇ', 3075: 'ఈ', 3076: 'ఉ',
    3077: 'ఋ', 3078: 'ఎ', 3079: 'ఏ', 3080: 'ఐ', 3081: 'ఒ',
    3082: 'ఓ', 3083: 'ఔ', 3084: 'క', 3085: 'ఖ', 3086: 'గ',
    3087: 'ఘ', 3088: 'ఙ', 3089: 'చ', 3090: 'ఛ', 3091: 'జ',
    3092: 'ఝ', 3093: 'ఞ', 3094: 'ట', 3095: 'ఠ', 3096: 'డ',
    3097: 'ఢ', 3098: 'ణ', 3099: 'త', 3100: 'థ', 3101: 'ద',
    3102: 'ధ', 3103: 'న', 3104: 'ప', 3105: 'ఫ', 3106: 'బ',
    3107: 'భ', 3108: 'మ', 3109: 'య', 3110: 'ర', 3111: 'ఱ',
    3112: 'ల', 3114: 'ళ', 3115: 'ఴ', 3116: 'వ', 3117: 'శ',
    3118: 'ష', 3119: 'స', 3120: 'హ', 3121: 'ఽ',
    3122: 'ౘ', 3123: 'ౙ', 3124: 'ౚ', 3125: '౛', 3126: '౜',
    3127: 'ౝ', 3128: '౞', 3129: '౟', 3130: 'ౠ', 3131: 'ౡ',
    3132: 'ౢ', 3133: 'ౣ', 3134: '౦', 3135: '౧', 3136: '౨',
    3137: '౩', 3138: '౪', 3139: '౫', 3140: '౬', 3141: '౭',
    3142: '౮', 3143: '౯',

    // Special Characters
    32: ' ', // Space
    44: ',', // Comma
    63: '?', // Question Mark
    46: '.', // Period
    33: '!', // Exclamation
    58: ':', // Colon
    59: ';', // Semi-Colon
    34: '"', // Inverted Commas
    39: "'", // Single Quote
    96: '`', //
    94: '^', // Caret

    // New Line
    10: '\n', // New Line

    // Brackets
    40: '(', // Opening Parenthesis
    41: ')', // Closing Parenthesis
    91: '[', // Opening Square Bracket
    93: ']', // Closing Square Bracket
    123: '{', // Opening Curly Brace
    125: '}', // Closing Curly Brace
    60: '<', // Opening Angle Bracket
    62: '>', // Closing Angle Bracket

    // Slashes
    124: '|', // Vertical Bar
    47: '/', // Forward Slash
    92: '\\', // Backward Slash

    // Symbols
    64: '@', // At Symbol
    35: '#', // Hash Symbol
    37: '%', // Percent Symbol
    38: '&', // Ampersand Symbol
    95: '_', // Underscore Symbol
    126: '~', // Tilde Symbol

    // Math Symbols
    43: '+', // Plus
    45: '-', // Minus
    42: '*', // Asterisk
    61: '=', // Equals

    // extra symbols
    1: ' start(heading) ', 2: ' start(text) ', 3: ' end(text) ',
    4: ' end(transmission) ', 5: ' enquiry ', 6: ' acknowledge ',
    9: '    ', // Horizontal Tab
    11: '\n\n\n\n', // Vertical Tab
    12: '\n\n\n\n\n\n\n\n', // New page
    21: ' negative acknowledge ', 24: ' cancel ', 25: ' end(medium) ',
    26: ' substitute ', 27: ' escape ', 28: ' separator(file) ',
    29: 'separator(group)', 30: ' separator(record) ', 31: ' separator(unit) ',
    127: ' delete ',

    // currency symbols
    36: '\$', // Dollar Symbol
    163: '£', // Pound Symbol
    8364: '€', // Euro Symbol
    165: '¥', // Yen Symbol
    8377: '₹', // Indian Rupee Symbol
    162: '¢', // Cent Symbol
    8355: '₣', // Franc Symbol
    8356: '₤', // Lira Symbol
    8361: '₩', // Won Symbol
  };

  static String fromInt(int key) {
    if (_asciiMap.containsKey(key)) {
      return _asciiMap[key]!;
    } else {
      return '';
    }
  }

  static String fromIntList(List<int> list) {
    int length = list.length;
    if (length > 0) {
      String result = '';
      for (int i = 0; i < length; i++) {
        int ele = list[i];
        result += fromInt(ele);
      }
      return result.trim();
    } else {
      return '';
    }
  }
}
