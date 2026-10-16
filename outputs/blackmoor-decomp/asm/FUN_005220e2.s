# FUN_005220e2
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005220e2
# extent:       0x005220e2-0x00522113 (49 code bytes)
# span:         0x005220e2-0x00522113 (code 49, tables 0, padding 0)
# sha256:       16ba798efacaa213e5c4c10b72e972f0ff4d3cd5b4e7dee0c9bf62723236bf22
# evidence:     ev_678efcee983ed42467ff29c0f0add470391dbcd9713e4f2458e22dd6f2eb7249
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005220e2
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_1c, field_68
# callees:      calls USER32.dll!SendMessageA, FUN_0051abe4, FUN_00522316
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 20 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1c, 0x1c  # offset +0x1c
.equ field_68, 0x68  # offset +0x68

# --- external targets -----------------------------------------------
.set FUN_0051abe4, .text + (0x0051abe4 - 0x401000)
.set FUN_00522316, .text + (0x00522316 - 0x401000)

.org 0x005220e2 - 0x401000
.globl FUN_005220e2
FUN_005220e2:
    # block 0x005220e2: entry, 5 instruction(s), ends with je to 0x00522104 (forward)
    push esi                                     # 005220e2
    {load} mov esi, ecx                          # 005220e3
    mov eax, dword ptr [esi + field_1c]          # 005220e5
    test eax, eax                                # 005220e8
    je.d8 L_00522104                             # 005220ea
    # block 0x005220ec: entered by fall-through of je at 0x005220ea, 9 instruction(s), calls USER32.dll!SendMessageA, FUN_0051abe4, ends with ret
    push 0x0                                     # 005220ec
    push 0x0                                     # 005220ee
    push 0x476                                   # 005220f0
    push eax                                     # 005220f5
    call dword ptr [0x52a4c8]                    # 005220f6
    push eax                                     # 005220fc
    call FUN_0051abe4                            # 005220fd
    pop esi                                      # 00522102
    ret                                          # 00522103
L_00522104:
    # block 0x00522104: entered by je at 0x005220ea, 6 instruction(s), calls FUN_00522316, ends with ret
    {load} mov ecx, esi                          # 00522104
    call FUN_00522316                            # 00522106
    mov ecx, dword ptr [esi + field_68]          # 0052210b
    pop esi                                      # 0052210e
    mov eax, dword ptr [ecx + 4*eax]             # 0052210f
    ret                                          # 00522112

