# FUN_004fe970
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004fe970
# extent:       0x004fe970-0x004fe99e (46 code bytes)
# span:         0x004fe970-0x004fe9a0 (code 46, tables 0, padding 2)
# sha256:       9aa9f6252f2515b313d5c68f6fbf9feb2d813c1ce4988a4e6ab59ab345a2d625
# evidence:     ev_972c31dda55968754e368178e4f1ca1e6ce23b20babc5beca5b7ede707c8db74
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004fe970
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_1; [esp + n] stk_8, stk_c, stk_10
# callees:      calls FUN_0050be60
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 23 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_1, 0x1  # offset +0x1
.equ stk_8, 0x8  # offset +0x8
.equ stk_c, 0xc  # offset +0xc
.equ stk_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_0050be60, .text + (0x0050be60 - 0x401000)

.org 0x004fe970 - 0x401000
.globl FUN_004fe970
FUN_004fe970:
    # block 0x004fe970: entry, 5 instruction(s), ends with je to 0x004fe99d (forward)
    mov eax, dword ptr [esp + stk_c]             # 004fe970
    {load} mov ecx, eax                          # 004fe974
    dec eax                                      # 004fe976
    test ecx, ecx                                # 004fe977
    je.d8 L_004fe99d                             # 004fe979
    # block 0x004fe97b: entered by fall-through of je at 0x004fe979, 6 instruction(s), falls into the block at 0x004fe989
    push ebx                                     # 004fe97b
    mov ebx, dword ptr [esp + stk_8]             # 004fe97c
    push esi                                     # 004fe980
    mov esi, dword ptr [esp + stk_10]            # 004fe981
    push edi                                     # 004fe985
    lea edi, [eax + field_1]                     # 004fe986
L_004fe989:
    # block 0x004fe989: entered by jne at 0x004fe998, 8 instruction(s), calls FUN_0050be60, ends with jne to 0x004fe989 (backward)
    push 0x8                                     # 004fe989
    push ebx                                     # 004fe98b
    call FUN_0050be60                            # 004fe98c
    add esp, 0x8                                 # 004fe991
    mov byte ptr [esi], al                       # 004fe994
    inc esi                                      # 004fe996
    dec edi                                      # 004fe997
    jne.d8 L_004fe989                            # 004fe998
    # block 0x004fe99a: entered by fall-through of jne at 0x004fe998, 3 instruction(s), falls into the block at 0x004fe99d
    pop edi                                      # 004fe99a
    pop esi                                      # 004fe99b
    pop ebx                                      # 004fe99c
L_004fe99d:
    # block 0x004fe99d: entered by je at 0x004fe979, 1 instruction(s), ends with ret
    ret                                          # 004fe99d

# --- data items (not part of the function) -------------------------
.org 0x004fe99e - 0x401000
PAD_004fe99e:  # 2 byte(s) of nop padding
    .fill 2, 1, 0x90

