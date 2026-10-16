# FUN_0048210a
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048210a
# extent:       0x0048210a-0x0048215e (84 code bytes)
# span:         0x0048210a-0x0048215e (code 84, tables 0, padding 0)
# sha256:       7534be9096a63f08d180114ef7ccefba3771bac014bdd9a323f87b929d1b32c2
# evidence:     ev_6c02d307fa64542cf9e9341ca14b210665cb9d9c7d2fca978f50048355ee46d9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0048210a
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d716, FUN_0048217a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 23 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_0048217a, .text + (0x0048217a - 0x401000)
.set FUN_0051d716, .text + (0x0051d716 - 0x401000)

.org 0x0048210a - 0x401000
.globl FUN_0048210a
FUN_0048210a:
    # block 0x0048210a: entry, 23 instruction(s), calls FUN_0051d716, FUN_0048217a, ends with ret
    push ebp                                     # 0048210a
    {load} mov ebp, esp                          # 0048210b
    push -0x1                                    # 0048210d
    push 0x5283bd                                # 0048210f
    mov eax, dword ptr fs:[0x0]                  # 00482114
    push eax                                     # 0048211a
    mov dword ptr fs:[0x0], esp                  # 0048211b
    push ecx                                     # 00482122
    mov dword ptr [ebp - local_10], ecx          # 00482123
    mov ecx, dword ptr [ebp - local_10]          # 00482126
    call FUN_0051d716                            # 00482129
    mov dword ptr [ebp - local_4], 0x0           # 0048212e
    mov eax, dword ptr [ebp - local_10]          # 00482135
    mov dword ptr [eax], 0x52d6b8                # 00482138
    mov ecx, dword ptr [ebp - local_10]          # 0048213e
    call FUN_0048217a                            # 00482141
    mov dword ptr [ebp - local_4], 0xffffffff    # 00482146
    mov eax, dword ptr [ebp - local_10]          # 0048214d
    mov ecx, dword ptr [ebp - local_c]           # 00482150
    mov dword ptr fs:[0x0], ecx                  # 00482153
    {load} mov esp, ebp                          # 0048215a
    pop ebp                                      # 0048215c
    ret                                          # 0048215d

