# FUN_0050de76
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050de76
# extent:       0x0050de76-0x0050deda (100 code bytes)
# span:         0x0050de76-0x0050deda (code 100, tables 0, padding 0)
# sha256:       6daa9358a081d15136db69075b1c35ed9863e5f2bc5687c8e47afa98007bb40f
# evidence:     ev_4d268ec7993df48128cba5d0df1108836b8002175a429e70814bf1b72161879f
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050de76
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_4; [esi + n] field_c, field_10; [esp + n] stk_8
# callees:      calls FUN_005120d4, FUN_0050dcb0, FUN_00512178, FUN_00512126
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 38 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0050dcb0, .text + (0x0050dcb0 - 0x401000)
.set FUN_005120d4, .text + (0x005120d4 - 0x401000)
.set FUN_00512126, .text + (0x00512126 - 0x401000)
.set FUN_00512178, .text + (0x00512178 - 0x401000)

.org 0x0050de76 - 0x401000
.globl FUN_0050de76
FUN_0050de76:
    # block 0x0050de76: entry, 13 instruction(s), calls FUN_005120d4, FUN_0050dcb0, ends with je to 0x0050deaf (forward)
    push esi                                     # 0050de76
    mov esi, dword ptr [esp + stk_8]             # 0050de77
    push edi                                     # 0050de7b
    push esi                                     # 0050de7c
    mov edi, dword ptr [esi + field_10]          # 0050de7d
    call FUN_005120d4                            # 0050de80
    push esi                                     # 0050de85
    call FUN_0050dcb0                            # 0050de86
    and dword ptr [esi + field_c], -0x31         # 0050de8b
    pop ecx                                      # 0050de8f
    cmp edi, -0x1                                # 0050de90
    pop ecx                                      # 0050de93
    je.d8 L_0050deaf                             # 0050de94
    # block 0x0050de96: entered by fall-through of je at 0x0050de94, 8 instruction(s), ends with forward jump to 0x0050deb4
    {load} mov ecx, edi                          # 0050de96
    {load} mov eax, edi                          # 0050de98
    sar ecx, 0x5                                 # 0050de9a
    and eax, 0x1f                                # 0050de9d
    mov ecx, dword ptr [4*ecx + 0x63cde0]        # 0050dea0
    lea eax, [eax + 8*eax]                       # 0050dea7
    lea eax, [ecx + 4*eax]                       # 0050deaa
    jmp.d8 L_0050deb4                            # 0050dead
L_0050deaf:
    # block 0x0050deaf: entered by je at 0x0050de94, 1 instruction(s), falls into the block at 0x0050deb4
    mov eax, 0x568880                            # 0050deaf
L_0050deb4:
    # block 0x0050deb4: entered by jmp at 0x0050dead, 4 instruction(s), ends with je to 0x0050dec4 (forward)
    and byte ptr [eax + field_4], -0x3           # 0050deb4
    mov eax, dword ptr [esi + field_c]           # 0050deb8
    test al, -0x80                               # 0050debb
    je.d8 L_0050dec4                             # 0050debd
    # block 0x0050debf: entered by fall-through of je at 0x0050debd, 2 instruction(s), falls into the block at 0x0050dec4
    and al, -0x4                                 # 0050debf
    mov dword ptr [esi + field_c], eax           # 0050dec1
L_0050dec4:
    # block 0x0050dec4: entered by je at 0x0050debd, 10 instruction(s), calls FUN_00512178, FUN_00512126, ends with ret
    push 0x0                                     # 0050dec4
    push 0x0                                     # 0050dec6
    push edi                                     # 0050dec8
    call FUN_00512178                            # 0050dec9
    push esi                                     # 0050dece
    call FUN_00512126                            # 0050decf
    add esp, 0x10                                # 0050ded4
    pop edi                                      # 0050ded7
    pop esi                                      # 0050ded8
    ret                                          # 0050ded9

