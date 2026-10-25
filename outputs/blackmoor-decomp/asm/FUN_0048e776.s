# FUN_0048e776
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0048e776
# extent:       0x0048e776-0x0048e851 (219 code bytes)
# span:         0x0048e776-0x0048e851 (code 219, tables 0, padding 0)
# sha256:       1fa6da12ef5065bda9fe5aef6dabc70df4fa3d9fd2b8a3208d5987c8cfcdd48f
# evidence:     ev_7981f36fcfb340c87ff1ac4ba66e833832bd1313751938cee07fade4f0082dcf
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m48e776_lifted
# naming:       native port src/original_methods_fl41.c:m48e776_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated (scripts/lift_fl41.py), 4 seeds; oracle: 42/42 instructions, 4/4 jump directions; every mutant killed, identical -O2 code, or explained.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_46a; [ecx + n] field_431
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl41.c:m48e776_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 42 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ field_431, 0x431  # offset +0x431
.equ field_46a, 0x46a  # offset +0x46a

# --- external targets -----------------------------------------------

.org 0x0048e776 - 0x401000
.globl FUN_0048e776
FUN_0048e776:
    # block 0x0048e776: entry, 7 instruction(s), ends with jne to 0x0048e7dc (forward)
    push ebp                                     # 0048e776
    {load} mov ebp, esp                          # 0048e777
    push ecx                                     # 0048e779
    mov dword ptr [ebp - local_4], ecx           # 0048e77a
    movsx eax, word ptr [ebp + arg_8]            # 0048e77d
    cmp eax, 0x27b9                              # 0048e781
    jne.d8 L_0048e7dc                            # 0048e786
    # block 0x0048e788: entered by fall-through of jne at 0x0048e786, 13 instruction(s), ends with forward jump to 0x0048e84b
    mov dword ptr [0x5b44f0], 0x9                # 0048e788
    mov ecx, dword ptr [0x5d0377]                # 0048e792
    mov dword ptr [0x5d162d], ecx                # 0048e798
    mov dword ptr [0x5b44f4], 0x1                # 0048e79e
    mov edx, dword ptr [0x5b44f0]                # 0048e7a8
    shl edx, 0x5                                 # 0048e7ae
    mov eax, dword ptr [0x5b44f4]                # 0048e7b1
    shl eax, 0x4                                 # 0048e7b6
    lea ecx, [edx + eax + 0x5b160c]              # 0048e7b9
    mov dword ptr [0x5d1631], ecx                # 0048e7c0
    mov dword ptr [0x5d1639], 0x1                # 0048e7c6
    mov dword ptr [0x5c39e5], 0x27b9             # 0048e7d0
    jmp.d8 L_0048e84b                            # 0048e7da
L_0048e7dc:
    # block 0x0048e7dc: entered by jne at 0x0048e786, 4 instruction(s), ends with jne to 0x0048e84b (forward)
    movsx edx, word ptr [ebp + arg_c]            # 0048e7dc
    mov eax, dword ptr [ebp - local_4]           # 0048e7e0
    cmp dword ptr [eax + 4*edx + field_46a], 0x0 # 0048e7e3
    jne.d8 L_0048e84b                            # 0048e7eb
    # block 0x0048e7ed: entered by fall-through of jne at 0x0048e7eb, 15 instruction(s), falls into the block at 0x0048e84b
    mov ecx, dword ptr [ebp - local_4]           # 0048e7ed
    mov dx, word ptr [ebp + arg_c]               # 0048e7f0
    mov word ptr [ecx + field_431], dx           # 0048e7f4
    mov dword ptr [0x5b44f0], 0x16               # 0048e7fb
    mov eax, dword ptr [0x5d0377]                # 0048e805
    mov dword ptr [0x5d162d], eax                # 0048e80a
    mov dword ptr [0x5b44f4], 0x1                # 0048e80f
    mov ecx, dword ptr [0x5b44f0]                # 0048e819
    shl ecx, 0x5                                 # 0048e81f
    mov edx, dword ptr [0x5b44f4]                # 0048e822
    shl edx, 0x4                                 # 0048e828
    lea eax, [ecx + edx + 0x5b160c]              # 0048e82b
    mov dword ptr [0x5d1631], eax                # 0048e832
    mov dword ptr [0x5d1639], 0x1                # 0048e837
    mov dword ptr [0x5c39e5], 0x27b8             # 0048e841
L_0048e84b:
    # block 0x0048e84b: entered by jmp at 0x0048e7da; jne at 0x0048e7eb, 3 instruction(s), ends with ret 0x8
    {load} mov esp, ebp                          # 0048e84b
    pop ebp                                      # 0048e84d
    ret 0x8                                      # 0048e84e

