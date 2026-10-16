# FUN_00454d6e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00454d6e
# extent:       0x00454d6e-0x00454d8a (28 code bytes)
# span:         0x00454d6e-0x00454d8a (code 28, tables 0, padding 0)
# sha256:       928f1487e065075d96ff58321d90c0efe9f66674a385e5c54d80fcbd9be60cd9
# evidence:     ev_d9db35753575c6f4f6d3b54f0e558794e685953e363fb4d0275dfb0787ca7633
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00454d6e
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d730
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_0051d730, .text + (0x0051d730 - 0x401000)

.org 0x00454d6e - 0x401000
.globl FUN_00454d6e
FUN_00454d6e:
    # block 0x00454d6e: entry, 11 instruction(s), calls FUN_0051d730, ends with ret
    push ebp                                     # 00454d6e
    {load} mov ebp, esp                          # 00454d6f
    push ecx                                     # 00454d71
    mov dword ptr [ebp - local_4], ecx           # 00454d72
    mov eax, dword ptr [ebp - local_4]           # 00454d75
    mov dword ptr [eax], 0x52cd50                # 00454d78
    mov ecx, dword ptr [ebp - local_4]           # 00454d7e
    call FUN_0051d730                            # 00454d81
    {load} mov esp, ebp                          # 00454d86
    pop ebp                                      # 00454d88
    ret                                          # 00454d89

