# FUN_00470c90
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00470c90
# extent:       0x00470c90-0x00470cfa (106 code bytes)
# span:         0x00470c90-0x00470cfa (code 106, tables 0, padding 0)
# sha256:       f1eb7ec83fc555a84642f2dd870a33f2389390ec84bd2d0d5fc0292b50721991
# evidence:     ev_4142f99cf250975ea00b2347f810409c5bbf0cca5348258d5fd0578a4530c136
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m470c90_new_and_construct
# naming:       native port src/original_methods_fl36f.c:m470c90_new_and_construct (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    p = 0x51dc43(0xe0a); returns 0x470d0a(p), or 0 when p is 0; the SEH frame is not modelled. je taken both ways; all 29 instructions run.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       5 ebp-relative slot(s): local_4, local_c, local_10, local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051dc43, FUN_00470d0a
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl36f.c:m470c90_new_and_construct (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
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
.set FUN_00470d0a, .text + (0x00470d0a - 0x401000)
.set FUN_0051dc43, .text + (0x0051dc43 - 0x401000)

.org 0x00470c90 - 0x401000
.globl FUN_00470c90
FUN_00470c90:
    # block 0x00470c90: entry, 15 instruction(s), calls FUN_0051dc43, ends with je to 0x00470cd5 (forward)
    push ebp                                     # 00470c90
    {load} mov ebp, esp                          # 00470c91
    push -0x1                                    # 00470c93
    push 0x52827a                                # 00470c95
    mov eax, dword ptr fs:[0x0]                  # 00470c9a
    push eax                                     # 00470ca0
    mov dword ptr fs:[0x0], esp                  # 00470ca1
    sub esp, 0xc                                 # 00470ca8
    push 0xe0a                                   # 00470cab
    call FUN_0051dc43                            # 00470cb0
    add esp, 0x4                                 # 00470cb5
    mov dword ptr [ebp - local_14], eax          # 00470cb8
    mov dword ptr [ebp - local_4], 0x0           # 00470cbb
    cmp dword ptr [ebp - local_14], 0x0          # 00470cc2
    je.d8 L_00470cd5                             # 00470cc6
    # block 0x00470cc8: entered by fall-through of je at 0x00470cc6, 4 instruction(s), calls FUN_00470d0a, ends with forward jump to 0x00470cdc
    mov ecx, dword ptr [ebp - local_14]          # 00470cc8
    call FUN_00470d0a                            # 00470ccb
    mov dword ptr [ebp - local_18], eax          # 00470cd0
    jmp.d8 L_00470cdc                            # 00470cd3
L_00470cd5:
    # block 0x00470cd5: entered by je at 0x00470cc6, 1 instruction(s), falls into the block at 0x00470cdc
    mov dword ptr [ebp - local_18], 0x0          # 00470cd5
L_00470cdc:
    # block 0x00470cdc: entered by jmp at 0x00470cd3, 9 instruction(s), ends with ret
    mov eax, dword ptr [ebp - local_18]          # 00470cdc
    mov dword ptr [ebp - local_10], eax          # 00470cdf
    mov dword ptr [ebp - local_4], 0xffffffff    # 00470ce2
    mov eax, dword ptr [ebp - local_10]          # 00470ce9
    mov ecx, dword ptr [ebp - local_c]           # 00470cec
    mov dword ptr fs:[0x0], ecx                  # 00470cef
    {load} mov esp, ebp                          # 00470cf6
    pop ebp                                      # 00470cf8
    ret                                          # 00470cf9

