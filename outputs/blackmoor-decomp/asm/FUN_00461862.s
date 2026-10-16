# FUN_00461862
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00461862
# extent:       0x00461862-0x004618ab (73 code bytes)
# span:         0x00461862-0x004618ab (code 73, tables 0, padding 0)
# sha256:       4bc0b8aa79a87fffbf0de4a749ff22ace8a53e3f88dadba25cdeae9d08c13a71
# evidence:     ev_54414b0082ebcba364d23e408bbf47fe0ab1b670355f5030623cc5b8f4a5e988
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00461862
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_20; [ecx + n] field_1c; [edx + n] field_1c
# callees:      calls FUN_004c2dfb, FUN_004d3992, FUN_00461827
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 26 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20

# --- external targets -----------------------------------------------
.set FUN_00461827, .text + (0x00461827 - 0x401000)
.set FUN_004c2dfb, .text + (0x004c2dfb - 0x401000)
.set FUN_004d3992, .text + (0x004d3992 - 0x401000)

.org 0x00461862 - 0x401000
.globl FUN_00461862
FUN_00461862:
    # block 0x00461862: entry, 7 instruction(s), ends with je to 0x00461883 (forward)
    push ebp                                     # 00461862
    {load} mov ebp, esp                          # 00461863
    push ecx                                     # 00461865
    mov dword ptr [ebp - local_4], ecx           # 00461866
    mov eax, dword ptr [ebp - local_4]           # 00461869
    cmp dword ptr [eax + field_20], 0x0          # 0046186c
    je.d8 L_00461883                             # 00461870
    # block 0x00461872: entered by fall-through of je at 0x00461870, 5 instruction(s), calls FUN_004c2dfb, falls into the block at 0x00461883
    mov ecx, dword ptr [ebp - local_4]           # 00461872
    add ecx, 0x20                                # 00461875
    push ecx                                     # 00461878
    mov ecx, 0x5cf659                            # 00461879
    call FUN_004c2dfb                            # 0046187e
L_00461883:
    # block 0x00461883: entered by je at 0x00461870, 4 instruction(s), ends with je to 0x0046189f (forward)
    mov edx, dword ptr [ebp - local_4]           # 00461883
    movsx eax, word ptr [edx + field_1c]         # 00461886
    cmp eax, -0x1                                # 0046188a
    je.d8 L_0046189f                             # 0046188d
    # block 0x0046188f: entered by fall-through of je at 0x0046188d, 5 instruction(s), calls FUN_004d3992, falls into the block at 0x0046189f
    mov ecx, dword ptr [ebp - local_4]           # 0046188f
    mov dx, word ptr [ecx + field_1c]            # 00461892
    push edx                                     # 00461896
    call FUN_004d3992                            # 00461897
    add esp, 0x4                                 # 0046189c
L_0046189f:
    # block 0x0046189f: entered by je at 0x0046188d, 5 instruction(s), calls FUN_00461827, ends with ret
    mov ecx, dword ptr [ebp - local_4]           # 0046189f
    call FUN_00461827                            # 004618a2
    {load} mov esp, ebp                          # 004618a7
    pop ebp                                      # 004618a9
    ret                                          # 004618aa

