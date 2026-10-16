# FUN_00493b2e
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00493b2e
# extent:       0x00493b2e-0x00493b7a (76 code bytes)
# span:         0x00493b2e-0x00493b7a (code 76, tables 0, padding 0)
# sha256:       147c24ad8b50fcc3ae381aa466fb8304f74db721eb87d15eda8e049bb0feccd6
# evidence:     ev_da254f3c66057fe0ecb1916012a485119a4ff6d747553eb5fd7a4bf04258f342
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00493b2e
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1f77; [ecx + n] field_2007, field_200b; [edx + n] field_2003
# callees:      calls FUN_004dae66, FUN_004dae77
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 21 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1f77, 0x1f77  # offset +0x1f77
.equ field_2003, 0x2003  # offset +0x2003
.equ field_2007, 0x2007  # offset +0x2007
.equ field_200b, 0x200b  # offset +0x200b

# --- external targets -----------------------------------------------
.set FUN_004dae66, .text + (0x004dae66 - 0x401000)
.set FUN_004dae77, .text + (0x004dae77 - 0x401000)

.org 0x00493b2e - 0x401000
.globl FUN_00493b2e
FUN_00493b2e:
    # block 0x00493b2e: entry, 7 instruction(s), ends with jne to 0x00493b43 (forward)
    push ebp                                     # 00493b2e
    {load} mov ebp, esp                          # 00493b2f
    push ecx                                     # 00493b31
    mov dword ptr [ebp - local_4], ecx           # 00493b32
    mov eax, dword ptr [ebp - local_4]           # 00493b35
    cmp dword ptr [eax + field_1f77], 0x0        # 00493b38
    jne.d8 L_00493b43                            # 00493b3f
    # block 0x00493b41: entered by fall-through of jne at 0x00493b3f, 1 instruction(s), ends with forward jump to 0x00493b76
    jmp.d8 L_00493b76                            # 00493b41
L_00493b43:
    # block 0x00493b43: entered by jne at 0x00493b3f, 10 instruction(s), calls FUN_004dae66, FUN_004dae77, falls into the block at 0x00493b76
    mov ecx, dword ptr [ebp - local_4]           # 00493b43
    mov dword ptr [ecx + field_200b], 0x0        # 00493b46
    mov ecx, 0x5830a6                            # 00493b50
    call FUN_004dae66                            # 00493b55
    mov edx, dword ptr [ebp - local_4]           # 00493b5a
    mov dword ptr [edx + field_2003], eax        # 00493b5d
    mov ecx, 0x5830a6                            # 00493b63
    call FUN_004dae77                            # 00493b68
    mov ecx, dword ptr [ebp - local_4]           # 00493b6d
    mov dword ptr [ecx + field_2007], eax        # 00493b70
L_00493b76:
    # block 0x00493b76: entered by jmp at 0x00493b41, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 00493b76
    pop ebp                                      # 00493b78
    ret                                          # 00493b79

