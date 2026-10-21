# FUN_0041bda0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041bda0
# extent:       0x0041bda0-0x0041be0a (106 code bytes)
# span:         0x0041bda0-0x0041be0a (code 106, tables 0, padding 0)
# sha256:       7ca851010c878644be521db69ac28ba9456e510df3b89806ed5d8e7eeacfd39f
# evidence:     ev_6d14e36254d52595d49112e8022fb6a1363c93f1543311eb137634febb6a6ec5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m41bda0_new_and_construct
# naming:       native port src/original_methods_fl36f.c:m41bda0_new_and_construct (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    p = 0x51dc43(0x20ef); returns 0x41be1a(p), or 0 when p is 0; the SEH frame is not modelled. je taken both ways; all 29 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_0041be1a
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36f.c:m41bda0_new_and_construct (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 29 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
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
.set FUN_0041be1a, .text + (0x0041be1a - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x0041bda0 - 0x401000
.globl FUN_0041bda0
FUN_0041bda0:
    # block 0x0041bda0: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x0041bde5 (forward)
    push ebp                                     # 0041bda0
    {load} mov ebp, esp                          # 0041bda1
    push -0x1                                    # 0041bda3
    push 0x5272fa                                # 0041bda5
    mov eax, dword ptr fs:[0x0]                  # 0041bdaa
    push eax                                     # 0041bdb0
    mov dword ptr fs:[0x0], esp                  # 0041bdb1
    sub esp, 0xc                                 # 0041bdb8
    push 0x20ef                                  # 0041bdbb
    call FUN_0051dc43                            # 0041bdc0
    add esp, 0x4                                 # 0041bdc5
    mov dword ptr [ebp - local_14], eax          # 0041bdc8
    mov dword ptr [ebp - local_4], 0x0           # 0041bdcb
    cmp dword ptr [ebp - local_14], 0x0          # 0041bdd2
    je.d8 L_0041bde5                             # 0041bdd6
    # block 0x0041bdd8: entered by fall-through of je at 0x0041bdd6, 4 instruction(s), calls FUN_0041be1a, ends with forward jump to 0x0041bdec
    mov ecx, dword ptr [ebp - local_14]          # 0041bdd8
    call FUN_0041be1a                            # 0041bddb
    mov dword ptr [ebp - local_18], eax          # 0041bde0
    jmp.d8 L_0041bdec                            # 0041bde3
L_0041bde5:
    # block 0x0041bde5: entered by je at 0x0041bdd6, 1 instruction(s), falls into the block at 0x0041bdec
    mov dword ptr [ebp - local_18], 0x0          # 0041bde5
L_0041bdec:
    # block 0x0041bdec: entered by jmp at 0x0041bde3, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 0041bdec
    mov dword ptr [ebp - local_10], eax          # 0041bdef
    mov dword ptr [ebp - local_4], 0xffffffff    # 0041bdf2
    mov eax, dword ptr [ebp - local_10]          # 0041bdf9
    mov ecx, dword ptr [ebp - local_c]           # 0041bdfc
    mov dword ptr fs:[0x0], ecx                  # 0041bdff
    {load} mov esp, ebp                          # 0041be06
    pop ebp                                      # 0041be08
    ret                                          # 0041be09

