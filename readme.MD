**What a `.a` file contains:**

An `.a` is just a **zip of `.o` files** plus an **index** (the armap). The index is a symbol → member lookup table so the linker doesn't have to open every `.o` inside.

```
libdemo.a
├── [index]  ← "die is in log.o, log_err is in log.o, ..."
├── log.o
└── util.o
```

**The big hex numbers (`000000001a`, `00000000a0`, etc.):**

They're **offsets within that single `.o` file** — where the symbol lives in the object file's bytes. `0x1a` = byte 26 from the start of that `.o`. They're **not** final addresses (those get assigned at link time). They're meaningless to you — just "where in this file."

**Symbol type letters:**

| Letter | Meaning | Example |
|--------|---------|---------|
| `T` / `t` | **T**ext (code). Uppercase = global (visible to other files), lowercase = **local** (static, hidden) | `T main`, `t helper` |
| `D` / `d` | **D**ata (initialized globals) | `D count`, `d local_static` |
| `B` / `b` | **B**SS (uninitialized globals, zero-filled) | `B buffer`, `b local_buf` |
| `R` / `r` | **R**ead-only (`.rodata`, string literals, `const` globals) | `R .LC0`, `r .LC1` |
| `U` | **U**ndefined — "I need this from somewhere else" | `U strlen`, `U die` |
| `W` / `w` | **W**eak (optional, can be overridden) | `W __cxa_atexit` |
| `i` | **i**ndirect (rare, alias to another symbol) | — |

**The uppercase/lowercase rule:**

- **Uppercase** = **global** (extern, visible to the linker, can be referenced by other `.o` files)
- **Lowercase** = **local** (marked `static`, only visible within its own `.o`, linker ignores it)

So in your output:

```
T die          ← global function, linker can see it
T log_err      ← global function
T logmsg       ← global function
T main         ← global function
r .LC0         ← local (static) string literal, linker ignores
U strlen       ← "I need strlen, get it from libc"
U syscall      ← "I need syscall, get it from libc"
U die          ← (in main.o) "I need die, get it from log.o"
```

**When you run `nm` on a `.a` directly**, it shows the **index** (which symbols are in which member). When you run `nm` on a single `.o`, it shows that file's own symbol table. The letters are the same either way.


