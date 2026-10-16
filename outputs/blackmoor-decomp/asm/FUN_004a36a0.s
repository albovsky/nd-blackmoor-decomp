# FUN_004a36a0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004a36a0
# extent:       0x004a36a0-0x004a370a (106 code bytes)
# span:         0x004a36a0-0x004a370a (code 106, tables 0, padding 0)
# sha256:       a6b1c22a0d05202f0b80347ee2e9ee03debb9725bc411ff076b85bf0341fdff3
# evidence:     ev_fc5359404bceb01696d4d66c12c8c7af865d10a5749afed948949b75d1acc7af
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004a36a0
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_004a371a
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 29 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18

# --- external targets -----------------------------------------------
.set FUN_004a371a, .text + (0x004a371a - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x004a36a0 - 0x401000
.globl FUN_004a36a0
FUN_004a36a0:
    # block 0x004a36a0: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x004a36e5 (forward)
    push ebp                                     # 004a36a0
    {load} mov ebp, esp                          # 004a36a1
    push -0x1                                    # 004a36a3
    push 0x5285ba                                # 004a36a5
    mov eax, dword ptr fs:[0x0]                  # 004a36aa
    push eax                                     # 004a36b0
    mov dword ptr fs:[0x0], esp                  # 004a36b1
    sub esp, 0xc                                 # 004a36b8
    push 0x840                                   # 004a36bb
    call FUN_0051dc43                            # 004a36c0
    add esp, 0x4                                 # 004a36c5
    mov dword ptr [ebp - local_14], eax          # 004a36c8
    mov dword ptr [ebp - local_4], 0x0           # 004a36cb
    cmp dword ptr [ebp - local_14], 0x0          # 004a36d2
    je.d8 L_004a36e5                             # 004a36d6
    # block 0x004a36d8: entered by fall-through of je at 0x004a36d6, 4 instruction(s), calls FUN_004a371a, ends with forward jump to 0x004a36ec
    mov ecx, dword ptr [ebp - local_14]          # 004a36d8
    call FUN_004a371a                            # 004a36db
    mov dword ptr [ebp - local_18], eax          # 004a36e0
    jmp.d8 L_004a36ec                            # 004a36e3
L_004a36e5:
    # block 0x004a36e5: entered by je at 0x004a36d6, 1 instruction(s), falls into the block at 0x004a36ec
    mov dword ptr [ebp - local_18], 0x0          # 004a36e5
L_004a36ec:
    # block 0x004a36ec: entered by jmp at 0x004a36e3, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 004a36ec
    mov dword ptr [ebp - local_10], eax          # 004a36ef
    mov dword ptr [ebp - local_4], 0xffffffff    # 004a36f2
    mov eax, dword ptr [ebp - local_10]          # 004a36f9
    mov ecx, dword ptr [ebp - local_c]           # 004a36fc
    mov dword ptr fs:[0x0], ecx                  # 004a36ff
    {load} mov esp, ebp                          # 004a3706
    pop ebp                                      # 004a3708
    ret                                          # 004a3709

