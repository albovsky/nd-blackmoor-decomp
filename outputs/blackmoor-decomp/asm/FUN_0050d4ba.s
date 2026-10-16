# FUN_0050d4ba
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050d4ba
# extent:       0x0050d4ba-0x0050d4f5 (59 code bytes)
# span:         0x0050d4ba-0x0050d4f5 (code 59, tables 0, padding 0)
# sha256:       75e3d6d1dfd3eb452545682759a5ae80f137735c1d963f49f8f9dfd4112cdb14
# evidence:     ev_4d268ec7993df48128cba5d0df1108836b8002175a429e70814bf1b72161879f
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050d4ba
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_4; [esp + n] stk_c, stk_10
# callees:      calls FUN_005120d4, FUN_00510f91, FUN_00512126
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 27 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_00510f91, .text + (0x00510f91 - 0x401000)
.set FUN_005120d4, .text + (0x005120d4 - 0x401000)
.set FUN_00512126, .text + (0x00512126 - 0x401000)

.org 0x0050d4ba - 0x401000
.globl FUN_0050d4ba
FUN_0050d4ba:
    # block 0x0050d4ba: entry, 8 instruction(s), calls FUN_005120d4, ends with js to 0x0050d4db (forward)
    push esi                                     # 0050d4ba
    mov esi, dword ptr [esp + stk_c]             # 0050d4bb
    push edi                                     # 0050d4bf
    push esi                                     # 0050d4c0
    call FUN_005120d4                            # 0050d4c1
    dec dword ptr [esi + field_4]                # 0050d4c6
    pop ecx                                      # 0050d4c9
    js.d8 L_0050d4db                             # 0050d4ca
    # block 0x0050d4cc: entered by fall-through of js at 0x0050d4ca, 6 instruction(s), ends with forward jump to 0x0050d4e9
    mov ecx, dword ptr [esi]                     # 0050d4cc
    mov al, byte ptr [esp + stk_c]               # 0050d4ce
    movzx edi, al                                # 0050d4d2
    mov byte ptr [ecx], al                       # 0050d4d5
    inc dword ptr [esi]                          # 0050d4d7
    jmp.d8 L_0050d4e9                            # 0050d4d9
L_0050d4db:
    # block 0x0050d4db: entered by js at 0x0050d4ca, 6 instruction(s), calls FUN_00510f91, falls into the block at 0x0050d4e9
    push esi                                     # 0050d4db
    push dword ptr [esp + stk_10]                # 0050d4dc
    call FUN_00510f91                            # 0050d4e0
    pop ecx                                      # 0050d4e5
    {load} mov edi, eax                          # 0050d4e6
    pop ecx                                      # 0050d4e8
L_0050d4e9:
    # block 0x0050d4e9: entered by jmp at 0x0050d4d9, 7 instruction(s), calls FUN_00512126, ends with ret
    push esi                                     # 0050d4e9
    call FUN_00512126                            # 0050d4ea
    pop ecx                                      # 0050d4ef
    {load} mov eax, edi                          # 0050d4f0
    pop edi                                      # 0050d4f2
    pop esi                                      # 0050d4f3
    ret                                          # 0050d4f4

