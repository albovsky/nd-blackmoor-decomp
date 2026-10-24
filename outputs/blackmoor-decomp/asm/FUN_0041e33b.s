# FUN_0041e33b
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0041e33b
# extent:       0x0041e33b-0x0041e3c0 (133 code bytes)
# span:         0x0041e33b-0x0041e3c0 (code 133, tables 0, padding 0)
# sha256:       c96f2494a4f282846e1cd8945432c26355d2fec8cac7536fd151a98f14ce6d7f
# evidence:     ev_6d14e36254d52595d49112e8022fb6a1363c93f1543311eb137634febb6a6ec5
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m41e33b_lifted
# naming:       native port src/original_methods_fl40.c:m41e33b_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 3 seeds; oracle 34/34 instructions, 0/0 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m41e33b_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 34 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x0041e33b - 0x401000
.globl FUN_0041e33b
FUN_0041e33b:
    # block 0x0041e33b: entry, 34 instruction(s), ends with ret
    push ebp                                     # 0041e33b
    {load} mov ebp, esp                          # 0041e33c
    push ecx                                     # 0041e33e
    push esi                                     # 0041e33f
    push edi                                     # 0041e340
    mov dword ptr [ebp - local_4], ecx           # 0041e341
    mov dword ptr [0x5d1909], 0xb                # 0041e344
    mov dword ptr [0x5d190d], 0x422a0a           # 0041e34e
    mov dword ptr [0x5d1911], 0x0                # 0041e358
    mov dword ptr [0x5d1915], 0x0                # 0041e362
    mov dword ptr [0x5d1919], 0x0                # 0041e36c
    mov dword ptr [0x5d191d], 0x0                # 0041e376
    mov dword ptr [0x5d1921], 0x1                # 0041e380
    mov word ptr [0x5d1925], 0x1                 # 0041e38a
    mov edi, 0x54387c                            # 0041e393
    mov edx, 0x5d192b                            # 0041e398
    or ecx, -0x1                                 # 0041e39d
    {load} xor eax, eax                          # 0041e3a0
    repne scasb al, byte ptr es:[edi]            # 0041e3a2
    not ecx                                      # 0041e3a4
    {load} sub edi, ecx                          # 0041e3a6
    {load} mov esi, edi                          # 0041e3a8
    {load} mov eax, ecx                          # 0041e3aa
    {load} mov edi, edx                          # 0041e3ac
    shr ecx, 0x2                                 # 0041e3ae
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0041e3b1
    {load} mov ecx, eax                          # 0041e3b3
    and ecx, 0x3                                 # 0041e3b5
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 0041e3b8
    pop edi                                      # 0041e3ba
    pop esi                                      # 0041e3bb
    {load} mov esp, ebp                          # 0041e3bc
    pop ebp                                      # 0041e3be
    ret                                          # 0041e3bf

