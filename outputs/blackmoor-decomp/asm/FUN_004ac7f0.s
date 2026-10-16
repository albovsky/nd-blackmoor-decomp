# FUN_004ac7f0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ac7f0
# extent:       0x004ac7f0-0x004ac85a (106 code bytes)
# span:         0x004ac7f0-0x004ac85a (code 106, tables 0, padding 0)
# sha256:       59f487207b1daab75607191cf0ead652419c0d2249267cd0bc8a36dcdda8341d
# evidence:     ev_c162e587d744a5d109b183c8ad170721ecaf16eed1b508d2b71afde20c121117
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ac7f0
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_004ac86a
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
.set FUN_004ac86a, .text + (0x004ac86a - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x004ac7f0 - 0x401000
.globl FUN_004ac7f0
FUN_004ac7f0:
    # block 0x004ac7f0: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x004ac835 (forward)
    push ebp                                     # 004ac7f0
    {load} mov ebp, esp                          # 004ac7f1
    push -0x1                                    # 004ac7f3
    push 0x5286aa                                # 004ac7f5
    mov eax, dword ptr fs:[0x0]                  # 004ac7fa
    push eax                                     # 004ac800
    mov dword ptr fs:[0x0], esp                  # 004ac801
    sub esp, 0xc                                 # 004ac808
    push 0xe89                                   # 004ac80b
    call FUN_0051dc43                            # 004ac810
    add esp, 0x4                                 # 004ac815
    mov dword ptr [ebp - local_14], eax          # 004ac818
    mov dword ptr [ebp - local_4], 0x0           # 004ac81b
    cmp dword ptr [ebp - local_14], 0x0          # 004ac822
    je.d8 L_004ac835                             # 004ac826
    # block 0x004ac828: entered by fall-through of je at 0x004ac826, 4 instruction(s), calls FUN_004ac86a, ends with forward jump to 0x004ac83c
    mov ecx, dword ptr [ebp - local_14]          # 004ac828
    call FUN_004ac86a                            # 004ac82b
    mov dword ptr [ebp - local_18], eax          # 004ac830
    jmp.d8 L_004ac83c                            # 004ac833
L_004ac835:
    # block 0x004ac835: entered by je at 0x004ac826, 1 instruction(s), falls into the block at 0x004ac83c
    mov dword ptr [ebp - local_18], 0x0          # 004ac835
L_004ac83c:
    # block 0x004ac83c: entered by jmp at 0x004ac833, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 004ac83c
    mov dword ptr [ebp - local_10], eax          # 004ac83f
    mov dword ptr [ebp - local_4], 0xffffffff    # 004ac842
    mov eax, dword ptr [ebp - local_10]          # 004ac849
    mov ecx, dword ptr [ebp - local_c]           # 004ac84c
    mov dword ptr fs:[0x0], ecx                  # 004ac84f
    {load} mov esp, ebp                          # 004ac856
    pop ebp                                      # 004ac858
    ret                                          # 004ac859

