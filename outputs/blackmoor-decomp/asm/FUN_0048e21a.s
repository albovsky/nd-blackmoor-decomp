# FUN_0048e21a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048e21a
# extent:       0x0048e21a-0x0048e26e (84 code bytes)
# span:         0x0048e21a-0x0048e26e (code 84, tables 0, padding 0)
# sha256:       271a7fdb2a621a6b7103145d4a5b2ec391a21938dcde3836a46f677850828043
# evidence:     ev_7981f36fcfb340c87ff1ac4ba66e833832bd1313751938cee07fade4f0082dcf
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0048e21a
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716, FUN_0048e28a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 23 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0048e28a, .text + (0x0048e28a - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x0048e21a - 0x401000
.globl FUN_0048e21a
FUN_0048e21a:
    # block 0x0048e21a: entry, 23 instruction(s), calls FUN_0051d716, FUN_0048e28a, ends with ret
    push ebp                                     # 0048e21a
    {load} mov ebp, esp                          # 0048e21b
    push -0x1                                    # 0048e21d
    push 0x5284fd                                # 0048e21f
    mov eax, dword ptr fs:[0x0]                  # 0048e224
    push eax                                     # 0048e22a
    mov dword ptr fs:[0x0], esp                  # 0048e22b
    push ecx                                     # 0048e232
    mov dword ptr [ebp - local_10], ecx          # 0048e233
    mov ecx, dword ptr [ebp - local_10]          # 0048e236
    call FUN_0051d716                            # 0048e239
    mov dword ptr [ebp - local_4], 0x0           # 0048e23e
    mov eax, dword ptr [ebp - local_10]          # 0048e245
    mov dword ptr [eax], 0x52da70                # 0048e248
    mov ecx, dword ptr [ebp - local_10]          # 0048e24e
    call FUN_0048e28a                            # 0048e251
    mov dword ptr [ebp - local_4], 0xffffffff    # 0048e256
    mov eax, dword ptr [ebp - local_10]          # 0048e25d
    mov ecx, dword ptr [ebp - local_c]           # 0048e260
    mov dword ptr fs:[0x0], ecx                  # 0048e263
    {load} mov esp, ebp                          # 0048e26a
    pop ebp                                      # 0048e26c
    ret                                          # 0048e26d

