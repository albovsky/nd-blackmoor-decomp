# FUN_0052139c
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0052139c
# extent:       0x0052139c-0x005213d4 (56 code bytes)
# span:         0x0052139c-0x005213d4 (code 56, tables 0, padding 0)
# sha256:       4a784d9bf9810a3ec0fbca28f1472f89bc5dff0538197b1419eb48d6edf1b4e6
# evidence:     ev_006be9b362b7cfce7238776a88a8741cad5ae334489097b537f8f7dadb6e60eb
# region:       crt_mfc
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0052139c
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       [eax + n] field_4; [edx + n] field_8c
# callees:      calls FUN_00525371, FUN_005212b5; plus 1 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 20 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ field_8c, 0x8c  # offset +0x8c

# --- external targets -----------------------------------------------
.set FUN_005212b5, .text + (0x005212b5 - 0x401000)
.set FUN_00525371, .text + (0x00525371 - 0x401000)

.org 0x0052139c - 0x401000
.globl FUN_0052139c
FUN_0052139c:
    # block 0x0052139c: entry, 6 instruction(s), calls FUN_00525371, ends with je to 0x005213c0 (forward)
    push ebp                                     # 0052139c
    {load} mov ebp, esp                          # 0052139d
    call FUN_00525371                            # 0052139f
    mov eax, dword ptr [eax + field_4]           # 005213a4
    test eax, eax                                # 005213a7
    je.d8 L_005213c0                             # 005213a9
    # block 0x005213ab: entered by fall-through of je at 0x005213a9, 7 instruction(s), calls indirect dword ptr [edx + 0x8c], ends with forward jump to 0x005213d0
    push dword ptr [ebp + arg_10]                # 005213ab
    mov edx, dword ptr [eax]                     # 005213ae
    {load} mov ecx, eax                          # 005213b0
    push dword ptr [ebp + arg_c]                 # 005213b2
    push dword ptr [ebp + arg_8]                 # 005213b5
    call dword ptr [edx + field_8c]              # 005213b8
    jmp.d8 L_005213d0                            # 005213be
L_005213c0:
    # block 0x005213c0: entered by je at 0x005213a9, 5 instruction(s), calls FUN_005212b5, falls into the block at 0x005213d0
    push dword ptr [ebp + arg_10]                # 005213c0
    {load} xor ecx, ecx                          # 005213c3
    push dword ptr [ebp + arg_c]                 # 005213c5
    push dword ptr [ebp + arg_8]                 # 005213c8
    call FUN_005212b5                            # 005213cb
L_005213d0:
    # block 0x005213d0: entered by jmp at 0x005213be, 2 instruction(s), ends with ret 0xc
    pop ebp                                      # 005213d0
    ret 0xc                                      # 005213d1

