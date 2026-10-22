# FUN_004ba262
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ba262
# extent:       0x004ba262-0x004ba2bd (91 code bytes)
# span:         0x004ba262-0x004ba2bd (code 91, tables 0, padding 0)
# sha256:       c8c68f5d67e072da7c0c8b884ace33713d66acdb69b369122c34118166afa6ef
# evidence:     ev_0a6ac0edbe5602a7eee9dc902ec1f93eea8bd2aa232e8044e889effe410b6a1d
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ba262
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_34, field_64; [ecx + n] field_5c, field_60; [edx + n] field_58
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39d.c:m4ba262_lifted (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 31 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_34, 0x34  # offset +0x34
.equ field_58, 0x58  # offset +0x58
.equ field_5c, 0x5c  # offset +0x5c
.equ field_60, 0x60  # offset +0x60
.equ field_64, 0x64  # offset +0x64

# --- external targets -----------------------------------------------

.org 0x004ba262 - 0x401000
.globl FUN_004ba262
FUN_004ba262:
    # block 0x004ba262: entry, 7 instruction(s), ends with jne to 0x004ba279 (forward)
    push ebp                                     # 004ba262
    {load} mov ebp, esp                          # 004ba263
    push ecx                                     # 004ba265
    mov dword ptr [ebp - local_4], ecx           # 004ba266
    mov eax, dword ptr [ebp - local_4]           # 004ba269
    cmp dword ptr [eax + field_34], 0x0          # 004ba26c
    jne.d8 L_004ba279                            # 004ba270
    # block 0x004ba272: entered by fall-through of jne at 0x004ba270, 2 instruction(s), ends with forward jump to 0x004ba2b9
    mov eax, 0x1                                 # 004ba272
    jmp.d8 L_004ba2b9                            # 004ba277
L_004ba279:
    # block 0x004ba279: entered by jne at 0x004ba270, 4 instruction(s), ends with jl to 0x004ba2b4 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004ba279
    mov edx, dword ptr [0x583106]                # 004ba27c
    cmp edx, dword ptr [ecx + field_5c]          # 004ba282
    jl.d8 L_004ba2b4                             # 004ba285
    # block 0x004ba287: entered by fall-through of jl at 0x004ba285, 4 instruction(s), ends with jg to 0x004ba2b4 (forward)
    mov eax, dword ptr [ebp - local_4]           # 004ba287
    mov ecx, dword ptr [0x58310e]                # 004ba28a
    cmp ecx, dword ptr [eax + field_64]          # 004ba290
    jg.d8 L_004ba2b4                             # 004ba293
    # block 0x004ba295: entered by fall-through of jg at 0x004ba293, 4 instruction(s), ends with jl to 0x004ba2b4 (forward)
    mov edx, dword ptr [ebp - local_4]           # 004ba295
    mov eax, dword ptr [0x583102]                # 004ba298
    cmp eax, dword ptr [edx + field_58]          # 004ba29d
    jl.d8 L_004ba2b4                             # 004ba2a0
    # block 0x004ba2a2: entered by fall-through of jl at 0x004ba2a0, 4 instruction(s), ends with jg to 0x004ba2b4 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004ba2a2
    mov edx, dword ptr [0x58310a]                # 004ba2a5
    cmp edx, dword ptr [ecx + field_60]          # 004ba2ab
    jg.d8 L_004ba2b4                             # 004ba2ae
    # block 0x004ba2b0: entered by fall-through of jg at 0x004ba2ae, 2 instruction(s), ends with forward jump to 0x004ba2b9
    {load} xor eax, eax                          # 004ba2b0
    jmp.d8 L_004ba2b9                            # 004ba2b2
L_004ba2b4:
    # block 0x004ba2b4: entered by jl at 0x004ba285; jg at 0x004ba293; jl at 0x004ba2a0; jg at 0x004ba2ae, 1 instruction(s), falls into the block at 0x004ba2b9
    mov eax, 0x1                                 # 004ba2b4
L_004ba2b9:
    # block 0x004ba2b9: entered by jmp at 0x004ba277; jmp at 0x004ba2b2, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004ba2b9
    pop ebp                                      # 004ba2bb
    ret                                          # 004ba2bc

