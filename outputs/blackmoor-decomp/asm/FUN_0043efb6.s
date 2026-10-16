# FUN_0043efb6
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043efb6
# extent:       0x0043efb6-0x0043eff3 (61 code bytes)
# span:         0x0043efb6-0x0043eff3 (code 61, tables 0, padding 0)
# sha256:       42dbbb9731a3aecc60c4db779d792492909a83b412b6db49f702de96e237b8f2
# evidence:     ev_a02c75cbc1d4015894407da678b6f6960a9313cc0dac24962171d655dab0d610
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0043efb6
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 22 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------

.org 0x0043efb6 - 0x401000
.globl FUN_0043efb6
FUN_0043efb6:
    # block 0x0043efb6: entry, 8 instruction(s), ends with forward jump to 0x0043efd7
    push ebp                                     # 0043efb6
    {load} mov ebp, esp                          # 0043efb7
    sub esp, 0xc                                 # 0043efb9
    mov dword ptr [ebp - local_c], ecx           # 0043efbc
    mov eax, dword ptr [ebp + arg_8]             # 0043efbf
    mov dword ptr [ebp - local_4], eax           # 0043efc2
    mov dword ptr [ebp - local_8], 0x0           # 0043efc5
    jmp.d8 L_0043efd7                            # 0043efcc
L_0043efce:
    # block 0x0043efce: entered by jmp at 0x0043efeb, 3 instruction(s), falls into the block at 0x0043efd7
    mov ecx, dword ptr [ebp - local_8]           # 0043efce
    add ecx, 0x1                                 # 0043efd1
    mov dword ptr [ebp - local_8], ecx           # 0043efd4
L_0043efd7:
    # block 0x0043efd7: entered by jmp at 0x0043efcc, 3 instruction(s), ends with jge to 0x0043efed (forward)
    mov edx, dword ptr [ebp - local_8]           # 0043efd7
    cmp edx, dword ptr [ebp + arg_10]            # 0043efda
    jge.d8 L_0043efed                            # 0043efdd
    # block 0x0043efdf: entered by fall-through of jge at 0x0043efdd, 5 instruction(s), ends with backward jump to 0x0043efce
    mov eax, dword ptr [ebp - local_8]           # 0043efdf
    mov ecx, dword ptr [ebp - local_4]           # 0043efe2
    mov edx, dword ptr [ebp + arg_c]             # 0043efe5
    mov dword ptr [ecx + 4*eax], edx             # 0043efe8
    jmp.d8 L_0043efce                            # 0043efeb
L_0043efed:
    # block 0x0043efed: entered by jge at 0x0043efdd, 3 instruction(s), ends with ret 0xc
    {load} mov esp, ebp                          # 0043efed
    pop ebp                                      # 0043efef
    ret 0xc                                      # 0043eff0

