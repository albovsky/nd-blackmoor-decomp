# FUN_004d3ffe
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004d3ffe
# extent:       0x004d3ffe-0x004d4043 (69 code bytes)
# span:         0x004d3ffe-0x004d4043 (code 69, tables 0, padding 0)
# sha256:       f7af5f83f20156758a5d5d86c3c24ac4d049c4eaec7921725c65f94053f8f275
# evidence:     ev_bf957760d550f0e548de8548930c8ec98377495a573f71e3ff1a1c67dc9f78d6
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4d3ffe_start_flag
# naming:       native port src/original_methods_fl34c.c:m4d3ffe_start_flag (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-21); the note is the acceptance note, a statement about the native port
# name-note:    Stores self+0x440=1, calls 0x4dad60(ecx 0x5830a6), clears dword self+0x462, then reads byte 0x61c6ae (zero-extended) after the call: when 0, clears self+0x1c. jne both ways.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_1c, field_440; [ecx + n] field_462
# callees:      calls FUN_004dad60
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl34c.c:m4d3ffe_start_flag (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 19 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_1c, 0x1c  # offset +0x1c
.equ field_440, 0x440  # offset +0x440
.equ field_462, 0x462  # offset +0x462

# --- external targets -----------------------------------------------
.set FUN_004dad60, .text + (0x004dad60 - 0x401000)

.org 0x004d3ffe - 0x401000
.globl FUN_004d3ffe
FUN_004d3ffe:
    # block 0x004d3ffe: entry, 14 instruction(s), calls FUN_004dad60, ends with jne to 0x004d403f (forward)
    push ebp                                     # 004d3ffe
    {load} mov ebp, esp                          # 004d3fff
    push ecx                                     # 004d4001
    mov dword ptr [ebp - local_4], ecx           # 004d4002
    mov eax, dword ptr [ebp - local_4]           # 004d4005
    mov dword ptr [eax + field_440], 0x1         # 004d4008
    mov ecx, 0x5830a6                            # 004d4012
    call FUN_004dad60                            # 004d4017
    mov ecx, dword ptr [ebp - local_4]           # 004d401c
    mov dword ptr [ecx + field_462], 0x0         # 004d401f
    {load} xor edx, edx                          # 004d4029
    mov dl, byte ptr [0x61c6ae]                  # 004d402b
    test edx, edx                                # 004d4031
    jne.d8 L_004d403f                            # 004d4033
    # block 0x004d4035: entered by fall-through of jne at 0x004d4033, 2 instruction(s), falls into the block at 0x004d403f
    mov eax, dword ptr [ebp - local_4]           # 004d4035
    mov dword ptr [eax + field_1c], 0x0          # 004d4038
L_004d403f:
    # block 0x004d403f: entered by jne at 0x004d4033, 3 instruction(s), ends with ret
    {load} mov esp, ebp                          # 004d403f
    pop ebp                                      # 004d4041
    ret                                          # 004d4042

