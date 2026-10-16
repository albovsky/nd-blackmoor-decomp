# FUN_0050d505
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050d505
# extent:       0x0050d505-0x0050d536 (49 code bytes)
# span:         0x0050d505-0x0050d536 (code 49, tables 0, padding 0)
# sha256:       55a7c0c239a02455cb9fd497abfc124e04d409ac301ab663bf69c403301e0dfc
# evidence:     ev_4d268ec7993df48128cba5d0df1108836b8002175a429e70814bf1b72161879f
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050d505
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_4; [esp + n] stk_8
# callees:      calls FUN_005120d4, FUN_0051235b, FUN_00512126
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 24 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ stk_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------
.set FUN_005120d4, .text + (0x005120d4 - 0x401000)
.set FUN_00512126, .text + (0x00512126 - 0x401000)
.set FUN_0051235b, .text + (0x0051235b - 0x401000)

.org 0x0050d505 - 0x401000
.globl FUN_0050d505
FUN_0050d505:
    # block 0x0050d505: entry, 8 instruction(s), calls FUN_005120d4, ends with js to 0x0050d521 (forward)
    push esi                                     # 0050d505
    mov esi, dword ptr [esp + stk_8]             # 0050d506
    push edi                                     # 0050d50a
    push esi                                     # 0050d50b
    call FUN_005120d4                            # 0050d50c
    dec dword ptr [esi + field_4]                # 0050d511
    pop ecx                                      # 0050d514
    js.d8 L_0050d521                             # 0050d515
    # block 0x0050d517: entered by fall-through of js at 0x0050d515, 5 instruction(s), ends with forward jump to 0x0050d52a
    mov eax, dword ptr [esi]                     # 0050d517
    movzx edi, byte ptr [eax]                    # 0050d519
    inc eax                                      # 0050d51c
    mov dword ptr [esi], eax                     # 0050d51d
    jmp.d8 L_0050d52a                            # 0050d51f
L_0050d521:
    # block 0x0050d521: entered by js at 0x0050d515, 4 instruction(s), calls FUN_0051235b, falls into the block at 0x0050d52a
    push esi                                     # 0050d521
    call FUN_0051235b                            # 0050d522
    pop ecx                                      # 0050d527
    {load} mov edi, eax                          # 0050d528
L_0050d52a:
    # block 0x0050d52a: entered by jmp at 0x0050d51f, 7 instruction(s), calls FUN_00512126, ends with ret
    push esi                                     # 0050d52a
    call FUN_00512126                            # 0050d52b
    pop ecx                                      # 0050d530
    {load} mov eax, edi                          # 0050d531
    pop edi                                      # 0050d533
    pop esi                                      # 0050d534
    ret                                          # 0050d535

