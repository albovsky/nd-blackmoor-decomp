# FUN_004e2faa
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e2faa
# extent:       0x004e2faa-0x004e303b (145 code bytes)
# span:         0x004e2faa-0x004e303b (code 145, tables 0, padding 0)
# sha256:       65e93f6e03767a18a48f7e257f70ad80ddb8827db487107eeb097c5a855a06e5
# evidence:     ev_8385f85130572c281c3b234a54cbdfd62040e051350169a9d81ca47906b8da6a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4e2faa_release_cells
# naming:       native port src/original_methods_fl31c.c:m4e2faa_release_cells (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-20); the note is the acceptance note, a statement about the native port
# name-note:    Calls 0x4e1d34 for 26 cells (stride 0x18f from +0x1ca2), 0x4e2dd3, two word-argument calls to 0x4c92c5 and, when dword +0x6ce is set, 0x4c2dfb; 40/40 instructions, 4/4 jump directions.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_140a; [ecx + n] field_6ce; [edx + n] field_140c, field_1ca2
# callees:      calls FUN_004e1d34, FUN_004e2dd3, FUN_004c92c5, FUN_004c2dfb
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl31c.c:m4e2faa_release_cells (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 40 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_6ce, 0x6ce  # offset +0x6ce
.equ field_140a, 0x140a  # offset +0x140a
.equ field_140c, 0x140c  # offset +0x140c
.equ field_1ca2, 0x1ca2  # offset +0x1ca2

# --- external targets -----------------------------------------------
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004c92c5, .text + (0x004c92c5 - 0x401000)
.set FUN_004e1d34, .text + (0x004e1d34 - 0x401000)
.set FUN_004e2dd3, .text + (0x004e2dd3 - 0x401000)

.org 0x004e2faa - 0x401000
.globl FUN_004e2faa
FUN_004e2faa:
    # block 0x004e2faa: entry, 6 instruction(s), ends with forward jump to 0x004e2fc5
    push ebp                                     # 004e2faa
    {load} mov ebp, esp                          # 004e2fab
    sub esp, 0x8                                 # 004e2fad
    mov dword ptr [ebp - local_8], ecx           # 004e2fb0
    mov dword ptr [ebp - local_4], 0x0           # 004e2fb3
    jmp.d8 L_004e2fc5                            # 004e2fba
L_004e2fbc:
    # block 0x004e2fbc: entered by jmp at 0x004e2fe3, 3 instruction(s), falls into the block at 0x004e2fc5
    mov eax, dword ptr [ebp - local_4]           # 004e2fbc
    add eax, 0x1                                 # 004e2fbf
    mov dword ptr [ebp - local_4], eax           # 004e2fc2
L_004e2fc5:
    # block 0x004e2fc5: entered by jmp at 0x004e2fba, 2 instruction(s), ends with jge to 0x004e2fe5 (forward)
    cmp dword ptr [ebp - local_4], 0x1a          # 004e2fc5
    jge.d8 L_004e2fe5                            # 004e2fc9
    # block 0x004e2fcb: entered by fall-through of jge at 0x004e2fc9, 6 instruction(s), calls FUN_004e1d34, ends with backward jump to 0x004e2fbc
    mov ecx, dword ptr [ebp - local_4]           # 004e2fcb
    imul ecx, ecx, 0x18f                         # 004e2fce
    mov edx, dword ptr [ebp - local_8]           # 004e2fd4
    lea ecx, [edx + ecx + field_1ca2]            # 004e2fd7
    call FUN_004e1d34                            # 004e2fde
    jmp.d8 L_004e2fbc                            # 004e2fe3
L_004e2fe5:
    # block 0x004e2fe5: entered by jge at 0x004e2fc9, 15 instruction(s), calls FUN_004e2dd3, FUN_004c92c5, ends with je to 0x004e3037 (forward)
    mov ecx, dword ptr [ebp - local_8]           # 004e2fe5
    call FUN_004e2dd3                            # 004e2fe8
    mov eax, dword ptr [ebp - local_8]           # 004e2fed
    mov cx, word ptr [eax + field_140a]          # 004e2ff0
    push ecx                                     # 004e2ff7
    mov ecx, 0x5cf659                            # 004e2ff8
    call FUN_004c92c5                            # 004e2ffd
    mov edx, dword ptr [ebp - local_8]           # 004e3002
    mov ax, word ptr [edx + field_140c]          # 004e3005
    push eax                                     # 004e300c
    mov ecx, 0x5cf659                            # 004e300d
    call FUN_004c92c5                            # 004e3012
    mov ecx, dword ptr [ebp - local_8]           # 004e3017
    cmp dword ptr [ecx + field_6ce], 0x0         # 004e301a
    je.d8 L_004e3037                             # 004e3021
    # block 0x004e3023: entered by fall-through of je at 0x004e3021, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x004e3037
    mov edx, dword ptr [ebp - local_8]           # 004e3023
    add edx, 0x6ce                               # 004e3026
    push edx                                     # 004e302c
    mov ecx, 0x5cf659                            # 004e302d
    call FUN_004c2dfb                            # 004e3032
L_004e3037:
    # block 0x004e3037: entered by je at 0x004e3021, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004e3037
    pop ebp                                      # 004e3039
    ret                                          # 004e303a

