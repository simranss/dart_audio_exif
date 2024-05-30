extension ListExtension on List<int> {
  int indexOfList(List<int> list) {
    if (list.isEmpty || list.length > length) return -1;
    for (int i = 0; i <= length - list.length; i++) {
      bool match = true;
      for (int j = 0; j < list.length; j++) {
        if (this[i + j] != list[j]) {
          match = false;
          break;
        }
      }
      if (match) {
        return i;
      }
    }
    return -1; // Return -1 if list2 is not found in list1
  }

  bool startsWith(List<int> list) {
    if (list.length > length || list.isEmpty) {
      return false;
    }

    for (int i = 0; i < list.length; i++) {
      if (this[i] != list[i]) {
        return false;
      }
    }
    return true;
  }
}
