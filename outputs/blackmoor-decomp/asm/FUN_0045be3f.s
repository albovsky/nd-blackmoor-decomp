# FUN_0045be3f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045be3f
# extent:       0x0045be3f-0x0045be7f (64 code bytes)
# span:         0x0045be3f-0x0045be7f (code 64, tables 0, padding 0)
# sha256:       23ab2bf99ef5490fcce4ae406fb4f129643ccf024537544746c09e1e714de1e4
# evidence:     ev_f51cc55276120d19811669e671858343b4478877f4752e92acf19b83badf3e68
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         real_name
# naming:       native port src/action_family_da_runtime.c:real_name (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with real_name (a sound name that is neither 'NO SOUND' nor empty). Takes the name bytes as a pointer, as the original does.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; ret 0x4 (callee pops 4 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_da_runtime.c:real_name (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 28 instruction(s), 2 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8

# --- external targets -----------------------------------------------

.org 0x0045be3f - 0x401000
.globl FUN_0045be3f
FUN_0045be3f:
    # block 0x0045be3f: entry, 12 instruction(s), ends with je to 0x0045be75 (forward)
    push ebp                                     # 0045be3f
    {load} mov ebp, esp                          # 0045be40
    push ecx                                     # 0045be42
    push esi                                     # 0045be43
    push edi                                     # 0045be44
    mov dword ptr [ebp - local_4], ecx           # 0045be45
    mov edi, 0x54ab68                            # 0045be48
    mov esi, dword ptr [ebp + arg_8]             # 0045be4d
    mov ecx, 0x9                                 # 0045be50
    {load} xor eax, eax                          # 0045be55
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 0045be57
    je.d8 L_0045be75                             # 0045be59
    # block 0x0045be5b: entered by fall-through of je at 0x0045be59, 8 instruction(s), ends with jbe to 0x0045be75 (forward)
    mov edi, dword ptr [ebp + arg_8]             # 0045be5b
    or ecx, -0x1                                 # 0045be5e
    {load} xor eax, eax                          # 0045be61
    repne scasb al, byte ptr es:[edi]            # 0045be63
    not ecx                                      # 0045be65
    add ecx, -0x1                                # 0045be67
    test ecx, ecx                                # 0045be6a
    jbe.d8 L_0045be75                            # 0045be6c
    # block 0x0045be6e: entered by fall-through of jbe at 0x0045be6c, 2 instruction(s), ends with forward jump to 0x0045be77
    mov eax, 0x1                                 # 0045be6e
    jmp.d8 L_0045be77                            # 0045be73
L_0045be75:
    # block 0x0045be75: entered by je at 0x0045be59; jbe at 0x0045be6c, 1 instruction(s), falls into the block at 0x0045be77
    {load} xor eax, eax                          # 0045be75
L_0045be77:
    # block 0x0045be77: entered by jmp at 0x0045be73, 5 instruction(s), ends with ret 0x4
    pop edi                                      # 0045be77
    pop esi                                      # 0045be78
    {load} mov esp, ebp                          # 0045be79
    pop ebp                                      # 0045be7b
    ret 0x4                                      # 0045be7c

