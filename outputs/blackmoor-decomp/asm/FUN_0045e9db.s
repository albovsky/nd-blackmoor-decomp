# FUN_0045e9db
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045e9db
# extent:       0x0045e9db-0x0045ea4a (111 code bytes)
# span:         0x0045e9db-0x0045ea4a (code 111, tables 0, padding 0)
# sha256:       4c115cbb9d69368f26132c99c5459ff8bf95a1e86d3b53a0d33f5d656d34dcf7
# evidence:     ev_54414b0082ebcba364d23e408bbf47fe0ab1b670355f5030623cc5b8f4a5e988
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m45e9db_lifted
# naming:       native port src/original_methods_fl40.c:m45e9db_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 6 seeds; oracle 33/33 instructions, 4/4 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_27; [edx + n] field_31d
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m45e9db_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 33 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_27, 0x27  # offset +0x27
.equ field_31d, 0x31d  # offset +0x31d

# --- external targets -----------------------------------------------

.org 0x0045e9db - 0x401000
.globl FUN_0045e9db
FUN_0045e9db:
    # block 0x0045e9db: entry, 6 instruction(s), ends with forward jump to 0x0045e9f8
    push ebp                                     # 0045e9db
    {load} mov ebp, esp                          # 0045e9dc
    sub esp, 0x8                                 # 0045e9de
    mov dword ptr [ebp - local_8], ecx           # 0045e9e1
    mov word ptr [ebp - local_4], 0x0            # 0045e9e4
    jmp.d8 L_0045e9f8                            # 0045e9ea
L_0045e9ec:
    # block 0x0045e9ec: entered by jmp at 0x0045ea40, 3 instruction(s), falls into the block at 0x0045e9f8
    mov ax, word ptr [ebp - local_4]             # 0045e9ec
    .insn 0x66, 0x05, 0x0001{:u16}               # 0045e9f0
    mov word ptr [ebp - local_4], ax             # 0045e9f4
L_0045e9f8:
    # block 0x0045e9f8: entered by jmp at 0x0045e9ea, 6 instruction(s), ends with jge to 0x0045ea42 (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0045e9f8
    mov edx, dword ptr [ebp - local_8]           # 0045e9fc
    mov eax, dword ptr [edx + field_31d]         # 0045e9ff
    movsx edx, word ptr [eax + field_27]         # 0045ea05
    {load} cmp ecx, edx                          # 0045ea09
    jge.d8 L_0045ea42                            # 0045ea0b
    # block 0x0045ea0d: entered by fall-through of jge at 0x0045ea0b, 8 instruction(s), ends with jne to 0x0045ea40 (forward)
    movsx eax, word ptr [ebp + arg_c]            # 0045ea0d
    imul eax, eax, 0x120                         # 0045ea11
    movsx ecx, word ptr [ebp - local_4]          # 0045ea17
    imul ecx, ecx, 0x34                          # 0045ea1b
    lea edx, [eax + ecx + 0x61f4d5]              # 0045ea1e
    movsx eax, word ptr [ebp + arg_8]            # 0045ea25
    cmp dword ptr [edx + 4*eax], 0x1             # 0045ea29
    jne.d8 L_0045ea40                            # 0045ea2d
    # block 0x0045ea2f: entered by fall-through of jne at 0x0045ea2d, 5 instruction(s), ends with forward jump to 0x0045ea44
    mov ecx, dword ptr [ebp + arg_10]            # 0045ea2f
    mov dx, word ptr [ebp - local_4]             # 0045ea32
    mov word ptr [ecx], dx                       # 0045ea36
    mov eax, 0x1                                 # 0045ea39
    jmp.d8 L_0045ea44                            # 0045ea3e
L_0045ea40:
    # block 0x0045ea40: entered by jne at 0x0045ea2d, 1 instruction(s), ends with backward jump to 0x0045e9ec
    jmp.d8 L_0045e9ec                            # 0045ea40
L_0045ea42:
    # block 0x0045ea42: entered by jge at 0x0045ea0b, 1 instruction(s), falls into the block at 0x0045ea44
    {load} xor eax, eax                          # 0045ea42
L_0045ea44:
    # block 0x0045ea44: entered by jmp at 0x0045ea3e, 3 instruction(s), ends with ret 0xc
    {load} mov esp, ebp                          # 0045ea44
    pop ebp                                      # 0045ea46
    ret 0xc                                      # 0045ea47

