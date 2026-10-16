# FUN_00468d70
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00468d70
# extent:       0x00468d70-0x00468dda (106 code bytes)
# span:         0x00468d70-0x00468dda (code 106, tables 0, padding 0)
# sha256:       5c8834377bbac757f18f24d40e23f975feff98fee21baebd6d8c7fa1398b6489
# evidence:     ev_b2266c122d0c3ebc240ee0b3dabe442ef76e91098e7869f9f9749891192d3067
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00468d70
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_00468dea
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
.set FUN_00468dea, .text + (0x00468dea - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x00468d70 - 0x401000
.globl FUN_00468d70
FUN_00468d70:
    # block 0x00468d70: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x00468db5 (forward)
    push ebp                                     # 00468d70
    {load} mov ebp, esp                          # 00468d71
    push -0x1                                    # 00468d73
    push 0x5281aa                                # 00468d75
    mov eax, dword ptr fs:[0x0]                  # 00468d7a
    push eax                                     # 00468d80
    mov dword ptr fs:[0x0], esp                  # 00468d81
    sub esp, 0xc                                 # 00468d88
    push 0x5b4                                   # 00468d8b
    call FUN_0051dc43                            # 00468d90
    add esp, 0x4                                 # 00468d95
    mov dword ptr [ebp - local_14], eax          # 00468d98
    mov dword ptr [ebp - local_4], 0x0           # 00468d9b
    cmp dword ptr [ebp - local_14], 0x0          # 00468da2
    je.d8 L_00468db5                             # 00468da6
    # block 0x00468da8: entered by fall-through of je at 0x00468da6, 4 instruction(s), calls FUN_00468dea, ends with forward jump to 0x00468dbc
    mov ecx, dword ptr [ebp - local_14]          # 00468da8
    call FUN_00468dea                            # 00468dab
    mov dword ptr [ebp - local_18], eax          # 00468db0
    jmp.d8 L_00468dbc                            # 00468db3
L_00468db5:
    # block 0x00468db5: entered by je at 0x00468da6, 1 instruction(s), falls into the block at 0x00468dbc
    mov dword ptr [ebp - local_18], 0x0          # 00468db5
L_00468dbc:
    # block 0x00468dbc: entered by jmp at 0x00468db3, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 00468dbc
    mov dword ptr [ebp - local_10], eax          # 00468dbf
    mov dword ptr [ebp - local_4], 0xffffffff    # 00468dc2
    mov eax, dword ptr [ebp - local_10]          # 00468dc9
    mov ecx, dword ptr [ebp - local_c]           # 00468dcc
    mov dword ptr fs:[0x0], ecx                  # 00468dcf
    {load} mov esp, ebp                          # 00468dd6
    pop ebp                                      # 00468dd8
    ret                                          # 00468dd9

