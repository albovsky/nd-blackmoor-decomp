# FUN_00408a2a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00408a2a
# extent:       0x00408a2a-0x00408d49 (799 code bytes)
# span:         0x00408a2a-0x00408d49 (code 799, tables 0, padding 0)
# sha256:       49f4e325d82b84886b56ecfe297b8542bb1c6321193b46d36f529fe4cf6589fc
# evidence:     ev_e386b18c20787bc48aa972834711e5868c42e616144977f55cc3e9972895a2f0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m408a2a_lifted
# naming:       native port src/original_methods_fl40.c:m408a2a_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py) over the 32-bit address space, 1 seeds; oracle: 182/182 instructions executed, 0/0 conditional-jump directions taken, callees as recording stubs.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_005217e4, FUN_00401000
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m408a2a_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 182 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00401000, .text + (0x00401000 - 0x401000)
.set FUN_005217e4, .text + (0x005217e4 - 0x401000)

.org 0x00408a2a - 0x401000
.globl FUN_00408a2a
FUN_00408a2a:
    # block 0x00408a2a: entry, 182 instruction(s), calls FUN_005217e4, FUN_00401000, ends with ret
    push ebp                                     # 00408a2a
    {load} mov ebp, esp                          # 00408a2b
    push -0x1                                    # 00408a2d
    push 0x526fe6                                # 00408a2f
    mov eax, dword ptr fs:[0x0]                  # 00408a34
    push eax                                     # 00408a3a
    mov dword ptr fs:[0x0], esp                  # 00408a3b
    push ecx                                     # 00408a42
    mov dword ptr [ebp - local_10], ecx          # 00408a43
    push 0x0                                     # 00408a46
    push 0xbb                                    # 00408a48
    mov ecx, dword ptr [ebp - local_10]          # 00408a4d
    call FUN_005217e4                            # 00408a50
    mov dword ptr [ebp - local_4], 0x0           # 00408a55
    mov ecx, dword ptr [ebp - local_10]          # 00408a5c
    add ecx, 0x8c                                # 00408a5f
    call FUN_00401000                            # 00408a65
    mov byte ptr [ebp - local_4], 0x1            # 00408a6a
    mov ecx, dword ptr [ebp - local_10]          # 00408a6e
    add ecx, 0xcc                                # 00408a71
    call FUN_00401000                            # 00408a77
    mov byte ptr [ebp - local_4], 0x2            # 00408a7c
    mov ecx, dword ptr [ebp - local_10]          # 00408a80
    add ecx, 0x10c                               # 00408a83
    call FUN_00401000                            # 00408a89
    mov byte ptr [ebp - local_4], 0x3            # 00408a8e
    mov ecx, dword ptr [ebp - local_10]          # 00408a92
    add ecx, 0x14c                               # 00408a95
    call FUN_00401000                            # 00408a9b
    mov byte ptr [ebp - local_4], 0x4            # 00408aa0
    mov ecx, dword ptr [ebp - local_10]          # 00408aa4
    add ecx, 0x18c                               # 00408aa7
    call FUN_00401000                            # 00408aad
    mov byte ptr [ebp - local_4], 0x5            # 00408ab2
    mov ecx, dword ptr [ebp - local_10]          # 00408ab6
    add ecx, 0x1cc                               # 00408ab9
    call FUN_00401000                            # 00408abf
    mov byte ptr [ebp - local_4], 0x6            # 00408ac4
    mov ecx, dword ptr [ebp - local_10]          # 00408ac8
    add ecx, 0x20c                               # 00408acb
    call FUN_00401000                            # 00408ad1
    mov byte ptr [ebp - local_4], 0x7            # 00408ad6
    mov ecx, dword ptr [ebp - local_10]          # 00408ada
    add ecx, 0x24c                               # 00408add
    call FUN_00401000                            # 00408ae3
    mov byte ptr [ebp - local_4], 0x8            # 00408ae8
    mov ecx, dword ptr [ebp - local_10]          # 00408aec
    add ecx, 0x28c                               # 00408aef
    call FUN_00401000                            # 00408af5
    mov byte ptr [ebp - local_4], 0x9            # 00408afa
    mov ecx, dword ptr [ebp - local_10]          # 00408afe
    add ecx, 0x2cc                               # 00408b01
    call FUN_00401000                            # 00408b07
    mov byte ptr [ebp - local_4], 0xa            # 00408b0c
    mov ecx, dword ptr [ebp - local_10]          # 00408b10
    add ecx, 0x30c                               # 00408b13
    call FUN_00401000                            # 00408b19
    mov byte ptr [ebp - local_4], 0xb            # 00408b1e
    mov ecx, dword ptr [ebp - local_10]          # 00408b22
    add ecx, 0x34c                               # 00408b25
    call FUN_00401000                            # 00408b2b
    mov byte ptr [ebp - local_4], 0xc            # 00408b30
    mov ecx, dword ptr [ebp - local_10]          # 00408b34
    add ecx, 0x38c                               # 00408b37
    call FUN_00401000                            # 00408b3d
    mov byte ptr [ebp - local_4], 0xd            # 00408b42
    mov ecx, dword ptr [ebp - local_10]          # 00408b46
    add ecx, 0x3cc                               # 00408b49
    call FUN_00401000                            # 00408b4f
    mov byte ptr [ebp - local_4], 0xe            # 00408b54
    mov ecx, dword ptr [ebp - local_10]          # 00408b58
    add ecx, 0x40c                               # 00408b5b
    call FUN_00401000                            # 00408b61
    mov byte ptr [ebp - local_4], 0xf            # 00408b66
    mov ecx, dword ptr [ebp - local_10]          # 00408b6a
    add ecx, 0x44c                               # 00408b6d
    call FUN_00401000                            # 00408b73
    mov byte ptr [ebp - local_4], 0x10           # 00408b78
    mov ecx, dword ptr [ebp - local_10]          # 00408b7c
    add ecx, 0x48c                               # 00408b7f
    call FUN_00401000                            # 00408b85
    mov byte ptr [ebp - local_4], 0x11           # 00408b8a
    mov ecx, dword ptr [ebp - local_10]          # 00408b8e
    add ecx, 0x4cc                               # 00408b91
    call FUN_00401000                            # 00408b97
    mov byte ptr [ebp - local_4], 0x12           # 00408b9c
    mov ecx, dword ptr [ebp - local_10]          # 00408ba0
    add ecx, 0x50c                               # 00408ba3
    call FUN_00401000                            # 00408ba9
    mov byte ptr [ebp - local_4], 0x13           # 00408bae
    mov ecx, dword ptr [ebp - local_10]          # 00408bb2
    add ecx, 0x54c                               # 00408bb5
    call FUN_00401000                            # 00408bbb
    mov byte ptr [ebp - local_4], 0x14           # 00408bc0
    mov ecx, dword ptr [ebp - local_10]          # 00408bc4
    add ecx, 0x58c                               # 00408bc7
    call FUN_00401000                            # 00408bcd
    mov byte ptr [ebp - local_4], 0x15           # 00408bd2
    mov ecx, dword ptr [ebp - local_10]          # 00408bd6
    add ecx, 0x5cc                               # 00408bd9
    call FUN_00401000                            # 00408bdf
    mov byte ptr [ebp - local_4], 0x16           # 00408be4
    mov ecx, dword ptr [ebp - local_10]          # 00408be8
    add ecx, 0x60c                               # 00408beb
    call FUN_00401000                            # 00408bf1
    mov byte ptr [ebp - local_4], 0x17           # 00408bf6
    mov ecx, dword ptr [ebp - local_10]          # 00408bfa
    add ecx, 0x64c                               # 00408bfd
    call FUN_00401000                            # 00408c03
    mov byte ptr [ebp - local_4], 0x18           # 00408c08
    mov ecx, dword ptr [ebp - local_10]          # 00408c0c
    add ecx, 0x68c                               # 00408c0f
    call FUN_00401000                            # 00408c15
    mov byte ptr [ebp - local_4], 0x19           # 00408c1a
    mov ecx, dword ptr [ebp - local_10]          # 00408c1e
    add ecx, 0x6cc                               # 00408c21
    call FUN_00401000                            # 00408c27
    mov byte ptr [ebp - local_4], 0x1a           # 00408c2c
    mov ecx, dword ptr [ebp - local_10]          # 00408c30
    add ecx, 0x70c                               # 00408c33
    call FUN_00401000                            # 00408c39
    mov byte ptr [ebp - local_4], 0x1b           # 00408c3e
    mov ecx, dword ptr [ebp - local_10]          # 00408c42
    add ecx, 0x74c                               # 00408c45
    call FUN_00401000                            # 00408c4b
    mov byte ptr [ebp - local_4], 0x1c           # 00408c50
    mov ecx, dword ptr [ebp - local_10]          # 00408c54
    add ecx, 0x78c                               # 00408c57
    call FUN_00401000                            # 00408c5d
    mov byte ptr [ebp - local_4], 0x1d           # 00408c62
    mov ecx, dword ptr [ebp - local_10]          # 00408c66
    add ecx, 0x7cc                               # 00408c69
    call FUN_00401000                            # 00408c6f
    mov byte ptr [ebp - local_4], 0x1e           # 00408c74
    mov ecx, dword ptr [ebp - local_10]          # 00408c78
    add ecx, 0x80c                               # 00408c7b
    call FUN_00401000                            # 00408c81
    mov byte ptr [ebp - local_4], 0x1f           # 00408c86
    mov ecx, dword ptr [ebp - local_10]          # 00408c8a
    add ecx, 0x84c                               # 00408c8d
    call FUN_00401000                            # 00408c93
    mov byte ptr [ebp - local_4], 0x20           # 00408c98
    mov ecx, dword ptr [ebp - local_10]          # 00408c9c
    add ecx, 0x88c                               # 00408c9f
    call FUN_00401000                            # 00408ca5
    mov byte ptr [ebp - local_4], 0x21           # 00408caa
    mov ecx, dword ptr [ebp - local_10]          # 00408cae
    add ecx, 0x8cc                               # 00408cb1
    call FUN_00401000                            # 00408cb7
    mov byte ptr [ebp - local_4], 0x22           # 00408cbc
    mov ecx, dword ptr [ebp - local_10]          # 00408cc0
    add ecx, 0x90c                               # 00408cc3
    call FUN_00401000                            # 00408cc9
    mov byte ptr [ebp - local_4], 0x23           # 00408cce
    mov ecx, dword ptr [ebp - local_10]          # 00408cd2
    add ecx, 0x94c                               # 00408cd5
    call FUN_00401000                            # 00408cdb
    mov byte ptr [ebp - local_4], 0x24           # 00408ce0
    mov ecx, dword ptr [ebp - local_10]          # 00408ce4
    add ecx, 0x98c                               # 00408ce7
    call FUN_00401000                            # 00408ced
    mov byte ptr [ebp - local_4], 0x25           # 00408cf2
    mov ecx, dword ptr [ebp - local_10]          # 00408cf6
    add ecx, 0x9cc                               # 00408cf9
    call FUN_00401000                            # 00408cff
    mov byte ptr [ebp - local_4], 0x26           # 00408d04
    mov ecx, dword ptr [ebp - local_10]          # 00408d08
    add ecx, 0xa0c                               # 00408d0b
    call FUN_00401000                            # 00408d11
    mov byte ptr [ebp - local_4], 0x27           # 00408d16
    mov ecx, dword ptr [ebp - local_10]          # 00408d1a
    add ecx, 0xa4c                               # 00408d1d
    call FUN_00401000                            # 00408d23
    mov eax, dword ptr [ebp - local_10]          # 00408d28
    mov dword ptr [eax], 0x52c3c0                # 00408d2b
    mov dword ptr [ebp - local_4], 0xffffffff    # 00408d31
    mov eax, dword ptr [ebp - local_10]          # 00408d38
    mov ecx, dword ptr [ebp - local_c]           # 00408d3b
    mov dword ptr fs:[0x0], ecx                  # 00408d3e
    {load} mov esp, ebp                          # 00408d45
    pop ebp                                      # 00408d47
    ret                                          # 00408d48

