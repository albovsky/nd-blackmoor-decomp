# FUN_004709bb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004709bb
# extent:       0x004709bb-0x004709de (35 code bytes)
# span:         0x004709bb-0x004709de (code 35, tables 0, padding 0)
# sha256:       bc9aef196c85f89047bf7406ee5b3097c989593221507f129b5e77db62bc4a61
# evidence:     ev_4142f99cf250975ea00b2347f810409c5bbf0cca5348258d5fd0578a4530c136
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004709bb
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 14 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x004709bb - 0x401000
.globl FUN_004709bb
FUN_004709bb:
    # block 0x004709bb: entry, 6 instruction(s), ends with jne to 0x004709cf (forward)
    push ebp                                     # 004709bb
    {load} mov ebp, esp                          # 004709bc
    push ecx                                     # 004709be
    mov dword ptr [ebp - local_4], ecx           # 004709bf
    cmp dword ptr [ebp + arg_8], 0x0             # 004709c2
    jne.d8 L_004709cf                            # 004709c6
    # block 0x004709c8: entered by fall-through of jne at 0x004709c6, 2 instruction(s), ends with forward jump to 0x004709d8
    mov eax, 0x1b                                # 004709c8
    jmp.d8 L_004709d8                            # 004709cd
L_004709cf:
    # block 0x004709cf: entered by jne at 0x004709c6, 3 instruction(s), falls into the block at 0x004709d8
    mov eax, dword ptr [ebp + arg_8]             # 004709cf
    sub eax, 0x1                                 # 004709d2
    imul eax, eax, 0x3                           # 004709d5
L_004709d8:
    # block 0x004709d8: entered by jmp at 0x004709cd, 3 instruction(s), ends with ret 0x4
    {load} mov esp, ebp                          # 004709d8
    pop ebp                                      # 004709da
    ret 0x4                                      # 004709db

