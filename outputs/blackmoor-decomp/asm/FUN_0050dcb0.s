# FUN_0050dcb0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0050dcb0
# extent:       0x0050dcb0-0x0050dd0c (92 code bytes)
# span:         0x0050dcb0-0x0050dd0c (code 92, tables 0, padding 0)
# sha256:       7fbfbf8d056b42c2813cbe62c846fcaf784fd2502c809eb31eb8997ce7cb7973
# evidence:     ev_4d268ec7993df48128cba5d0df1108836b8002175a429e70814bf1b72161879f
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0050dcb0
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_4, field_8, field_c, field_10; [esp + n] stk_c
# callees:      calls FUN_005132c9
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 40 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
# note:         further_unindexed_code_at:0x0050dd0c
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_4, 0x4  # offset +0x4
.equ field_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc
.equ field_c, 0xc  # offset +0xc
.equ field_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_005132c9, .text + (0x005132c9 - 0x401000)

.org 0x0050dcb0 - 0x401000
.globl FUN_0050dcb0
FUN_0050dcb0:
    # block 0x0050dcb0: entry, 10 instruction(s), ends with jne to 0x0050dcfd (forward)
    push ebx                                     # 0050dcb0
    push esi                                     # 0050dcb1
    mov esi, dword ptr [esp + stk_c]             # 0050dcb2
    {load} xor ebx, ebx                          # 0050dcb6
    push edi                                     # 0050dcb8
    mov eax, dword ptr [esi + field_c]           # 0050dcb9
    {load} mov ecx, eax                          # 0050dcbc
    and ecx, 0x3                                 # 0050dcbe
    cmp cl, 0x2                                  # 0050dcc1
    jne.d8 L_0050dcfd                            # 0050dcc4
    # block 0x0050dcc6: entered by fall-through of jne at 0x0050dcc4, 2 instruction(s), ends with je to 0x0050dcfd (forward)
    test ax, 0x108                               # 0050dcc6
    je.d8 L_0050dcfd                             # 0050dcca
    # block 0x0050dccc: entered by fall-through of je at 0x0050dcca, 5 instruction(s), ends with jle to 0x0050dcfd (forward)
    mov eax, dword ptr [esi + field_8]           # 0050dccc
    mov edi, dword ptr [esi]                     # 0050dccf
    {load} sub edi, eax                          # 0050dcd1
    test edi, edi                                # 0050dcd3
    jle.d8 L_0050dcfd                            # 0050dcd5
    # block 0x0050dcd7: entered by fall-through of jle at 0x0050dcd5, 7 instruction(s), calls FUN_005132c9, ends with jne to 0x0050dcf6 (forward)
    push edi                                     # 0050dcd7
    push eax                                     # 0050dcd8
    push dword ptr [esi + field_10]              # 0050dcd9
    call FUN_005132c9                            # 0050dcdc
    add esp, 0xc                                 # 0050dce1
    {load} cmp eax, edi                          # 0050dce4
    jne.d8 L_0050dcf6                            # 0050dce6
    # block 0x0050dce8: entered by fall-through of jne at 0x0050dce6, 3 instruction(s), ends with je to 0x0050dcfd (forward)
    mov eax, dword ptr [esi + field_c]           # 0050dce8
    test al, -0x80                               # 0050dceb
    je.d8 L_0050dcfd                             # 0050dced
    # block 0x0050dcef: entered by fall-through of je at 0x0050dced, 3 instruction(s), ends with forward jump to 0x0050dcfd
    and al, -0x3                                 # 0050dcef
    mov dword ptr [esi + field_c], eax           # 0050dcf1
    jmp.d8 L_0050dcfd                            # 0050dcf4
L_0050dcf6:
    # block 0x0050dcf6: entered by jne at 0x0050dce6, 2 instruction(s), falls into the block at 0x0050dcfd
    or dword ptr [esi + field_c], 0x20           # 0050dcf6
    or ebx, -0x1                                 # 0050dcfa
L_0050dcfd:
    # block 0x0050dcfd: entered by jne at 0x0050dcc4; je at 0x0050dcca; jle at 0x0050dcd5; je at 0x0050dced; more, 8 instruction(s), ends with ret
    mov eax, dword ptr [esi + field_8]           # 0050dcfd
    and dword ptr [esi + field_4], 0x0           # 0050dd00
    mov dword ptr [esi], eax                     # 0050dd04
    pop edi                                      # 0050dd06
    {load} mov eax, ebx                          # 0050dd07
    pop esi                                      # 0050dd09
    pop ebx                                      # 0050dd0a
    ret                                          # 0050dd0b

