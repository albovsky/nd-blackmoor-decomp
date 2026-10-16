# FUN_0041dfd2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041dfd2
# extent:       0x0041dfd2-0x0041e043 (113 code bytes)
# span:         0x0041dfd2-0x0041e043 (code 113, tables 0, padding 0)
# sha256:       e6119539c101d67c53dc9ef7cf8051e7fbcd58438db29a55db4115fa1f7ab0d2
# evidence:     ev_6d14e36254d52595d49112e8022fb6a1363c93f1543311eb137634febb6a6ec5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0041dfd2
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [ecx + n] field_1c, field_69c; [edx + n] field_690, field_696
# callees:      calls FUN_0041e250
# track-n:      outputs/blackmoor-decomp/src/action_family_3f_runtime.c:cel_evict_pass (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 35 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_690, 0x690  # offset +0x690
.equ field_696, 0x696  # offset +0x696
.equ field_69c, 0x69c  # offset +0x69c

# --- external targets -----------------------------------------------
.set FUN_0041e250, .text + (0x0041e250 - 0x401000)

.org 0x0041dfd2 - 0x401000
.globl FUN_0041dfd2
FUN_0041dfd2:
    # block 0x0041dfd2: entry, 6 instruction(s), ends with forward jump to 0x0041dfef
    push ebp                                     # 0041dfd2
    {load} mov ebp, esp                          # 0041dfd3
    sub esp, 0x8                                 # 0041dfd5
    mov dword ptr [ebp - local_8], ecx           # 0041dfd8
    mov word ptr [ebp - local_4], 0x0            # 0041dfdb
    jmp.d8 L_0041dfef                            # 0041dfe1
L_0041dfe3:
    # block 0x0041dfe3: entered by jmp at 0x0041e03d, 3 instruction(s), falls into the block at 0x0041dfef
    mov ax, word ptr [ebp - local_4]             # 0041dfe3
    .insn 0x66, 0x05, 0x0001{:u16}               # 0041dfe7
    mov word ptr [ebp - local_4], ax             # 0041dfeb
L_0041dfef:
    # block 0x0041dfef: entered by jmp at 0x0041dfe1, 5 instruction(s), ends with jge to 0x0041e03f (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0041dfef
    mov edx, dword ptr [ebp - local_8]           # 0041dff3
    movsx eax, word ptr [edx + field_696]        # 0041dff6
    {load} cmp ecx, eax                          # 0041dffd
    jge.d8 L_0041e03f                            # 0041dfff
    # block 0x0041e001: entered by fall-through of jge at 0x0041dfff, 8 instruction(s), ends with jle to 0x0041e03d (forward)
    mov ecx, dword ptr [ebp - local_8]           # 0041e001
    movsx edx, word ptr [ecx + field_69c]        # 0041e004
    movsx eax, word ptr [ebp - local_4]          # 0041e00b
    imul eax, eax, 0x16                          # 0041e00f
    mov ecx, dword ptr [ebp - local_8]           # 0041e012
    movsx eax, word ptr [ecx + eax + field_1c]   # 0041e015
    {load} cmp edx, eax                          # 0041e01a
    jle.d8 L_0041e03d                            # 0041e01c
    # block 0x0041e01e: entered by fall-through of jle at 0x0041e01c, 5 instruction(s), ends with je to 0x0041e03d (forward)
    movsx ecx, word ptr [ebp - local_4]          # 0041e01e
    mov edx, dword ptr [ebp - local_8]           # 0041e022
    movsx eax, word ptr [edx + field_690]        # 0041e025
    {load} cmp ecx, eax                          # 0041e02c
    je.d8 L_0041e03d                             # 0041e02e
    # block 0x0041e030: entered by fall-through of je at 0x0041e02e, 4 instruction(s), calls FUN_0041e250, falls into the block at 0x0041e03d
    mov cx, word ptr [ebp - local_4]             # 0041e030
    push ecx                                     # 0041e034
    mov ecx, dword ptr [ebp - local_8]           # 0041e035
    call FUN_0041e250                            # 0041e038
L_0041e03d:
    # block 0x0041e03d: entered by jle at 0x0041e01c; je at 0x0041e02e, 1 instruction(s), ends with backward jump to 0x0041dfe3
    jmp.d8 L_0041dfe3                            # 0041e03d
L_0041e03f:
    # block 0x0041e03f: entered by jge at 0x0041dfff, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0041e03f
    pop ebp                                      # 0041e041
    ret                                          # 0041e042

