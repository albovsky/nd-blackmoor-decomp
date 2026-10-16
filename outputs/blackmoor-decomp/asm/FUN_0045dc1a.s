# FUN_0045dc1a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045dc1a
# extent:       0x0045dc1a-0x0045dc6e (84 code bytes)
# span:         0x0045dc1a-0x0045dc6e (code 84, tables 0, padding 0)
# sha256:       f5a646ab42f4a4a43425ac64253f31469c0f034d4e5b6efef1b9bb937698d65b
# evidence:     ev_f51cc55276120d19811669e671858343b4478877f4752e92acf19b83badf3e68
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0045dc1a
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716, FUN_0045dc8a
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
.set FUN_0045dc8a, .text + (0x0045dc8a - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x0045dc1a - 0x401000
.globl FUN_0045dc1a
FUN_0045dc1a:
    # block 0x0045dc1a: entry, 23 instruction(s), calls FUN_0051d716, FUN_0045dc8a, ends with ret
    push ebp                                     # 0045dc1a
    {load} mov ebp, esp                          # 0045dc1b
    push -0x1                                    # 0045dc1d
    push 0x5280fd                                # 0045dc1f
    mov eax, dword ptr fs:[0x0]                  # 0045dc24
    push eax                                     # 0045dc2a
    mov dword ptr fs:[0x0], esp                  # 0045dc2b
    push ecx                                     # 0045dc32
    mov dword ptr [ebp - local_10], ecx          # 0045dc33
    mov ecx, dword ptr [ebp - local_10]          # 0045dc36
    call FUN_0051d716                            # 0045dc39
    mov dword ptr [ebp - local_4], 0x0           # 0045dc3e
    mov eax, dword ptr [ebp - local_10]          # 0045dc45
    mov dword ptr [eax], 0x52cff8                # 0045dc48
    mov ecx, dword ptr [ebp - local_10]          # 0045dc4e
    call FUN_0045dc8a                            # 0045dc51
    mov dword ptr [ebp - local_4], 0xffffffff    # 0045dc56
    mov eax, dword ptr [ebp - local_10]          # 0045dc5d
    mov ecx, dword ptr [ebp - local_c]           # 0045dc60
    mov dword ptr fs:[0x0], ecx                  # 0045dc63
    {load} mov esp, ebp                          # 0045dc6a
    pop ebp                                      # 0045dc6c
    ret                                          # 0045dc6d

