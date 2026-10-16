# FUN_00408d49
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00408d49
# extent:       0x00408d49-0x0040905e (789 code bytes)
# span:         0x00408d49-0x0040905e (code 789, tables 0, padding 0)
# sha256:       7198779bc038aa471e9aa34fb0003dd4b82acc1e5ad0708177c548408636b9c1
# evidence:     ev_e386b18c20787bc48aa972834711e5868c42e616144977f55cc3e9972895a2f0
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00408d49
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_00401032, FUN_005218ea
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 179 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_00401032, .text + (0x00401032 - 0x401000)
.set FUN_005218ea, .text + (0x005218ea - 0x401000)

.org 0x00408d49 - 0x401000
.globl FUN_00408d49
FUN_00408d49:
    # block 0x00408d49: entry, 179 instruction(s), calls FUN_00401032, FUN_005218ea, ends with ret
    push ebp                                     # 00408d49
    {load} mov ebp, esp                          # 00408d4a
    push -0x1                                    # 00408d4c
    push 0x527242                                # 00408d4e
    mov eax, dword ptr fs:[0x0]                  # 00408d53
    push eax                                     # 00408d59
    mov dword ptr fs:[0x0], esp                  # 00408d5a
    push ecx                                     # 00408d61
    mov dword ptr [ebp - local_10], ecx          # 00408d62
    mov eax, dword ptr [ebp - local_10]          # 00408d65
    mov dword ptr [eax], 0x52c3c0                # 00408d68
    mov dword ptr [ebp - local_4], 0x27          # 00408d6e
    mov ecx, dword ptr [ebp - local_10]          # 00408d75
    add ecx, 0xa4c                               # 00408d78
    call FUN_00401032                            # 00408d7e
    mov byte ptr [ebp - local_4], 0x26           # 00408d83
    mov ecx, dword ptr [ebp - local_10]          # 00408d87
    add ecx, 0xa0c                               # 00408d8a
    call FUN_00401032                            # 00408d90
    mov byte ptr [ebp - local_4], 0x25           # 00408d95
    mov ecx, dword ptr [ebp - local_10]          # 00408d99
    add ecx, 0x9cc                               # 00408d9c
    call FUN_00401032                            # 00408da2
    mov byte ptr [ebp - local_4], 0x24           # 00408da7
    mov ecx, dword ptr [ebp - local_10]          # 00408dab
    add ecx, 0x98c                               # 00408dae
    call FUN_00401032                            # 00408db4
    mov byte ptr [ebp - local_4], 0x23           # 00408db9
    mov ecx, dword ptr [ebp - local_10]          # 00408dbd
    add ecx, 0x94c                               # 00408dc0
    call FUN_00401032                            # 00408dc6
    mov byte ptr [ebp - local_4], 0x22           # 00408dcb
    mov ecx, dword ptr [ebp - local_10]          # 00408dcf
    add ecx, 0x90c                               # 00408dd2
    call FUN_00401032                            # 00408dd8
    mov byte ptr [ebp - local_4], 0x21           # 00408ddd
    mov ecx, dword ptr [ebp - local_10]          # 00408de1
    add ecx, 0x8cc                               # 00408de4
    call FUN_00401032                            # 00408dea
    mov byte ptr [ebp - local_4], 0x20           # 00408def
    mov ecx, dword ptr [ebp - local_10]          # 00408df3
    add ecx, 0x88c                               # 00408df6
    call FUN_00401032                            # 00408dfc
    mov byte ptr [ebp - local_4], 0x1f           # 00408e01
    mov ecx, dword ptr [ebp - local_10]          # 00408e05
    add ecx, 0x84c                               # 00408e08
    call FUN_00401032                            # 00408e0e
    mov byte ptr [ebp - local_4], 0x1e           # 00408e13
    mov ecx, dword ptr [ebp - local_10]          # 00408e17
    add ecx, 0x80c                               # 00408e1a
    call FUN_00401032                            # 00408e20
    mov byte ptr [ebp - local_4], 0x1d           # 00408e25
    mov ecx, dword ptr [ebp - local_10]          # 00408e29
    add ecx, 0x7cc                               # 00408e2c
    call FUN_00401032                            # 00408e32
    mov byte ptr [ebp - local_4], 0x1c           # 00408e37
    mov ecx, dword ptr [ebp - local_10]          # 00408e3b
    add ecx, 0x78c                               # 00408e3e
    call FUN_00401032                            # 00408e44
    mov byte ptr [ebp - local_4], 0x1b           # 00408e49
    mov ecx, dword ptr [ebp - local_10]          # 00408e4d
    add ecx, 0x74c                               # 00408e50
    call FUN_00401032                            # 00408e56
    mov byte ptr [ebp - local_4], 0x1a           # 00408e5b
    mov ecx, dword ptr [ebp - local_10]          # 00408e5f
    add ecx, 0x70c                               # 00408e62
    call FUN_00401032                            # 00408e68
    mov byte ptr [ebp - local_4], 0x19           # 00408e6d
    mov ecx, dword ptr [ebp - local_10]          # 00408e71
    add ecx, 0x6cc                               # 00408e74
    call FUN_00401032                            # 00408e7a
    mov byte ptr [ebp - local_4], 0x18           # 00408e7f
    mov ecx, dword ptr [ebp - local_10]          # 00408e83
    add ecx, 0x68c                               # 00408e86
    call FUN_00401032                            # 00408e8c
    mov byte ptr [ebp - local_4], 0x17           # 00408e91
    mov ecx, dword ptr [ebp - local_10]          # 00408e95
    add ecx, 0x64c                               # 00408e98
    call FUN_00401032                            # 00408e9e
    mov byte ptr [ebp - local_4], 0x16           # 00408ea3
    mov ecx, dword ptr [ebp - local_10]          # 00408ea7
    add ecx, 0x60c                               # 00408eaa
    call FUN_00401032                            # 00408eb0
    mov byte ptr [ebp - local_4], 0x15           # 00408eb5
    mov ecx, dword ptr [ebp - local_10]          # 00408eb9
    add ecx, 0x5cc                               # 00408ebc
    call FUN_00401032                            # 00408ec2
    mov byte ptr [ebp - local_4], 0x14           # 00408ec7
    mov ecx, dword ptr [ebp - local_10]          # 00408ecb
    add ecx, 0x58c                               # 00408ece
    call FUN_00401032                            # 00408ed4
    mov byte ptr [ebp - local_4], 0x13           # 00408ed9
    mov ecx, dword ptr [ebp - local_10]          # 00408edd
    add ecx, 0x54c                               # 00408ee0
    call FUN_00401032                            # 00408ee6
    mov byte ptr [ebp - local_4], 0x12           # 00408eeb
    mov ecx, dword ptr [ebp - local_10]          # 00408eef
    add ecx, 0x50c                               # 00408ef2
    call FUN_00401032                            # 00408ef8
    mov byte ptr [ebp - local_4], 0x11           # 00408efd
    mov ecx, dword ptr [ebp - local_10]          # 00408f01
    add ecx, 0x4cc                               # 00408f04
    call FUN_00401032                            # 00408f0a
    mov byte ptr [ebp - local_4], 0x10           # 00408f0f
    mov ecx, dword ptr [ebp - local_10]          # 00408f13
    add ecx, 0x48c                               # 00408f16
    call FUN_00401032                            # 00408f1c
    mov byte ptr [ebp - local_4], 0xf            # 00408f21
    mov ecx, dword ptr [ebp - local_10]          # 00408f25
    add ecx, 0x44c                               # 00408f28
    call FUN_00401032                            # 00408f2e
    mov byte ptr [ebp - local_4], 0xe            # 00408f33
    mov ecx, dword ptr [ebp - local_10]          # 00408f37
    add ecx, 0x40c                               # 00408f3a
    call FUN_00401032                            # 00408f40
    mov byte ptr [ebp - local_4], 0xd            # 00408f45
    mov ecx, dword ptr [ebp - local_10]          # 00408f49
    add ecx, 0x3cc                               # 00408f4c
    call FUN_00401032                            # 00408f52
    mov byte ptr [ebp - local_4], 0xc            # 00408f57
    mov ecx, dword ptr [ebp - local_10]          # 00408f5b
    add ecx, 0x38c                               # 00408f5e
    call FUN_00401032                            # 00408f64
    mov byte ptr [ebp - local_4], 0xb            # 00408f69
    mov ecx, dword ptr [ebp - local_10]          # 00408f6d
    add ecx, 0x34c                               # 00408f70
    call FUN_00401032                            # 00408f76
    mov byte ptr [ebp - local_4], 0xa            # 00408f7b
    mov ecx, dword ptr [ebp - local_10]          # 00408f7f
    add ecx, 0x30c                               # 00408f82
    call FUN_00401032                            # 00408f88
    mov byte ptr [ebp - local_4], 0x9            # 00408f8d
    mov ecx, dword ptr [ebp - local_10]          # 00408f91
    add ecx, 0x2cc                               # 00408f94
    call FUN_00401032                            # 00408f9a
    mov byte ptr [ebp - local_4], 0x8            # 00408f9f
    mov ecx, dword ptr [ebp - local_10]          # 00408fa3
    add ecx, 0x28c                               # 00408fa6
    call FUN_00401032                            # 00408fac
    mov byte ptr [ebp - local_4], 0x7            # 00408fb1
    mov ecx, dword ptr [ebp - local_10]          # 00408fb5
    add ecx, 0x24c                               # 00408fb8
    call FUN_00401032                            # 00408fbe
    mov byte ptr [ebp - local_4], 0x6            # 00408fc3
    mov ecx, dword ptr [ebp - local_10]          # 00408fc7
    add ecx, 0x20c                               # 00408fca
    call FUN_00401032                            # 00408fd0
    mov byte ptr [ebp - local_4], 0x5            # 00408fd5
    mov ecx, dword ptr [ebp - local_10]          # 00408fd9
    add ecx, 0x1cc                               # 00408fdc
    call FUN_00401032                            # 00408fe2
    mov byte ptr [ebp - local_4], 0x4            # 00408fe7
    mov ecx, dword ptr [ebp - local_10]          # 00408feb
    add ecx, 0x18c                               # 00408fee
    call FUN_00401032                            # 00408ff4
    mov byte ptr [ebp - local_4], 0x3            # 00408ff9
    mov ecx, dword ptr [ebp - local_10]          # 00408ffd
    add ecx, 0x14c                               # 00409000
    call FUN_00401032                            # 00409006
    mov byte ptr [ebp - local_4], 0x2            # 0040900b
    mov ecx, dword ptr [ebp - local_10]          # 0040900f
    add ecx, 0x10c                               # 00409012
    call FUN_00401032                            # 00409018
    mov byte ptr [ebp - local_4], 0x1            # 0040901d
    mov ecx, dword ptr [ebp - local_10]          # 00409021
    add ecx, 0xcc                                # 00409024
    call FUN_00401032                            # 0040902a
    mov byte ptr [ebp - local_4], 0x0            # 0040902f
    mov ecx, dword ptr [ebp - local_10]          # 00409033
    add ecx, 0x8c                                # 00409036
    call FUN_00401032                            # 0040903c
    mov dword ptr [ebp - local_4], 0xffffffff    # 00409041
    mov ecx, dword ptr [ebp - local_10]          # 00409048
    call FUN_005218ea                            # 0040904b
    mov ecx, dword ptr [ebp - local_c]           # 00409050
    mov dword ptr fs:[0x0], ecx                  # 00409053
    {load} mov esp, ebp                          # 0040905a
    pop ebp                                      # 0040905c
    ret                                          # 0040905d

