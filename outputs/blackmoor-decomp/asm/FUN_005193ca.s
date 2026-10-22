# FUN_005193ca
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005193ca
# extent:       0x005193ca-0x005193f7 (45 code bytes)
# span:         0x005193ca-0x005193f7 (code 45, tables 0, padding 0)
# sha256:       0b10051bfe983a39084ed57ab72f0bd42db98bbb410280c695c0bf184fb02308
# evidence:     ev_b751a5094d1e8211f653554618c4b14e01ac05861f47e521c34e1b18a0e9f8e5
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005193ca
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_005193f7
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl30b.c:m411f24_replace_record (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_005193f7, .text + (0x005193f7 - 0x401000)

.org 0x005193ca - 0x401000
.globl FUN_005193ca
FUN_005193ca:
    # block 0x005193ca: entry, 4 instruction(s), ends with jne to 0x005193df (forward)
    push ebp                                     # 005193ca
    {load} mov ebp, esp                          # 005193cb
    cmp dword ptr [ebp + arg_10], 0xa            # 005193cd
    jne.d8 L_005193df                            # 005193d1
    # block 0x005193d3: entered by fall-through of jne at 0x005193d1, 2 instruction(s), ends with jge to 0x005193df (forward)
    cmp dword ptr [ebp + arg_8], 0x0             # 005193d3
    jge.d8 L_005193df                            # 005193d7
    # block 0x005193d9: entered by fall-through of jge at 0x005193d7, 3 instruction(s), ends with forward jump to 0x005193e4
    push 0x1                                     # 005193d9
    push 0xa                                     # 005193db
    jmp.d8 L_005193e4                            # 005193dd
L_005193df:
    # block 0x005193df: entered by jne at 0x005193d1; jge at 0x005193d7, 2 instruction(s), falls into the block at 0x005193e4
    push 0x0                                     # 005193df
    push dword ptr [ebp + arg_10]                # 005193e1
L_005193e4:
    # block 0x005193e4: entered by jmp at 0x005193dd, 7 instruction(s), calls FUN_005193f7, ends with ret
    push dword ptr [ebp + arg_c]                 # 005193e4
    push dword ptr [ebp + arg_8]                 # 005193e7
    call FUN_005193f7                            # 005193ea
    mov eax, dword ptr [ebp + arg_c]             # 005193ef
    add esp, 0x10                                # 005193f2
    pop ebp                                      # 005193f5
    ret                                          # 005193f6

