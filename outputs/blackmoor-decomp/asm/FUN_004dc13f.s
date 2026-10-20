# FUN_004dc13f
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004dc13f
# extent:       0x004dc13f-0x004dc182 (67 code bytes)
# span:         0x004dc13f-0x004dc182 (code 67, tables 0, padding 0)
# sha256:       2c2ead175899b41015ad88f8174e568d9b17d9c0de2d91ac9008971bddfd1895
# evidence:     ev_1170d6ff0aa8c399a4290cb7ce31f9814821c7e7912b3a9e53fd0c614d22037c
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_partner_logo_load_boot_chunk
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4dc13f.c.txt, not original source) refers to the data labelled s_CPartnerLogo__LoadBootChunkData__0055b058
# name-note:    Copies boot chunk data into the partner logo object and logs CPartnerLogo::LoadBootChunkData.
# arguments:    2 ebp-relative stack slot(s) referenced: arg_8, arg_c; ret 0x8 (callee pops 8 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0044a2b7
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 27 instruction(s), 1 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0044a2b7, .text + (0x0044a2b7 - 0x401000)

.org 0x004dc13f - 0x401000
.globl FUN_004dc13f
FUN_004dc13f:
    # block 0x004dc13f: entry, 19 instruction(s), ends with je to 0x004dc17a (forward)
    push ebp                                     # 004dc13f
    {load} mov ebp, esp                          # 004dc140
    push ecx                                     # 004dc142
    push esi                                     # 004dc143
    push edi                                     # 004dc144
    mov dword ptr [ebp - local_4], ecx           # 004dc145
    mov ecx, dword ptr [ebp + arg_c]             # 004dc148
    mov esi, dword ptr [ebp + arg_8]             # 004dc14b
    mov edi, dword ptr [ebp - local_4]           # 004dc14e
    add edi, 0x4e                                # 004dc151
    {load} mov eax, ecx                          # 004dc154
    shr ecx, 0x2                                 # 004dc156
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004dc159
    {load} mov ecx, eax                          # 004dc15b
    and ecx, 0x3                                 # 004dc15d
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004dc160
    movsx ecx, word ptr [0x63a4cd]               # 004dc162
    test ecx, ecx                                # 004dc169
    je.d8 L_004dc17a                             # 004dc16b
    # block 0x004dc16d: entered by fall-through of je at 0x004dc16b, 3 instruction(s), calls FUN_0044a2b7, falls into the block at 0x004dc17a
    push 0x55b058                                # 004dc16d
    call FUN_0044a2b7                            # 004dc172
    add esp, 0x4                                 # 004dc177
L_004dc17a:
    # block 0x004dc17a: entered by je at 0x004dc16b, 5 instruction(s), ends with ret 0x8
    pop edi                                      # 004dc17a
    pop esi                                      # 004dc17b
    {load} mov esp, ebp                          # 004dc17c
    pop ebp                                      # 004dc17e
    ret 0x8                                      # 004dc17f

