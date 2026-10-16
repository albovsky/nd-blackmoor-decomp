# FUN_0045b37a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045b37a
# extent:       0x0045b37a-0x0045b3ce (84 code bytes)
# span:         0x0045b37a-0x0045b3ce (code 84, tables 0, padding 0)
# sha256:       26cf860627be61a1d5d943cd20befb8f06e148ea71dccf431b8dfa6b8916a0c1
# evidence:     ev_f51cc55276120d19811669e671858343b4478877f4752e92acf19b83badf3e68
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0045b37a
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716, FUN_0045b3ea
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
.set FUN_0045b3ea, .text + (0x0045b3ea - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x0045b37a - 0x401000
.globl FUN_0045b37a
FUN_0045b37a:
    # block 0x0045b37a: entry, 23 instruction(s), calls FUN_0051d716, FUN_0045b3ea, ends with ret
    push ebp                                     # 0045b37a
    {load} mov ebp, esp                          # 0045b37b
    push -0x1                                    # 0045b37d
    push 0x5280cd                                # 0045b37f
    mov eax, dword ptr fs:[0x0]                  # 0045b384
    push eax                                     # 0045b38a
    mov dword ptr fs:[0x0], esp                  # 0045b38b
    push ecx                                     # 0045b392
    mov dword ptr [ebp - local_10], ecx          # 0045b393
    mov ecx, dword ptr [ebp - local_10]          # 0045b396
    call FUN_0051d716                            # 0045b399
    mov dword ptr [ebp - local_4], 0x0           # 0045b39e
    mov eax, dword ptr [ebp - local_10]          # 0045b3a5
    mov dword ptr [eax], 0x52cf70                # 0045b3a8
    mov ecx, dword ptr [ebp - local_10]          # 0045b3ae
    call FUN_0045b3ea                            # 0045b3b1
    mov dword ptr [ebp - local_4], 0xffffffff    # 0045b3b6
    mov eax, dword ptr [ebp - local_10]          # 0045b3bd
    mov ecx, dword ptr [ebp - local_c]           # 0045b3c0
    mov dword ptr fs:[0x0], ecx                  # 0045b3c3
    {load} mov esp, ebp                          # 0045b3ca
    pop ebp                                      # 0045b3cc
    ret                                          # 0045b3cd

