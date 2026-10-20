# FUN_0047c049
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0047c049
# extent:       0x0047c049-0x0047c0f0 (167 code bytes)
# span:         0x0047c049-0x0047c0f0 (code 167, tables 0, padding 0)
# sha256:       cf6749a581237e69ea1b98dc83be764fd27a73d3899e60f6a5b6aaf418cf487f
# evidence:     ev_827db53a64242b59e9f92d38aeb544549dfa70f780a54958ee5eb67fb48784ea
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_memory_puzzle_pick_picture_id
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_ee_runtime.c:336 says "0x47c049: a picture id that no pair has used yet, else any."
# name-note:    Picks a picture id that no pair has used yet, else any.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       [eax + n] field_18; [ecx + n] field_2a4; [edx + n] field_18
# callees:      calls FUN_0050cd50
# track-n:      outputs/blackmoor-decomp/src/action_family_ee_runtime.c:pick_id (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 51 instruction(s), 4 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ field_18, 0x18  # offset +0x18
.equ field_2a4, 0x2a4  # offset +0x2a4

# --- external targets -----------------------------------------------
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)

.org 0x0047c049 - 0x401000
.globl FUN_0047c049
FUN_0047c049:
    # block 0x0047c049: entry, 8 instruction(s), ends with forward jump to 0x0047c072
    push ebp                                     # 0047c049
    {load} mov ebp, esp                          # 0047c04a
    sub esp, 0x10                                # 0047c04c
    mov dword ptr [ebp - local_10], ecx          # 0047c04f
    mov dword ptr [ebp - local_4], 0x1           # 0047c052
    mov dword ptr [ebp - local_8], 0xffffffff    # 0047c059
    mov dword ptr [ebp - local_c], 0x0           # 0047c060
    jmp.d8 L_0047c072                            # 0047c067
L_0047c069:
    # block 0x0047c069: entered by jmp at 0x0047c098, 3 instruction(s), falls into the block at 0x0047c072
    mov eax, dword ptr [ebp - local_c]           # 0047c069
    add eax, 0x1                                 # 0047c06c
    mov dword ptr [ebp - local_c], eax           # 0047c06f
L_0047c072:
    # block 0x0047c072: entered by jmp at 0x0047c067, 4 instruction(s), ends with jge to 0x0047c09a (forward)
    mov ecx, dword ptr [ebp - local_10]          # 0047c072
    mov edx, dword ptr [ebp - local_c]           # 0047c075
    cmp edx, dword ptr [ecx + field_2a4]         # 0047c078
    jge.d8 L_0047c09a                            # 0047c07e
    # block 0x0047c080: entered by fall-through of jge at 0x0047c07e, 5 instruction(s), ends with jne to 0x0047c098 (forward)
    mov eax, dword ptr [ebp - local_10]          # 0047c080
    mov ecx, dword ptr [eax + field_18]          # 0047c083
    mov edx, dword ptr [ebp - local_c]           # 0047c086
    cmp dword ptr [ecx + 4*edx], 0x0             # 0047c089
    jne.d8 L_0047c098                            # 0047c08d
    # block 0x0047c08f: entered by fall-through of jne at 0x0047c08d, 2 instruction(s), ends with forward jump to 0x0047c09a
    mov dword ptr [ebp - local_4], 0x0           # 0047c08f
    jmp.d8 L_0047c09a                            # 0047c096
L_0047c098:
    # block 0x0047c098: entered by jne at 0x0047c08d, 1 instruction(s), ends with backward jump to 0x0047c069
    jmp.d8 L_0047c069                            # 0047c098
L_0047c09a:
    # block 0x0047c09a: entered by jge at 0x0047c07e; jmp at 0x0047c096, 2 instruction(s), ends with je to 0x0047c0b4 (forward)
    cmp dword ptr [ebp - local_4], 0x0           # 0047c09a
    je.d8 L_0047c0b4                             # 0047c09e
    # block 0x0047c0a0: entered by fall-through of je at 0x0047c09e, 6 instruction(s), calls FUN_0050cd50, ends with forward jump to 0x0047c0e9
    call FUN_0050cd50                            # 0047c0a0
    mov ecx, dword ptr [ebp - local_10]          # 0047c0a5
    cdq                                          # 0047c0a8
    idiv dword ptr [ecx + field_2a4]             # 0047c0a9
    mov dword ptr [ebp - local_8], edx           # 0047c0af
    jmp.d8 L_0047c0e9                            # 0047c0b2
L_0047c0b4:
    # block 0x0047c0b4: entered by je at 0x0047c09e; jmp at 0x0047c0e7, 10 instruction(s), calls FUN_0050cd50, ends with jne to 0x0047c0e7 (forward)
    call FUN_0050cd50                            # 0047c0b4
    mov ecx, dword ptr [ebp - local_10]          # 0047c0b9
    cdq                                          # 0047c0bc
    idiv dword ptr [ecx + field_2a4]             # 0047c0bd
    mov dword ptr [ebp - local_8], edx           # 0047c0c3
    mov edx, dword ptr [ebp - local_10]          # 0047c0c6
    mov eax, dword ptr [edx + field_18]          # 0047c0c9
    mov ecx, dword ptr [ebp - local_8]           # 0047c0cc
    cmp dword ptr [eax + 4*ecx], 0x0             # 0047c0cf
    jne.d8 L_0047c0e7                            # 0047c0d3
    # block 0x0047c0d5: entered by fall-through of jne at 0x0047c0d3, 5 instruction(s), ends with forward jump to 0x0047c0e9
    mov edx, dword ptr [ebp - local_10]          # 0047c0d5
    mov eax, dword ptr [edx + field_18]          # 0047c0d8
    mov ecx, dword ptr [ebp - local_8]           # 0047c0db
    mov dword ptr [eax + 4*ecx], 0x1             # 0047c0de
    jmp.d8 L_0047c0e9                            # 0047c0e5
L_0047c0e7:
    # block 0x0047c0e7: entered by jne at 0x0047c0d3, 1 instruction(s), ends with backward jump to 0x0047c0b4
    jmp.d8 L_0047c0b4                            # 0047c0e7
L_0047c0e9:
    # block 0x0047c0e9: entered by jmp at 0x0047c0b2; jmp at 0x0047c0e5, 4 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_8]           # 0047c0e9
    {load} mov esp, ebp                          # 0047c0ec
    pop ebp                                      # 0047c0ee
    ret                                          # 0047c0ef

