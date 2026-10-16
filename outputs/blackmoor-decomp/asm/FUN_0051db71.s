# FUN_0051db71
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051db71
# extent:       0x0051db71-0x0051dbc8 (87 code bytes)
# span:         0x0051db71-0x0051dbc8 (code 87, tables 0, padding 0)
# sha256:       f2dee2b0296c9e31bc1ce5ba25c3c534b45e5ea1ae599cbc7ff1b663046c1cee
# evidence:     ev_d600326f1458d8c8d5fec5204c0799b9a1ca52f1bb674b8356a1738515f4e4f7
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051db71
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4, field_1c; [esi + n] field_4, field_8, field_c, field_10, field_14; [esp + n] stk_8, stk_c
# callees:      calls USER32.dll!GetMenuState, USER32.dll!ModifyMenuA, FUN_00521117
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 31 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ stk_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ stk_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_1c, 0x1c  # offset +0x1c

# --- external targets -----------------------------------------------
.set FUN_00521117, .text + (0x00521117 - 0x401000)

.org 0x0051db71 - 0x401000
.globl FUN_0051db71
FUN_0051db71:
    # block 0x0051db71: entry, 5 instruction(s), ends with je to 0x0051dbb5 (forward)
    push esi                                     # 0051db71
    {load} mov esi, ecx                          # 0051db72
    mov eax, dword ptr [esi + field_c]           # 0051db74
    test eax, eax                                # 0051db77
    je.d8 L_0051dbb5                             # 0051db79
    # block 0x0051db7b: entered by fall-through of je at 0x0051db79, 2 instruction(s), ends with jne to 0x0051dbc4 (forward)
    cmp dword ptr [esi + field_10], 0x0          # 0051db7b
    jne.d8 L_0051dbc4                            # 0051db7f
    # block 0x0051db81: entered by fall-through of jne at 0x0051db7f, 18 instruction(s), calls USER32.dll!GetMenuState, USER32.dll!ModifyMenuA, ends with forward jump to 0x0051dbc4
    mov ecx, dword ptr [esi + field_8]           # 0051db81
    push edi                                     # 0051db84
    mov edi, 0x400                               # 0051db85
    push edi                                     # 0051db8a
    push ecx                                     # 0051db8b
    push dword ptr [eax + field_4]               # 0051db8c
    call dword ptr [0x52a348]                    # 0051db8f
    push dword ptr [esp + stk_c]                 # 0051db95
    .insn 0x66, 0x25, 0xf6fb{:u16}               # 0051db99
    {load} or eax, edi                           # 0051db9d
    push dword ptr [esi + field_4]               # 0051db9f
    push eax                                     # 0051dba2
    mov eax, dword ptr [esi + field_c]           # 0051dba3
    push dword ptr [esi + field_8]               # 0051dba6
    push dword ptr [eax + field_4]               # 0051dba9
    call dword ptr [0x52a344]                    # 0051dbac
    pop edi                                      # 0051dbb2
    jmp.d8 L_0051dbc4                            # 0051dbb3
L_0051dbb5:
    # block 0x0051dbb5: entered by je at 0x0051db79, 4 instruction(s), calls FUN_00521117, falls into the block at 0x0051dbc4
    push dword ptr [esp + stk_8]                 # 0051dbb5
    mov eax, dword ptr [esi + field_14]          # 0051dbb9
    push dword ptr [eax + field_1c]              # 0051dbbc
    call FUN_00521117                            # 0051dbbf
L_0051dbc4:
    # block 0x0051dbc4: entered by jne at 0x0051db7f; jmp at 0x0051dbb3, 2 instruction(s), ends with ret 0x4
    pop esi                                      # 0051dbc4
    ret 0x4                                      # 0051dbc5

