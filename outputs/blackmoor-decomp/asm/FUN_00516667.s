# FUN_00516667
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00516667
# extent:       0x00516667-0x005166ab (68 code bytes)
# span:         0x00516667-0x005166ab (code 68, tables 0, padding 0)
# sha256:       791f0f280140029e4f40c8b60889c44d4a13550cd1346d4212a8166bfd2e55dd
# evidence:     ev_98c0ebdb80e1dc743c9c9838442f65b708a07df0ee1290290e5016ddd355241c
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00516667
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ecx + n] field_4, field_8, field_c, field_14, field_18; [esp + n] stk_4
# callees:      calls FUN_0050ea90
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 19 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_4, 0x4  # offset +0x4
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18

# --- external targets -----------------------------------------------
.set FUN_0050ea90, .text + (0x0050ea90 - 0x401000)

.org 0x00516667 - 0x401000
.globl FUN_00516667
FUN_00516667:
    # block 0x00516667: entry, 8 instruction(s), calls FUN_0050ea90, ends with je to 0x00516690 (forward)
    inc dword ptr [0x63ca9c]                     # 00516667
    push 0x1000                                  # 0051666d
    call FUN_0050ea90                            # 00516672
    pop ecx                                      # 00516677
    mov ecx, dword ptr [esp + stk_4]             # 00516678
    test eax, eax                                # 0051667c
    mov dword ptr [ecx + field_8], eax           # 0051667e
    je.d8 L_00516690                             # 00516681
    # block 0x00516683: entered by fall-through of je at 0x00516681, 3 instruction(s), ends with forward jump to 0x005166a1
    or dword ptr [ecx + field_c], 0x8            # 00516683
    mov dword ptr [ecx + field_18], 0x1000       # 00516687
    jmp.d8 L_005166a1                            # 0051668e
L_00516690:
    # block 0x00516690: entered by je at 0x00516681, 4 instruction(s), falls into the block at 0x005166a1
    or dword ptr [ecx + field_c], 0x4            # 00516690
    lea eax, [ecx + field_14]                    # 00516694
    mov dword ptr [ecx + field_8], eax           # 00516697
    mov dword ptr [ecx + field_18], 0x2          # 0051669a
L_005166a1:
    # block 0x005166a1: entered by jmp at 0x0051668e, 4 instruction(s), ends with ret
    mov eax, dword ptr [ecx + field_8]           # 005166a1
    and dword ptr [ecx + field_4], 0x0           # 005166a4
    mov dword ptr [ecx], eax                     # 005166a8
    ret                                          # 005166aa

