func markUsed<T>(_ t: T) {}
func f() {
  if 1==1 {
#sourceLocation(file: "abc.swift", line: 42)
    markUsed("Hello World")
#sourceLocation()
  }
  markUsed("Test")
#sourceLocation(file: "abc.swift", line: 142)
  markUsed("abc again")
#sourceLocation(file: "/absolute/path/def.swift", line:  142)
  markUsed("jump directly to def")
}

// RUN: %target-swift-frontend -primary-file %/s -S -g -o - | %FileCheck %s
// CHECK: .file	[[MAIN:.*]] "{{.*}}line-directive.swift"
// CHECK: .loc	[[MAIN]] 1
// CHECK: .file	[[ABC:.*]] "{{.*}}abc.swift"
// CHECK: .loc	[[ABC]] 42
// CHECK: .loc	[[MAIN]] 8
// CHECK: .loc	[[ABC]] 142
// CHECK: .file	[[DEF:.*]] "/absolute/path/def.swift"
// CHECK: .loc	[[DEF]] 142
// CHECK: .asciz "{{.*}}test/DebugInfo"

// RUN: %empty-directory(%t)
// RUN: sed -e "s|LINE_DIRECTIVE_DIR|%/S|g" %S/Inputs/vfsoverlay.yaml > %t/overlay.yaml
// RUN: %target-swift-frontend -vfsoverlay %t/overlay.yaml -primary-file %/S/vfs-relocated-line-directive.swift -S -g -o - | %FileCheck -check-prefix=VFS %s
// VFS: .file  [[MAIN:.*]] "{{.*}}vfs-relocated-line-directive.swift"
// VFS: .loc  [[MAIN]] 1
// VFS: .file  [[ABC:.*]] "{{.*}}abc.swift"
// VFS: .loc  [[ABC]] 42
// VFS: .loc  [[MAIN]] 8
// VFS: .loc  [[ABC]] 142
// VFS: .file  [[DEF:.*]] "/absolute/path/def.swift"
// VFS: .loc  [[DEF]] 142
// VFS: .asciz "{{.*}}test/DebugInfo"
