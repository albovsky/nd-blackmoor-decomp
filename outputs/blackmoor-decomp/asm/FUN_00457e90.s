# FUN_00457e90
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00457e90
# extent:       0x00457e90-0x00457efa (106 code bytes)
# span:         0x00457e90-0x00457efa (code 106, tables 0, padding 0)
# sha256:       71cc1124047513c4810fbea525123a69280d47f92dbaf0f9e6ae6eefdfb383bb
# evidence:     ev_c5b87421894e5714fd1694e86f0c1a1a152e3b4da3a586d74d8eca29257d482a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00457e90
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_00457f0a
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
.set FUN_00457f0a, .text + (0x00457f0a - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x00457e90 - 0x401000
.globl FUN_00457e90
FUN_00457e90:
    # block 0x00457e90: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x00457ed5 (forward)
    push ebp                                     # 00457e90
    {load} mov ebp, esp                          # 00457e91
    push -0x1                                    # 00457e93
    push 0x52805a                                # 00457e95
    mov eax, dword ptr fs:[0x0]                  # 00457e9a
    push eax                                     # 00457ea0
    mov dword ptr fs:[0x0], esp                  # 00457ea1
    sub esp, 0xc                                 # 00457ea8
    push 0xf3                                    # 00457eab
    call FUN_0051dc43                            # 00457eb0
    add esp, 0x4                                 # 00457eb5
    mov dword ptr [ebp - local_14], eax          # 00457eb8
    mov dword ptr [ebp - local_4], 0x0           # 00457ebb
    cmp dword ptr [ebp - local_14], 0x0          # 00457ec2
    je.d8 L_00457ed5                             # 00457ec6
    # block 0x00457ec8: entered by fall-through of je at 0x00457ec6, 4 instruction(s), calls FUN_00457f0a, ends with forward jump to 0x00457edc
    mov ecx, dword ptr [ebp - local_14]          # 00457ec8
    call FUN_00457f0a                            # 00457ecb
    mov dword ptr [ebp - local_18], eax          # 00457ed0
    jmp.d8 L_00457edc                            # 00457ed3
L_00457ed5:
    # block 0x00457ed5: entered by je at 0x00457ec6, 1 instruction(s), falls into the block at 0x00457edc
    mov dword ptr [ebp - local_18], 0x0          # 00457ed5
L_00457edc:
    # block 0x00457edc: entered by jmp at 0x00457ed3, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 00457edc
    mov dword ptr [ebp - local_10], eax          # 00457edf
    mov dword ptr [ebp - local_4], 0xffffffff    # 00457ee2
    mov eax, dword ptr [ebp - local_10]          # 00457ee9
    mov ecx, dword ptr [ebp - local_c]           # 00457eec
    mov dword ptr fs:[0x0], ecx                  # 00457eef
    {load} mov esp, ebp                          # 00457ef6
    pop ebp                                      # 00457ef8
    ret                                          # 00457ef9

