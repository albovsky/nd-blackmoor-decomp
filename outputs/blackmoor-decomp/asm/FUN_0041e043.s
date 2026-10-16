# FUN_0041e043
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041e043
# extent:       0x0041e043-0x0041e0b4 (113 code bytes)
# span:         0x0041e043-0x0041e0b4 (code 113, tables 0, padding 0)
# sha256:       c97e79b69d60e63e262f9dc96e8b52d0e4ee70db736f61e9b4fd0c90ceae472e
# evidence:     ev_6d14e36254d52595d49112e8022fb6a1363c93f1543311eb137634febb6a6ec5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0041e043
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_1c, field_68e, field_696; [edx + n] field_696
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_3f_runtime.c:cel_first_free (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 35 instruction(s), 3 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_1c, 0x1c  # offset +0x1c
.equ field_68e, 0x68e  # offset +0x68e
.equ field_696, 0x696  # offset +0x696

# --- external targets -----------------------------------------------

.org 0x0041e043 - 0x401000
.globl FUN_0041e043
FUN_0041e043:
    # block 0x0041e043: entry, 10 instruction(s), ends with jl to 0x0041e06a (forward)
    push ebp                                     # 0041e043
    {load} mov ebp, esp                          # 0041e044
    sub esp, 0x8                                 # 0041e046
    mov dword ptr [ebp - local_8], ecx           # 0041e049
    mov eax, dword ptr [ebp - local_8]           # 0041e04c
    movsx ecx, word ptr [eax + field_68e]        # 0041e04f
    mov edx, dword ptr [ebp - local_8]           # 0041e056
    movsx eax, word ptr [edx + field_696]        # 0041e059
    {load} cmp ecx, eax                          # 0041e060
    jl.d8 L_0041e06a                             # 0041e062
    # block 0x0041e064: entered by fall-through of jl at 0x0041e062, 2 instruction(s), ends with forward jump to 0x0041e0b0
    .insn 0x66, 0x0d, 0xffff{:u16}               # 0041e064
    jmp.d8 L_0041e0b0                            # 0041e068
L_0041e06a:
    # block 0x0041e06a: entered by jl at 0x0041e062, 2 instruction(s), ends with forward jump to 0x0041e07e
    mov word ptr [ebp - local_4], 0x0            # 0041e06a
    jmp.d8 L_0041e07e                            # 0041e070
L_0041e072:
    # block 0x0041e072: entered by jmp at 0x0041e0aa, 3 instruction(s), falls into the block at 0x0041e07e
    mov cx, word ptr [ebp - local_4]             # 0041e072
    add cx, 0x1                                  # 0041e076
    mov word ptr [ebp - local_4], cx             # 0041e07a
L_0041e07e:
    # block 0x0041e07e: entered by jmp at 0x0041e070, 5 instruction(s), ends with jge to 0x0041e0ac (forward)
    movsx edx, word ptr [ebp - local_4]          # 0041e07e
    mov eax, dword ptr [ebp - local_8]           # 0041e082
    movsx ecx, word ptr [eax + field_696]        # 0041e085
    {load} cmp edx, ecx                          # 0041e08c
    jge.d8 L_0041e0ac                            # 0041e08e
    # block 0x0041e090: entered by fall-through of jge at 0x0041e08e, 6 instruction(s), ends with jne to 0x0041e0aa (forward)
    movsx edx, word ptr [ebp - local_4]          # 0041e090
    imul edx, edx, 0x16                          # 0041e094
    mov eax, dword ptr [ebp - local_8]           # 0041e097
    movsx ecx, word ptr [eax + edx + field_1c]   # 0041e09a
    cmp ecx, -0x1                                # 0041e09f
    jne.d8 L_0041e0aa                            # 0041e0a2
    # block 0x0041e0a4: entered by fall-through of jne at 0x0041e0a2, 2 instruction(s), ends with forward jump to 0x0041e0b0
    mov ax, word ptr [ebp - local_4]             # 0041e0a4
    jmp.d8 L_0041e0b0                            # 0041e0a8
L_0041e0aa:
    # block 0x0041e0aa: entered by jne at 0x0041e0a2, 1 instruction(s), ends with backward jump to 0x0041e072
    jmp.d8 L_0041e072                            # 0041e0aa
L_0041e0ac:
    # block 0x0041e0ac: entered by jge at 0x0041e08e, 1 instruction(s), falls into the block at 0x0041e0b0
    .insn 0x66, 0x0d, 0xffff{:u16}               # 0041e0ac
L_0041e0b0:
    # block 0x0041e0b0: entered by jmp at 0x0041e068; jmp at 0x0041e0a8, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 0041e0b0
    pop ebp                                      # 0041e0b2
    ret                                          # 0041e0b3

