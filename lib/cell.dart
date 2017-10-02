class Cell {
  bool on,
      left,
      right,
      bottom,
      top,
      server,
      locked = false;

  Cell(
      {this.on = false,
      this.left = false,
      this.right = false,
      this.bottom = false,
      this.top = false,
      this.server = false}) {}

  get isOn => on || (!left && !right && !top && !bottom);

  Cell rotateRight() => new Cell(
      server: server,
      on: on,
      top: left,
      right: top,
      bottom: right,
      left: bottom);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cell &&
          runtimeType == other.runtimeType &&
          on == other.on &&
          left == other.left &&
          right == other.right &&
          bottom == other.bottom &&
          top == other.top &&
          server == other.server;

  @override
  int get hashCode =>
      on.hashCode ^
      left.hashCode ^
      right.hashCode ^
      bottom.hashCode ^
      top.hashCode ^
      server.hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();
    writeProperty(server, "Server", buffer);
    buffer.write(on || server ? "On" : "Off");
    writeProperty(left, "Left", buffer);
    writeProperty(right, "Right", buffer);
    writeProperty(bottom, "Bottom", buffer);
    writeProperty(top, "Top", buffer);
    return buffer.toString();
  }

  void writeProperty(bool it, String name, StringBuffer buffer) {
    if (it) {
      buffer.write(name);
    }
  }
}
