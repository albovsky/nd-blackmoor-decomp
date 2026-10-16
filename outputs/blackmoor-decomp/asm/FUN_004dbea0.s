# FUN_004dbea0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004dbea0
# extent:       0x004dbea0-0x004dbf0a (106 code bytes)
# span:         0x004dbea0-0x004dbf0a (code 106, tables 0, padding 0)
# sha256:       c5759ff5cdec6e07e7637d6a418afddd6e7db751af1cb92b5f9306095598109b
# evidence:     ev_1170d6ff0aa8c399a4290cb7ce31f9814821c7e7912b3a9e53fd0c614d22037c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004dbea0
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_004dbf1a
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
.set FUN_004dbf1a, .text + (0x004dbf1a - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x004dbea0 - 0x401000
.globl FUN_004dbea0
FUN_004dbea0:
    # block 0x004dbea0: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x004dbee5 (forward)
    push ebp                                     # 004dbea0
    {load} mov ebp, esp                          # 004dbea1
    push -0x1                                    # 004dbea3
    push 0x52888a                                # 004dbea5
    mov eax, dword ptr fs:[0x0]                  # 004dbeaa
    push eax                                     # 004dbeb0
    mov dword ptr fs:[0x0], esp                  # 004dbeb1
    sub esp, 0xc                                 # 004dbeb8
    push 0x10a                                   # 004dbebb
    call FUN_0051dc43                            # 004dbec0
    add esp, 0x4                                 # 004dbec5
    mov dword ptr [ebp - local_14], eax          # 004dbec8
    mov dword ptr [ebp - local_4], 0x0           # 004dbecb
    cmp dword ptr [ebp - local_14], 0x0          # 004dbed2
    je.d8 L_004dbee5                             # 004dbed6
    # block 0x004dbed8: entered by fall-through of je at 0x004dbed6, 4 instruction(s), calls FUN_004dbf1a, ends with forward jump to 0x004dbeec
    mov ecx, dword ptr [ebp - local_14]          # 004dbed8
    call FUN_004dbf1a                            # 004dbedb
    mov dword ptr [ebp - local_18], eax          # 004dbee0
    jmp.d8 L_004dbeec                            # 004dbee3
L_004dbee5:
    # block 0x004dbee5: entered by je at 0x004dbed6, 1 instruction(s), falls into the block at 0x004dbeec
    mov dword ptr [ebp - local_18], 0x0          # 004dbee5
L_004dbeec:
    # block 0x004dbeec: entered by jmp at 0x004dbee3, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 004dbeec
    mov dword ptr [ebp - local_10], eax          # 004dbeef
    mov dword ptr [ebp - local_4], 0xffffffff    # 004dbef2
    mov eax, dword ptr [ebp - local_10]          # 004dbef9
    mov ecx, dword ptr [ebp - local_c]           # 004dbefc
    mov dword ptr fs:[0x0], ecx                  # 004dbeff
    {load} mov esp, ebp                          # 004dbf06
    pop ebp                                      # 004dbf08
    ret                                          # 004dbf09

