# FUN_0051e6f1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051e6f1
# extent:       0x0051e6f1-0x0051e722 (49 code bytes)
# span:         0x0051e6f1-0x0051e722 (code 49, tables 0, padding 0)
# sha256:       b073c443c24e7825f10e5cb84c914c3aeb5cf5cd0c9ab923c6d470c99a242984
# evidence:     ev_96f1bc62419512d08d4ff3f4c9af28b1e7ac57401ae5f5f4318134ff6bf21907
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051e6f1
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [eax + n] field_minus_c
# callees:      calls KERNEL32.dll!InterlockedDecrement, FUN_0051e6a9
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 18 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_c, 0xc  # offset -0xc

# --- external targets -----------------------------------------------
.set FUN_0051e6a9, .text + (0x0051e6a9 - 0x401000)

.org 0x0051e6f1 - 0x401000
.globl FUN_0051e6f1
FUN_0051e6f1:
    # block 0x0051e6f1: entry, 6 instruction(s), ends with je to 0x0051e720 (forward)
    push esi                                     # 0051e6f1
    {load} mov esi, ecx                          # 0051e6f2
    mov eax, dword ptr [esi]                     # 0051e6f4
    lea ecx, [eax - field_minus_c]               # 0051e6f6
    cmp ecx, dword ptr [0x5679b4]                # 0051e6f9
    je.d8 L_0051e720                             # 0051e6ff
    # block 0x0051e701: entered by fall-through of je at 0x0051e6ff, 5 instruction(s), calls KERNEL32.dll!InterlockedDecrement, ends with jg to 0x0051e719 (forward)
    add eax, -0xc                                # 0051e701
    push eax                                     # 0051e704
    call dword ptr [0x52a1fc]                    # 0051e705
    test eax, eax                                # 0051e70b
    jg.d8 L_0051e719                             # 0051e70d
    # block 0x0051e70f: entered by fall-through of jg at 0x0051e70d, 3 instruction(s), calls FUN_0051e6a9, falls into the block at 0x0051e719
    mov ecx, dword ptr [esi]                     # 0051e70f
    sub ecx, 0xc                                 # 0051e711
    call FUN_0051e6a9                            # 0051e714
L_0051e719:
    # block 0x0051e719: entered by jg at 0x0051e70d, 2 instruction(s), falls into the block at 0x0051e720
    mov eax, dword ptr [0x5679b0]                # 0051e719
    mov dword ptr [esi], eax                     # 0051e71e
L_0051e720:
    # block 0x0051e720: entered by je at 0x0051e6ff, 2 instruction(s), ends with ret
    pop esi                                      # 0051e720
    ret                                          # 0051e721

