# FUN_0043eff3
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043eff3
# extent:       0x0043eff3-0x0043f04b (88 code bytes)
# span:         0x0043eff3-0x0043f04b (code 88, tables 0, padding 0)
# sha256:       081492e18c5361f6ff41ed81a2b9ce846949d058cb303918a6984493fca42b5a
# evidence:     ev_a02c75cbc1d4015894407da678b6f6960a9313cc0dac24962171d655dab0d610
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m43eff3_lifted
# naming:       native port src/original_methods_fl40.c:m43eff3_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine translation of the original instructions (scripts/lift_function.py) over the 32-bit address space, 3 seeds; oracle: 35/35 instructions executed, 2/2 conditional-jump directions taken, callees as recording stubs.
# arguments:    5 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14, arg_18; ret 0x14 (callee pops 20 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m43eff3_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 35 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ arg_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------

.org 0x0043eff3 - 0x401000
.globl FUN_0043eff3
FUN_0043eff3:
    # block 0x0043eff3: entry, 8 instruction(s), ends with forward jump to 0x0043f010
    push ebp                                     # 0043eff3
    {load} mov ebp, esp                          # 0043eff4
    sub esp, 0x8                                 # 0043eff6
    push esi                                     # 0043eff9
    push edi                                     # 0043effa
    mov dword ptr [ebp - local_8], ecx           # 0043effb
    mov dword ptr [ebp - local_4], 0x0           # 0043effe
    jmp.d8 L_0043f010                            # 0043f005
L_0043f007:
    # block 0x0043f007: entered by jmp at 0x0043f041, 3 instruction(s), falls into the block at 0x0043f010
    mov eax, dword ptr [ebp - local_4]           # 0043f007
    add eax, 0x1                                 # 0043f00a
    mov dword ptr [ebp - local_4], eax           # 0043f00d
L_0043f010:
    # block 0x0043f010: entered by jmp at 0x0043f005, 3 instruction(s), ends with jge to 0x0043f043 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 0043f010
    cmp ecx, dword ptr [ebp + arg_10]            # 0043f013
    jge.d8 L_0043f043                            # 0043f016
    # block 0x0043f018: entered by fall-through of jge at 0x0043f016, 16 instruction(s), ends with backward jump to 0x0043f007
    mov ecx, dword ptr [ebp + arg_14]            # 0043f018
    mov esi, dword ptr [ebp + arg_c]             # 0043f01b
    mov edi, dword ptr [ebp + arg_8]             # 0043f01e
    {load} mov edx, ecx                          # 0043f021
    shr ecx, 0x2                                 # 0043f023
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043f026
    {load} mov ecx, edx                          # 0043f028
    and ecx, 0x3                                 # 0043f02a
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0043f02d
    mov eax, dword ptr [ebp + arg_c]             # 0043f02f
    add eax, dword ptr [ebp + arg_14]            # 0043f032
    mov dword ptr [ebp + arg_c], eax             # 0043f035
    mov ecx, dword ptr [ebp + arg_8]             # 0043f038
    add ecx, dword ptr [ebp + arg_18]            # 0043f03b
    mov dword ptr [ebp + arg_8], ecx             # 0043f03e
    jmp.d8 L_0043f007                            # 0043f041
L_0043f043:
    # block 0x0043f043: entered by jge at 0x0043f016, 5 instruction(s), ends with ret 0x14
    pop edi                                      # 0043f043
    pop esi                                      # 0043f044
    {load} mov esp, ebp                          # 0043f045
    pop ebp                                      # 0043f047
    ret 0x14                                     # 0043f048

