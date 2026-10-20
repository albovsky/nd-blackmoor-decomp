# FUN_00461d4b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00461d4b
# extent:       0x00461d4b-0x00461d82 (55 code bytes)
# span:         0x00461d4b-0x00461d82 (code 55, tables 0, padding 0)
# sha256:       cb08f5d1c239c2d4bde4bb68e4064e14c2a0d8473ad85894650b0d267401c812
# evidence:     ev_54414b0082ebcba364d23e408bbf47fe0ab1b670355f5030623cc5b8f4a5e988
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         type_is
# naming:       native port src/action_family_d3_runtime.c:type_is (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-17); the summary is the acceptance note
# summary:      1:1 with type_is (cell type compare). Result is visible to the oracle only through the parent's effects (solved scan, move checks).
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_d3_runtime.c:type_is (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 18 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and summary are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------

.org 0x00461d4b - 0x401000
.globl FUN_00461d4b
FUN_00461d4b:
    # block 0x00461d4b: entry, 12 instruction(s), ends with jne to 0x00461d7a (forward)
    push ebp                                     # 00461d4b
    {load} mov ebp, esp                          # 00461d4c
    push ecx                                     # 00461d4e
    mov dword ptr [ebp - local_4], ecx           # 00461d4f
    movsx eax, word ptr [ebp + arg_c]            # 00461d52
    imul eax, eax, 0x140                         # 00461d56
    movsx ecx, word ptr [ebp + arg_10]           # 00461d5c
    imul ecx, ecx, 0x28                          # 00461d60
    movsx edx, word ptr [eax + ecx + 0x594dd9]   # 00461d63
    movsx eax, word ptr [ebp + arg_8]            # 00461d6b
    {load} cmp edx, eax                          # 00461d6f
    jne.d8 L_00461d7a                            # 00461d71
    # block 0x00461d73: entered by fall-through of jne at 0x00461d71, 2 instruction(s), ends with forward jump to 0x00461d7c
    mov eax, 0x1                                 # 00461d73
    jmp.d8 L_00461d7c                            # 00461d78
L_00461d7a:
    # block 0x00461d7a: entered by jne at 0x00461d71, 1 instruction(s), falls into the block at 0x00461d7c
    {load} xor eax, eax                          # 00461d7a
L_00461d7c:
    # block 0x00461d7c: entered by jmp at 0x00461d78, 3 instruction(s), ends with ret 0xc
    {load} mov esp, ebp                          # 00461d7c
    pop ebp                                      # 00461d7e
    ret 0xc                                      # 00461d7f

