# FUN_004b642d
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004b642d
# extent:       0x004b642d-0x004b64a9 (124 code bytes)
# span:         0x004b642d-0x004b64a9 (code 124, tables 0, padding 0)
# sha256:       1aaafd4c98845479bc0202ccb02559ed6bc3abdd65d33bf28d5a2f6c028efa0c
# evidence:     ev_9c28e49ff0d0581c06fedda0626bb3b37c974388a5ee867a2a287f28c8c49afa
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         solved_check
# naming:       native port src/action_family_d1_runtime.c:solved_check (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the summary is the acceptance note
# summary:      1:1 with solved_check (count body +0x21, frame +0x254 vs body +0x30a, match sets +0x22a and +0x274). Body is a parameter; D1_FX_STATE observer call is native-only.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_8, local_c
# fields:       [eax + n] field_1e; [ecx + n] field_21, field_22a, field_254, field_30a; [edx + n] field_274
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_d1_runtime.c:solved_check (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 35 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ field_1e, 0x1e  # offset +0x1e
.equ field_21, 0x21  # offset +0x21
.equ field_22a, 0x22a  # offset +0x22a
.equ field_254, 0x254  # offset +0x254
.equ field_274, 0x274  # offset +0x274
.equ field_30a, 0x30a  # offset +0x30a

# --- external targets -----------------------------------------------

.org 0x004b642d - 0x401000
.globl FUN_004b642d
FUN_004b642d:
    # block 0x004b642d: entry, 11 instruction(s), ends with forward jump to 0x004b645e
    push ebp                                     # 004b642d
    {load} mov ebp, esp                          # 004b642e
    sub esp, 0xc                                 # 004b6430
    mov dword ptr [ebp - local_c], ecx           # 004b6433
    mov eax, dword ptr [ebp - local_c]           # 004b6436
    movsx ecx, word ptr [eax + field_1e]         # 004b6439
    imul ecx, ecx, 0x8d                          # 004b643d
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 004b6443
    mov dword ptr [ebp - local_8], edx           # 004b6449
    mov dword ptr [ebp - local_4], 0x0           # 004b644c
    jmp.d8 L_004b645e                            # 004b6453
L_004b6455:
    # block 0x004b6455: entered by jmp at 0x004b648c, 3 instruction(s), falls into the block at 0x004b645e
    mov eax, dword ptr [ebp - local_4]           # 004b6455
    add eax, 0x1                                 # 004b6458
    mov dword ptr [ebp - local_4], eax           # 004b645b
L_004b645e:
    # block 0x004b645e: entered by jmp at 0x004b6453, 4 instruction(s), ends with jge to 0x004b648e (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004b645e
    movsx edx, word ptr [ecx + field_21]         # 004b6461
    cmp dword ptr [ebp - local_4], edx           # 004b6465
    jge.d8 L_004b648e                            # 004b6468
    # block 0x004b646a: entered by fall-through of jge at 0x004b6468, 8 instruction(s), ends with je to 0x004b648c (forward)
    mov eax, dword ptr [ebp - local_4]           # 004b646a
    mov ecx, dword ptr [ebp - local_c]           # 004b646d
    movsx edx, word ptr [ecx + 2*eax + field_254] # 004b6470
    mov eax, dword ptr [ebp - local_4]           # 004b6478
    mov ecx, dword ptr [ebp - local_8]           # 004b647b
    movsx eax, word ptr [ecx + 2*eax + field_30a] # 004b647e
    {load} cmp edx, eax                          # 004b6486
    je.d8 L_004b648c                             # 004b6488
    # block 0x004b648a: entered by fall-through of je at 0x004b6488, 1 instruction(s), ends with forward jump to 0x004b64a5
    jmp.d8 L_004b64a5                            # 004b648a
L_004b648c:
    # block 0x004b648c: entered by je at 0x004b6488, 1 instruction(s), ends with backward jump to 0x004b6455
    jmp.d8 L_004b6455                            # 004b648c
L_004b648e:
    # block 0x004b648e: entered by jge at 0x004b6468, 4 instruction(s), falls into the block at 0x004b64a5
    mov ecx, dword ptr [ebp - local_c]           # 004b648e
    mov byte ptr [ecx + field_22a], 0x1          # 004b6491
    mov edx, dword ptr [ebp - local_c]           # 004b6498
    mov dword ptr [edx + field_274], 0x1         # 004b649b
L_004b64a5:
    # block 0x004b64a5: entered by jmp at 0x004b648a, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004b64a5
    pop ebp                                      # 004b64a7
    ret                                          # 004b64a8

