# FUN_004ab2c0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004ab2c0
# extent:       0x004ab2c0-0x004ab327 (103 code bytes)
# span:         0x004ab2c0-0x004ab327 (code 103, tables 0, padding 0)
# sha256:       f90114d0fa67d11a400b9f76479ade1b5d7cf9f80e681776cdcb3187b4716541
# evidence:     ev_c162e587d744a5d109b183c8ad170721ecaf16eed1b508d2b71afde20c121117
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004ab2c0
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_004ab337
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
.set FUN_004ab337, .text + (0x004ab337 - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x004ab2c0 - 0x401000
.globl FUN_004ab2c0
FUN_004ab2c0:
    # block 0x004ab2c0: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x004ab302 (forward)
    push ebp                                     # 004ab2c0
    {load} mov ebp, esp                          # 004ab2c1
    push -0x1                                    # 004ab2c3
    push 0x52867a                                # 004ab2c5
    mov eax, dword ptr fs:[0x0]                  # 004ab2ca
    push eax                                     # 004ab2d0
    mov dword ptr fs:[0x0], esp                  # 004ab2d1
    sub esp, 0xc                                 # 004ab2d8
    push 0x62                                    # 004ab2db
    call FUN_0051dc43                            # 004ab2dd
    add esp, 0x4                                 # 004ab2e2
    mov dword ptr [ebp - local_14], eax          # 004ab2e5
    mov dword ptr [ebp - local_4], 0x0           # 004ab2e8
    cmp dword ptr [ebp - local_14], 0x0          # 004ab2ef
    je.d8 L_004ab302                             # 004ab2f3
    # block 0x004ab2f5: entered by fall-through of je at 0x004ab2f3, 4 instruction(s), calls FUN_004ab337, ends with forward jump to 0x004ab309
    mov ecx, dword ptr [ebp - local_14]          # 004ab2f5
    call FUN_004ab337                            # 004ab2f8
    mov dword ptr [ebp - local_18], eax          # 004ab2fd
    jmp.d8 L_004ab309                            # 004ab300
L_004ab302:
    # block 0x004ab302: entered by je at 0x004ab2f3, 1 instruction(s), falls into the block at 0x004ab309
    mov dword ptr [ebp - local_18], 0x0          # 004ab302
L_004ab309:
    # block 0x004ab309: entered by jmp at 0x004ab300, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 004ab309
    mov dword ptr [ebp - local_10], eax          # 004ab30c
    mov dword ptr [ebp - local_4], 0xffffffff    # 004ab30f
    mov eax, dword ptr [ebp - local_10]          # 004ab316
    mov ecx, dword ptr [ebp - local_c]           # 004ab319
    mov dword ptr fs:[0x0], ecx                  # 004ab31c
    {load} mov esp, ebp                          # 004ab323
    pop ebp                                      # 004ab325
    ret                                          # 004ab326

