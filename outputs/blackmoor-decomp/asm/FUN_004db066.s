# FUN_004db066
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004db066
# extent:       0x004db066-0x004db090 (42 code bytes)
# span:         0x004db066-0x004db090 (code 42, tables 0, padding 0)
# sha256:       117397dc9efbacf8f82cbf0afe9a50ce2524c773e31cfcecaf9fe081a64aa20c
# evidence:     ev_6b108bc55ab995dff591d60480e699c5391fdca071fca0daf43a01e1312df619
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004db066
# arguments:    no [ebp+n] stack argument slot referenced; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_10; [ecx + n] field_10; [edx + n] field_c
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 14 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------

.org 0x004db066 - 0x401000
.globl FUN_004db066
FUN_004db066:
    # block 0x004db066: entry, 7 instruction(s), ends with jne to 0x004db080 (forward)
    push ebp                                     # 004db066
    {load} mov ebp, esp                          # 004db067
    push ecx                                     # 004db069
    mov dword ptr [ebp - local_4], ecx           # 004db06a
    mov eax, dword ptr [ebp - local_4]           # 004db06d
    cmp dword ptr [eax + field_10], 0x0          # 004db070
    jne.d8 L_004db080                            # 004db074
    # block 0x004db076: entered by fall-through of jne at 0x004db074, 2 instruction(s), falls into the block at 0x004db080
    mov ecx, dword ptr [ebp - local_4]           # 004db076
    mov dword ptr [ecx + field_10], 0x1          # 004db079
L_004db080:
    # block 0x004db080: entered by jne at 0x004db074, 5 instruction(s), ends with ret 0x8
    mov edx, dword ptr [ebp - local_4]           # 004db080
    mov dword ptr [edx + field_c], 0x0           # 004db083
    {load} mov esp, ebp                          # 004db08a
    pop ebp                                      # 004db08c
    ret 0x8                                      # 004db08d

