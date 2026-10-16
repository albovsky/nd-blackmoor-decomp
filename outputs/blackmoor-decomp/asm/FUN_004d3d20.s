# FUN_004d3d20
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d3d20
# extent:       0x004d3d20-0x004d3d3d (29 code bytes)
# span:         0x004d3d20-0x004d3d3d (code 29, tables 0, padding 0)
# sha256:       2a9b1b092c2d90c8120150375153f2ee790ce81e1bae154c2b7569f49645daaf
# evidence:     ev_bf957760d550f0e548de8548930c8ec98377495a573f71e3ff1a1c67dc9f78d6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d3d20
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [ecx + n] field_456
# callees:      calls KERNEL32.dll!GetTickCount
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 11 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_456, 0x456  # offset +0x456

# --- external targets -----------------------------------------------

.org 0x004d3d20 - 0x401000
.globl FUN_004d3d20
FUN_004d3d20:
    # block 0x004d3d20: entry, 11 instruction(s), calls KERNEL32.dll!GetTickCount, ends with ret
    push ebp                                     # 004d3d20
    {load} mov ebp, esp                          # 004d3d21
    push ecx                                     # 004d3d23
    mov dword ptr [ebp - local_4], ecx           # 004d3d24
    call dword ptr [0x52a23c]                    # 004d3d27
    sub eax, 0x5                                 # 004d3d2d
    mov ecx, dword ptr [ebp - local_4]           # 004d3d30
    mov dword ptr [ecx + field_456], eax         # 004d3d33
    {load} mov esp, ebp                          # 004d3d39
    pop ebp                                      # 004d3d3b
    ret                                          # 004d3d3c

