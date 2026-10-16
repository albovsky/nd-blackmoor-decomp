# FUN_004e3833
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e3833
# extent:       0x004e3833-0x004e386e (59 code bytes)
# span:         0x004e3833-0x004e386e (code 59, tables 0, padding 0)
# sha256:       17ade75f7e47230f27d8eb97ee54ced6f6f8ac9ab2381948c30c64242fabe980
# evidence:     ev_4b72dd02859bc1f1213a228f2ee2963f47a2ab84ba0199a8e771a37aa8a24763
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e3833
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004e2940
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 19 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004e2940, .text + (0x004e2940 - 0x401000)

.org 0x004e3833 - 0x401000
.globl FUN_004e3833
FUN_004e3833:
    # block 0x004e3833: entry, 19 instruction(s), calls FUN_004e2940, ends with ret
    push ebp                                     # 004e3833
    {load} mov ebp, esp                          # 004e3834
    push ecx                                     # 004e3836
    mov dword ptr [ebp - local_4], ecx           # 004e3837
    push 0x0                                     # 004e383a
    mov ecx, dword ptr [ebp - local_4]           # 004e383c
    add ecx, 0x3d5d                              # 004e383f
    call FUN_004e2940                            # 004e3845
    push 0x0                                     # 004e384a
    mov ecx, dword ptr [ebp - local_4]           # 004e384c
    add ecx, 0x3eec                              # 004e384f
    call FUN_004e2940                            # 004e3855
    push 0x0                                     # 004e385a
    mov ecx, dword ptr [ebp - local_4]           # 004e385c
    add ecx, 0x407b                              # 004e385f
    call FUN_004e2940                            # 004e3865
    {load} mov esp, ebp                          # 004e386a
    pop ebp                                      # 004e386c
    ret                                          # 004e386d

