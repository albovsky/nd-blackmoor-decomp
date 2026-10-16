# FUN_004d6705
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d6705
# extent:       0x004d6705-0x004d6777 (114 code bytes)
# span:         0x004d6705-0x004d6787 (code 114, tables 16, padding 0)
# sha256:       1735753c674475a550ce370ca007a3fb84f31fad3783b12965259e344ff057c5
# evidence:     ev_b736ef8a907767b6bd5de2b1c70fa87373ac4b8d720af669c98493a6a3d19492
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d6705
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_4; [ecx + n] field_4
# callees:      calls FUN_004dae88, FUN_004d6787, FUN_004fb2a6, FUN_004d7162, FUN_004d794d
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 34 instruction(s), 1 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ field_4, 0x4  # offset +0x4

# --- external targets -----------------------------------------------
.set FUN_004d6787, .text + (0x004d6787 - 0x401000)
.set FUN_004d7162, .text + (0x004d7162 - 0x401000)
.set FUN_004d794d, .text + (0x004d794d - 0x401000)
.set FUN_004dae88, .text + (0x004dae88 - 0x401000)
.set FUN_004fb2a6, .text + (0x004fb2a6 - 0x401000)

.org 0x004d6705 - 0x401000
.globl FUN_004d6705
FUN_004d6705:
    # block 0x004d6705: entry, 9 instruction(s), ends with ja to 0x004d6773 (forward)
    push ebp                                     # 004d6705
    {load} mov ebp, esp                          # 004d6706
    sub esp, 0x8                                 # 004d6708
    mov dword ptr [ebp - local_4], ecx           # 004d670b
    mov eax, dword ptr [ebp - local_4]           # 004d670e
    mov ecx, dword ptr [eax + field_4]           # 004d6711
    mov dword ptr [ebp - local_8], ecx           # 004d6714
    cmp dword ptr [ebp - local_8], 0x3           # 004d6717
    ja.d8 L_004d6773                             # 004d671b
    # block 0x004d671d: entered by fall-through of ja at 0x004d671b, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x4d6777]
    mov edx, dword ptr [ebp - local_8]           # 004d671d
    jmp dword ptr [4*edx + SWTAB_004d6777_VA]    # 004d6720
L_004d6727:
    # block 0x004d6727: entered by switch case, 7 instruction(s), calls FUN_004dae88, FUN_004d6787, ends with forward jump to 0x004d6773
    push 0x0                                     # 004d6727
    push 0x0                                     # 004d6729
    mov ecx, 0x5830a6                            # 004d672b
    call FUN_004dae88                            # 004d6730
    mov ecx, dword ptr [ebp - local_4]           # 004d6735
    call FUN_004d6787                            # 004d6738
    jmp.d8 L_004d6773                            # 004d673d
L_004d673f:
    # block 0x004d673f: entered by switch case, 8 instruction(s), calls FUN_004fb2a6, ends with forward jump to 0x004d6773
    mov ax, word ptr [0x5b451f]                  # 004d673f
    push eax                                     # 004d6745
    push 0x5b452d                                # 004d6746
    mov ecx, 0x5c3a67                            # 004d674b
    call FUN_004fb2a6                            # 004d6750
    mov ecx, dword ptr [ebp - local_4]           # 004d6755
    mov dword ptr [ecx + field_4], 0x2           # 004d6758
    jmp.d8 L_004d6773                            # 004d675f
L_004d6761:
    # block 0x004d6761: entered by switch case, 3 instruction(s), calls FUN_004d7162, ends with forward jump to 0x004d6773
    mov ecx, dword ptr [ebp - local_4]           # 004d6761
    call FUN_004d7162                            # 004d6764
    jmp.d8 L_004d6773                            # 004d6769
L_004d676b:
    # block 0x004d676b: entered by switch case, 2 instruction(s), calls FUN_004d794d, falls into the block at 0x004d6773
    mov ecx, dword ptr [ebp - local_4]           # 004d676b
    call FUN_004d794d                            # 004d676e
L_004d6773:
    # block 0x004d6773: entered by ja at 0x004d671b; jmp at 0x004d673d; jmp at 0x004d675f; jmp at 0x004d6769, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004d6773
    pop ebp                                      # 004d6775
    ret                                          # 004d6776

# --- data items (not part of the function) -------------------------
.org 0x004d6777 - 0x401000
SWTAB_004d6777:  # 4 case address(es)
    .long L_004d6727 - .text + 0x401000
    .long L_004d673f - .text + 0x401000
    .long L_004d6761 - .text + 0x401000
    .long L_004d676b - .text + 0x401000
.set SWTAB_004d6777_VA, SWTAB_004d6777 - .text + 0x401000

