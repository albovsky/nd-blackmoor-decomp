# FUN_005250cb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005250cb
# extent:       0x005250cb-0x0052513f (116 code bytes)
# span:         0x005250cb-0x0052513f (code 116, tables 0, padding 0)
# sha256:       a28a42518be0405221d072b234bde5267a8c7f1f62b7a72eea9bfe94be164acb
# evidence:     ev_2c715b3bd3208197e01b2ebef20c92856fcb381a668a9ff837ea142d14b02822
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005250cb
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_58; [ebp + n] field_minus_4, field_minus_c, field_minus_10; [esi + n] field_c, field_2c, field_30, field_cc
# callees:      calls FUN_0050f978, FUN_0050e936; plus 4 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 44 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_4, 0x4  # offset +0x4
.equ field_c, 0xc  # offset +0xc
.equ field_2c, 0x2c  # offset +0x2c
.equ field_30, 0x30  # offset +0x30
.equ field_58, 0x58  # offset +0x58
.equ field_cc, 0xcc  # offset +0xcc

# --- external targets -----------------------------------------------
.set FUN_0050e936, .text + (0x0050e936 - 0x401000)
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)

.org 0x005250cb - 0x401000
.globl FUN_005250cb
FUN_005250cb:
    # block 0x005250cb: entry, 13 instruction(s), calls FUN_0050f978, ends with je to 0x00525109 (forward)
    mov eax, 0x528fc8                            # 005250cb
    call FUN_0050f978                            # 005250d0
    push ecx                                     # 005250d5
    push esi                                     # 005250d6
    {load} mov esi, ecx                          # 005250d7
    push edi                                     # 005250d9
    mov dword ptr [ebp - field_minus_10], esi    # 005250da
    mov dword ptr [esi], 0x52fb7c                # 005250dd
    mov ecx, dword ptr [esi + field_cc]          # 005250e3
    and dword ptr [ebp - field_minus_4], 0x0     # 005250e9
    lea edi, [esi + field_cc]                    # 005250ed
    test ecx, ecx                                # 005250f3
    je.d8 L_00525109                             # 005250f5
    # block 0x005250f7: entered by fall-through of je at 0x005250f5, 5 instruction(s), calls indirect dword ptr [eax + 0x58], ends with je to 0x00525109 (forward)
    mov eax, dword ptr [ecx]                     # 005250f7
    call dword ptr [eax + field_58]              # 005250f9
    mov ecx, dword ptr [edi]                     # 005250fc
    test ecx, ecx                                # 005250fe
    je.d8 L_00525109                             # 00525100
    # block 0x00525102: entered by fall-through of je at 0x00525100, 3 instruction(s), calls indirect dword ptr [eax + 0x4], falls into the block at 0x00525109
    mov eax, dword ptr [ecx]                     # 00525102
    push 0x1                                     # 00525104
    call dword ptr [eax + field_4]               # 00525106
L_00525109:
    # block 0x00525109: entered by je at 0x005250f5; je at 0x00525100, 4 instruction(s), ends with je to 0x00525119 (forward)
    mov eax, dword ptr [esi + field_30]          # 00525109
    mov edi, dword ptr [0x52a42c]                # 0052510c
    test eax, eax                                # 00525112
    je.d8 L_00525119                             # 00525114
    # block 0x00525116: entered by fall-through of je at 0x00525114, 2 instruction(s), calls indirect edi, falls into the block at 0x00525119
    push eax                                     # 00525116
    call edi                                     # 00525117
L_00525119:
    # block 0x00525119: entered by je at 0x00525114, 3 instruction(s), ends with je to 0x00525123 (forward)
    mov eax, dword ptr [esi + field_2c]          # 00525119
    test eax, eax                                # 0052511c
    je.d8 L_00525123                             # 0052511e
    # block 0x00525120: entered by fall-through of je at 0x0052511e, 2 instruction(s), calls indirect edi, falls into the block at 0x00525123
    push eax                                     # 00525120
    call edi                                     # 00525121
L_00525123:
    # block 0x00525123: entered by je at 0x0052511e, 3 instruction(s), ends with je to 0x00525131 (forward)
    mov esi, dword ptr [esi + field_c]           # 00525123
    test esi, esi                                # 00525126
    je.d8 L_00525131                             # 00525128
    # block 0x0052512a: entered by fall-through of je at 0x00525128, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x00525131
    push esi                                     # 0052512a
    call FUN_0050e936                            # 0052512b
    pop ecx                                      # 00525130
L_00525131:
    # block 0x00525131: entered by je at 0x00525128, 6 instruction(s), ends with ret
    mov ecx, dword ptr [ebp - field_minus_c]     # 00525131
    pop edi                                      # 00525134
    pop esi                                      # 00525135
    mov dword ptr fs:[0x0], ecx                  # 00525136
    leave                                        # 0052513d
    ret                                          # 0052513e

