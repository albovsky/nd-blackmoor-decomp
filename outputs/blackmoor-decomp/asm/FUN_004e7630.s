# FUN_004e7630
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e7630
# extent:       0x004e7630-0x004e7684 (84 code bytes)
# span:         0x004e7630-0x004e7684 (code 84, tables 0, padding 0)
# sha256:       924c3dae509ece20b085e12a3598478ec4cfcf4b9e9007920bd379aa5c9bfa9b
# evidence:     ev_4b72dd02859bc1f1213a228f2ee2963f47a2ab84ba0199a8e771a37aa8a24763
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e7630
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       3 ebp-relative slot(s): local_4, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004eda10, FUN_004e76d5
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 23 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10

# --- external targets -----------------------------------------------
.set FUN_004e76d5, .text + (0x004e76d5 - 0x401000)
.set FUN_004eda10, .text + (0x004eda10 - 0x401000)

.org 0x004e7630 - 0x401000
.globl FUN_004e7630
FUN_004e7630:
    # block 0x004e7630: entry, 23 instruction(s), calls FUN_004eda10, FUN_004e76d5, ends with ret
    push ebp                                     # 004e7630
    {load} mov ebp, esp                          # 004e7631
    push -0x1                                    # 004e7633
    push 0x528a09                                # 004e7635
    mov eax, dword ptr fs:[0x0]                  # 004e763a
    push eax                                     # 004e7640
    mov dword ptr fs:[0x0], esp                  # 004e7641
    push ecx                                     # 004e7648
    mov dword ptr [ebp - local_10], ecx          # 004e7649
    mov ecx, dword ptr [ebp - local_10]          # 004e764c
    call FUN_004eda10                            # 004e764f
    mov dword ptr [ebp - local_4], 0x0           # 004e7654
    mov eax, dword ptr [ebp - local_10]          # 004e765b
    mov dword ptr [eax], 0x52e4f0                # 004e765e
    mov ecx, dword ptr [ebp - local_10]          # 004e7664
    call FUN_004e76d5                            # 004e7667
    mov dword ptr [ebp - local_4], 0xffffffff    # 004e766c
    mov eax, dword ptr [ebp - local_10]          # 004e7673
    mov ecx, dword ptr [ebp - local_c]           # 004e7676
    mov dword ptr fs:[0x0], ecx                  # 004e7679
    {load} mov esp, ebp                          # 004e7680
    pop ebp                                      # 004e7682
    ret                                          # 004e7683

