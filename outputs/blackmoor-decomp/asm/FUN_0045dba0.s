# FUN_0045dba0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045dba0
# extent:       0x0045dba0-0x0045dc0a (106 code bytes)
# span:         0x0045dba0-0x0045dc0a (code 106, tables 0, padding 0)
# sha256:       a6b574a600c15cf13702d1bc23a3d2fd91073a05ad9f5d17d78a9dc36c4981d4
# evidence:     ev_f51cc55276120d19811669e671858343b4478877f4752e92acf19b83badf3e68
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0045dba0
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read in the entry block before being written
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0045dc1a
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
.set FUN_0045dc1a, .text + (0x0045dc1a - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x0045dba0 - 0x401000
.globl FUN_0045dba0
FUN_0045dba0:
    # block 0x0045dba0: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x0045dbe5 (forward)
    push ebp                                     # 0045dba0
    {load} mov ebp, esp                          # 0045dba1
    push -0x1                                    # 0045dba3
    push 0x5280ea                                # 0045dba5
    mov eax, dword ptr fs:[0x0]                  # 0045dbaa
    push eax                                     # 0045dbb0
    mov dword ptr fs:[0x0], esp                  # 0045dbb1
    sub esp, 0xc                                 # 0045dbb8
    push 0x3af                                   # 0045dbbb
    call FUN_0051dc43                            # 0045dbc0
    add esp, 0x4                                 # 0045dbc5
    mov dword ptr [ebp - local_14], eax          # 0045dbc8
    mov dword ptr [ebp - local_4], 0x0           # 0045dbcb
    cmp dword ptr [ebp - local_14], 0x0          # 0045dbd2
    je.d8 L_0045dbe5                             # 0045dbd6
    # block 0x0045dbd8: entered by fall-through of je at 0x0045dbd6, 4 instruction(s), calls FUN_0045dc1a, ends with forward jump to 0x0045dbec
    mov ecx, dword ptr [ebp - local_14]          # 0045dbd8
    call FUN_0045dc1a                            # 0045dbdb
    mov dword ptr [ebp - local_18], eax          # 0045dbe0
    jmp.d8 L_0045dbec                            # 0045dbe3
L_0045dbe5:
    # block 0x0045dbe5: entered by je at 0x0045dbd6, 1 instruction(s), falls into the block at 0x0045dbec
    mov dword ptr [ebp - local_18], 0x0          # 0045dbe5
L_0045dbec:
    # block 0x0045dbec: entered by jmp at 0x0045dbe3, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 0045dbec
    mov dword ptr [ebp - local_10], eax          # 0045dbef
    mov dword ptr [ebp - local_4], 0xffffffff    # 0045dbf2
    mov eax, dword ptr [ebp - local_10]          # 0045dbf9
    mov ecx, dword ptr [ebp - local_c]           # 0045dbfc
    mov dword ptr fs:[0x0], ecx                  # 0045dbff
    {load} mov esp, ebp                          # 0045dc06
    pop ebp                                      # 0045dc08
    ret                                          # 0045dc09

