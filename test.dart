abstract class A {
  int build();
}

mixin Mixin on A {
  @override
  int build() {
    return 2;
  }
}

class Impl extends A with Mixin {
  @override
  int build() {
    return 1;
  }
}

void main() {
  final impl = Impl();
  print(impl.build());
}
