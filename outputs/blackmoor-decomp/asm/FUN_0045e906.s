# FUN_0045e906
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0045e906
# extent:       0x0045e906-0x0045e9db (213 code bytes)
# span:         0x0045e906-0x0045e9db (code 213, tables 0, padding 0)
# sha256:       3a510d75c751a87a2f8833b27ae3d1675ed538d68de25b769c9563a4578589d7
# evidence:     ev_54414b0082ebcba364d23e408bbf47fe0ab1b670355f5030623cc5b8f4a5e988
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_move_card_between_players
# naming:       INFERRED (lower confidence, not verified): the repository text src/action_family_f6_runtime.c:214 says "0x45e906: move the card of column `col`, suit row `row` from player `from` to player `to`."
# name-note:    Moves the card of a column and suit row from one player to another.
# arguments:    4 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10, arg_14; ret 0x10 (callee pops 16 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_d0; [ecx + n] field_24, field_d0; [edx + n] field_24; [esi + n] field_24
# callees:      none: no call or outward jump
# track-n:      outputs/blackmoor-decomp/src/action_family_f6_runtime.c:move_card (function ledger class candidate_port; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 53 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10
.equ arg_14, 0x14  # offset +0x14
.equ field_24, 0x24  # offset +0x24
.equ field_d0, 0xd0  # offset +0xd0

# --- external targets -----------------------------------------------

.org 0x0045e906 - 0x401000
.globl FUN_0045e906
FUN_0045e906:
    # block 0x0045e906: entry, 53 instruction(s), ends with ret 0x10
    push ebp                                     # 0045e906
    {load} mov ebp, esp                          # 0045e907
    push ecx                                     # 0045e909
    push esi                                     # 0045e90a
    mov dword ptr [ebp - local_4], ecx           # 0045e90b
    movsx eax, word ptr [ebp + arg_10]           # 0045e90e
    imul eax, eax, 0x120                         # 0045e912
    mov ecx, dword ptr [ebp - local_4]           # 0045e918
    lea edx, [ecx + eax + field_24]              # 0045e91b
    movsx eax, word ptr [ebp + arg_c]            # 0045e91f
    imul eax, eax, 0x34                          # 0045e923
    {load} add edx, eax                          # 0045e926
    movsx ecx, word ptr [ebp + arg_8]            # 0045e928
    mov dword ptr [edx + 4*ecx], 0x0             # 0045e92c
    movsx edx, word ptr [ebp + arg_8]            # 0045e933
    movsx eax, word ptr [ebp + arg_10]           # 0045e937
    imul eax, eax, 0x120                         # 0045e93b
    mov ecx, dword ptr [ebp - local_4]           # 0045e941
    lea eax, [ecx + eax + field_24]              # 0045e944
    mov cx, word ptr [eax + 2*edx + field_d0]    # 0045e948
    sub cx, 0x1                                  # 0045e950
    movsx edx, word ptr [ebp + arg_8]            # 0045e954
    movsx eax, word ptr [ebp + arg_10]           # 0045e958
    imul eax, eax, 0x120                         # 0045e95c
    mov esi, dword ptr [ebp - local_4]           # 0045e962
    lea eax, [esi + eax + field_24]              # 0045e965
    mov word ptr [eax + 2*edx + field_d0], cx    # 0045e969
    movsx ecx, word ptr [ebp + arg_14]           # 0045e971
    imul ecx, ecx, 0x120                         # 0045e975
    mov edx, dword ptr [ebp - local_4]           # 0045e97b
    lea eax, [edx + ecx + field_24]              # 0045e97e
    movsx ecx, word ptr [ebp + arg_c]            # 0045e982
    imul ecx, ecx, 0x34                          # 0045e986
    {load} add eax, ecx                          # 0045e989
    movsx edx, word ptr [ebp + arg_8]            # 0045e98b
    mov dword ptr [eax + 4*edx], 0x1             # 0045e98f
    movsx eax, word ptr [ebp + arg_8]            # 0045e996
    movsx ecx, word ptr [ebp + arg_14]           # 0045e99a
    imul ecx, ecx, 0x120                         # 0045e99e
    mov edx, dword ptr [ebp - local_4]           # 0045e9a4
    lea ecx, [edx + ecx + field_24]              # 0045e9a7
    mov dx, word ptr [ecx + 2*eax + field_d0]    # 0045e9ab
    add dx, 0x1                                  # 0045e9b3
    movsx eax, word ptr [ebp + arg_8]            # 0045e9b7
    movsx ecx, word ptr [ebp + arg_14]           # 0045e9bb
    imul ecx, ecx, 0x120                         # 0045e9bf
    mov esi, dword ptr [ebp - local_4]           # 0045e9c5
    lea ecx, [esi + ecx + field_24]              # 0045e9c8
    mov word ptr [ecx + 2*eax + field_d0], dx    # 0045e9cc
    pop esi                                      # 0045e9d4
    {load} mov esp, ebp                          # 0045e9d5
    pop ebp                                      # 0045e9d7
    ret 0x10                                     # 0045e9d8

