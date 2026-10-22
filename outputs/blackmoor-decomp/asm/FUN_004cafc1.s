# FUN_004cafc1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004cafc1
# extent:       0x004cafc1-0x004caff5 (52 code bytes)
# span:         0x004cafc1-0x004caff5 (code 52, tables 0, padding 0)
# sha256:       f39ad34d63443d5310c2019c05746fae0533b81d6b878675b4f34c2d7a11644e
# evidence:     ev_d590aeb62d3bd1e1413a3f3e4f07f565aba52ab8fd98207292a76569576fbcb9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4cafc1_mark_entry
# naming:       native port src/original_methods_fl39a.c:m4cafc1_mark_entry (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Returns when dword [self+0xe] is 0 or the signed word [self+0xc] is -1; otherwise stores dword 1 at [0x5d15a5 + i*0x4a]. Both jumps taken both ways; all 18 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_c, field_e; [ecx + n] field_c
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl39a.c:m4cafc1_mark_entry (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_c, 0xc  # offset +0xc
.equ field_e, 0xe  # offset +0xe

# --- external targets -----------------------------------------------

.org 0x004cafc1 - 0x401000
.globl FUN_004cafc1
FUN_004cafc1:
    # block 0x004cafc1: entry, 7 instruction(s), ends with je to 0x004caff1 (forward)
    push ebp                                     # 004cafc1
    {load} mov ebp, esp                          # 004cafc2
    push ecx                                     # 004cafc4
    mov dword ptr [ebp - local_4], ecx           # 004cafc5
    mov eax, dword ptr [ebp - local_4]           # 004cafc8
    cmp dword ptr [eax + field_e], 0x0           # 004cafcb
    je.d8 L_004caff1                             # 004cafcf
    # block 0x004cafd1: entered by fall-through of je at 0x004cafcf, 4 instruction(s), ends with je to 0x004caff1 (forward)
    mov ecx, dword ptr [ebp - local_4]           # 004cafd1
    movsx edx, word ptr [ecx + field_c]          # 004cafd4
    cmp edx, -0x1                                # 004cafd8
    je.d8 L_004caff1                             # 004cafdb
    # block 0x004cafdd: entered by fall-through of je at 0x004cafdb, 4 instruction(s), falls into the block at 0x004caff1
    mov eax, dword ptr [ebp - local_4]           # 004cafdd
    movsx ecx, word ptr [eax + field_c]          # 004cafe0
    imul ecx, ecx, 0x4a                          # 004cafe4
    mov dword ptr [ecx + 0x5d15a5], 0x1          # 004cafe7
L_004caff1:
    # block 0x004caff1: entered by je at 0x004cafcf; je at 0x004cafdb, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004caff1
    pop ebp                                      # 004caff3
    ret                                          # 004caff4

