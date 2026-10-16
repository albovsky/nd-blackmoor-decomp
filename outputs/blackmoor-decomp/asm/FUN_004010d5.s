# FUN_004010d5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004010d5
# extent:       0x004010d5-0x004010f4 (31 code bytes)
# span:         0x004010d5-0x00401100 (code 31, tables 0, padding 12)
# sha256:       33acd69e7a24de610a14548d6e557f6634b3c5f9157d0a96e9ba9467007be5b5
# evidence:     ev_5101d3157a7cceecfaf0c751ae06a21a7013310d21b12b5f59cdca7af1ddb679
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004010d5
# arguments:    no [ebp+n] stack argument slot referenced; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_3c
# callees:      calls FUN_0051ab4b
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_3c, 0x3c  # offset +0x3c

# --- external targets -----------------------------------------------
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)

.org 0x004010d5 - 0x401000
.globl FUN_004010d5
FUN_004010d5:
    # block 0x004010d5: entry, 11 instruction(s), calls FUN_0051ab4b, ends with ret 0xc
    push ebp                                     # 004010d5
    {load} mov ebp, esp                          # 004010d6
    push ecx                                     # 004010d8
    mov dword ptr [ebp - local_4], ecx           # 004010d9
    mov eax, dword ptr [ebp - local_4]           # 004010dc
    mov dword ptr [eax + field_3c], 0x0          # 004010df
    mov ecx, dword ptr [ebp - local_4]           # 004010e6
    call FUN_0051ab4b                            # 004010e9
    {load} mov esp, ebp                          # 004010ee
    pop ebp                                      # 004010f0
    ret 0xc                                      # 004010f1

# --- data items (not part of the function) -------------------------
.org 0x004010f4 - 0x401000
PAD_004010f4:  # 12 byte(s) of int3 padding
    .fill 12, 1, 0xcc

