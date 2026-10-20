# FUN_0042e560
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0042e560
# extent:       0x0042e560-0x0042e5c6 (102 code bytes)
# span:         0x0042e560-0x0042e5c6 (code 102, tables 0, padding 0)
# sha256:       1a763d06546b76749f6382a3694a1890fdcb557414518ab6d3c3a591e006d34d
# evidence:     ev_1d431cfa6c768c56b3ff5b0532b8ec8e82594a4738783c4d24404ae7730f624b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m42e560_save_block
# naming:       native port src/original_methods_fl16.c:m42e560_save_block (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m42e560_save_block; the 7 source globals are Fl16World fields, the target is a 0x12-byte block (0x5c3a05). The dword at 0x5c3a13 is stored twice (0x5bb5ab, then 0x5bb5af wins); native keeps both stores.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none: no [ebp-n] slot referenced
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl16.c:m42e560_save_block (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 20 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x0042e560 - 0x401000
.globl FUN_0042e560
FUN_0042e560:
    # block 0x0042e560: entry, 20 instruction(s), ends with ret
    push ebp                                     # 0042e560
    {load} mov ebp, esp                          # 0042e561
    mov ax, word ptr [0x5bb57b]                  # 0042e563
    mov word ptr [0x5c3a05], ax                  # 0042e569
    mov cx, word ptr [0x5bb57f]                  # 0042e56f
    mov word ptr [0x5c3a07], cx                  # 0042e576
    mov dx, word ptr [0x5bb50b]                  # 0042e57d
    mov word ptr [0x5c3a09], dx                  # 0042e584
    mov ax, word ptr [0x5bb593]                  # 0042e58b
    mov word ptr [0x5c3a0b], ax                  # 0042e591
    mov cx, word ptr [ebp + arg_8]               # 0042e597
    mov word ptr [0x5c3a0d], cx                  # 0042e59b
    mov edx, dword ptr [0x5bb5a7]                # 0042e5a2
    mov dword ptr [0x5c3a0f], edx                # 0042e5a8
    mov eax, dword ptr [0x5bb5ab]                # 0042e5ae
    mov dword ptr [0x5c3a13], eax                # 0042e5b3
    mov ecx, dword ptr [0x5bb5af]                # 0042e5b8
    mov dword ptr [0x5c3a13], ecx                # 0042e5be
    pop ebp                                      # 0042e5c4
    ret                                          # 0042e5c5

