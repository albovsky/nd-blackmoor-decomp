# FUN_004d3aa0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d3aa0
# extent:       0x004d3aa0-0x004d3b0a (106 code bytes)
# span:         0x004d3aa0-0x004d3b0a (code 106, tables 0, padding 0)
# sha256:       22c6c3c824d5b9f0993af673d98205d5cf9a4399894128bd12519e1c9284af84
# evidence:     ev_bf957760d550f0e548de8548930c8ec98377495a573f71e3ff1a1c67dc9f78d6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004d3aa0
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_004d3b1a
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
.set FUN_004d3b1a, .text + (0x004d3b1a - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x004d3aa0 - 0x401000
.globl FUN_004d3aa0
FUN_004d3aa0:
    # block 0x004d3aa0: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x004d3ae5 (forward)
    push ebp                                     # 004d3aa0
    {load} mov ebp, esp                          # 004d3aa1
    push -0x1                                    # 004d3aa3
    push 0x52885a                                # 004d3aa5
    mov eax, dword ptr fs:[0x0]                  # 004d3aaa
    push eax                                     # 004d3ab0
    mov dword ptr fs:[0x0], esp                  # 004d3ab1
    sub esp, 0xc                                 # 004d3ab8
    push 0x466                                   # 004d3abb
    call FUN_0051dc43                            # 004d3ac0
    add esp, 0x4                                 # 004d3ac5
    mov dword ptr [ebp - local_14], eax          # 004d3ac8
    mov dword ptr [ebp - local_4], 0x0           # 004d3acb
    cmp dword ptr [ebp - local_14], 0x0          # 004d3ad2
    je.d8 L_004d3ae5                             # 004d3ad6
    # block 0x004d3ad8: entered by fall-through of je at 0x004d3ad6, 4 instruction(s), calls FUN_004d3b1a, ends with forward jump to 0x004d3aec
    mov ecx, dword ptr [ebp - local_14]          # 004d3ad8
    call FUN_004d3b1a                            # 004d3adb
    mov dword ptr [ebp - local_18], eax          # 004d3ae0
    jmp.d8 L_004d3aec                            # 004d3ae3
L_004d3ae5:
    # block 0x004d3ae5: entered by je at 0x004d3ad6, 1 instruction(s), falls into the block at 0x004d3aec
    mov dword ptr [ebp - local_18], 0x0          # 004d3ae5
L_004d3aec:
    # block 0x004d3aec: entered by jmp at 0x004d3ae3, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 004d3aec
    mov dword ptr [ebp - local_10], eax          # 004d3aef
    mov dword ptr [ebp - local_4], 0xffffffff    # 004d3af2
    mov eax, dword ptr [ebp - local_10]          # 004d3af9
    mov ecx, dword ptr [ebp - local_c]           # 004d3afc
    mov dword ptr fs:[0x0], ecx                  # 004d3aff
    {load} mov esp, ebp                          # 004d3b06
    pop ebp                                      # 004d3b08
    ret                                          # 004d3b09

