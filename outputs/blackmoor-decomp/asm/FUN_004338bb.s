# FUN_004338bb
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004338bb
# extent:       0x004338bb-0x00433bd2 (791 code bytes)
# span:         0x004338bb-0x00433bd2 (code 791, tables 0, padding 0)
# sha256:       8b53d4ddc85eeb4162a80e0a6de906b25ce1d2b40c1bebfdc31c02b1d4111252
# evidence:     ev_1d431cfa6c768c56b3ff5b0532b8ec8e82594a4738783c4d24404ae7730f624b
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_sound_record_state_handler
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4338bb.c.txt, not original source) refers to the data labelled s_NO_SOUND_00545dc8
# name-note:    Three-state per-scene handler that copies a sound name into the record, compares it to NO_SOUND, and otherwise starts it through FUN_004fb77a and FUN_004fb2e3.
# arguments:    1 ebp-relative stack slot(s) referenced: arg_8; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       2 ebp-relative slot(s): local_4, local_8
# fields:       [eax + n] field_22
# callees:      calls FUN_004fb77a, FUN_004fb2e3, FUN_00448d11, FUN_004f6334, FUN_004fba69; plus 2 indirect transfer(s) whose target is not resolved
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 174 instruction(s), 11 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; indirect transfers are not followed
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ arg_8, 0x8  # offset +0x8
.equ field_22, 0x22  # offset +0x22

# --- external targets -----------------------------------------------
.set FUN_00448d11, .text + (0x00448d11 - 0x401000)
.set FUN_004f6334, .text + (0x004f6334 - 0x401000)
.set FUN_004fb2e3, .text + (0x004fb2e3 - 0x401000)
.set FUN_004fb77a, .text + (0x004fb77a - 0x401000)
.set FUN_004fba69, .text + (0x004fba69 - 0x401000)

.org 0x004338bb - 0x401000
.globl FUN_004338bb
FUN_004338bb:
    # block 0x004338bb: entry, 11 instruction(s), ends with je to 0x004338f5 (forward)
    push ebp                                     # 004338bb
    {load} mov ebp, esp                          # 004338bc
    sub esp, 0x8                                 # 004338be
    push esi                                     # 004338c1
    push edi                                     # 004338c2
    movsx eax, word ptr [ebp + arg_8]            # 004338c3
    imul eax, eax, 0x8d                          # 004338c7
    mov ecx, dword ptr [eax + 0x5bb632]          # 004338cd
    mov dword ptr [ebp - local_8], ecx           # 004338d3
    cmp dword ptr [ebp - local_8], 0x0           # 004338d6
    je.d8 L_004338f5                             # 004338da
    # block 0x004338dc: entered by fall-through of je at 0x004338da, 2 instruction(s), ends with je to 0x00433a4f (forward)
    cmp dword ptr [ebp - local_8], 0x1           # 004338dc
    je.d32 L_00433a4f                            # 004338e0
    # block 0x004338e6: entered by fall-through of je at 0x004338e0, 2 instruction(s), ends with je to 0x00433aaf (forward)
    cmp dword ptr [ebp - local_8], 0x2           # 004338e6
    je.d32 L_00433aaf                            # 004338ea
    # block 0x004338f0: entered by fall-through of je at 0x004338ea, 1 instruction(s), ends with forward jump to 0x00433bcc
    jmp.d32 L_00433bcc                           # 004338f0
L_004338f5:
    # block 0x004338f5: entered by je at 0x004338da, 4 instruction(s), ends with jne to 0x0043392f (forward)
    movsx edx, word ptr [0x58c94f]               # 004338f5
    movsx eax, word ptr [2*edx + 0x58c951]       # 004338fc
    test eax, eax                                # 00433904
    jne.d8 L_0043392f                            # 00433906
    # block 0x00433908: entered by fall-through of jne at 0x00433906, 10 instruction(s), calls indirect dword ptr [4*eax + 0x5b604b], ends with forward jump to 0x00433954
    push 0x5b6057                                # 00433908
    push 0x1                                     # 0043390d
    movsx ecx, word ptr [ebp + arg_8]            # 0043390f
    imul ecx, ecx, 0x8d                          # 00433913
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00433919
    {load} xor eax, eax                          # 0043391f
    mov al, byte ptr [edx]                       # 00433921
    call dword ptr [4*eax + 0x5b604b]            # 00433923
    add esp, 0x8                                 # 0043392a
    jmp.d8 L_00433954                            # 0043392d
L_0043392f:
    # block 0x0043392f: entered by jne at 0x00433906, 9 instruction(s), calls indirect dword ptr [4*eax + 0x5b604b], falls into the block at 0x00433954
    push 0x5b6057                                # 0043392f
    push 0x0                                     # 00433934
    movsx ecx, word ptr [ebp + arg_8]            # 00433936
    imul ecx, ecx, 0x8d                          # 0043393a
    mov edx, dword ptr [ecx + 0x5bb5e5]          # 00433940
    {load} xor eax, eax                          # 00433946
    mov al, byte ptr [edx]                       # 00433948
    call dword ptr [4*eax + 0x5b604b]            # 0043394a
    add esp, 0x8                                 # 00433951
L_00433954:
    # block 0x00433954: entered by jmp at 0x0043392d, 4 instruction(s), ends with jne to 0x0043396f (forward)
    movsx ecx, word ptr [0x58c957]               # 00433954
    movsx edx, word ptr [0x5b6057]               # 0043395b
    {load} cmp ecx, edx                          # 00433962
    jne.d8 L_0043396f                            # 00433964
    # block 0x00433966: entered by fall-through of jne at 0x00433964, 1 instruction(s), falls into the block at 0x0043396f
    mov word ptr [0x5b6059], 0x0                 # 00433966
L_0043396f:
    # block 0x0043396f: entered by jne at 0x00433964, 28 instruction(s), ends with je to 0x00433a1c (forward)
    mov edi, 0x5b605b                            # 0043396f
    movsx eax, word ptr [ebp + arg_8]            # 00433974
    imul eax, eax, 0x8d                          # 00433978
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 0043397e
    add ecx, 0x1                                 # 00433984
    {load} mov edx, ecx                          # 00433987
    or ecx, -0x1                                 # 00433989
    {load} xor eax, eax                          # 0043398c
    repne scasb al, byte ptr es:[edi]            # 0043398e
    not ecx                                      # 00433990
    {load} sub edi, ecx                          # 00433992
    {load} mov esi, edi                          # 00433994
    {load} mov eax, ecx                          # 00433996
    {load} mov edi, edx                          # 00433998
    shr ecx, 0x2                                 # 0043399a
    rep movsd dword ptr es:[edi], dword ptr [esi] # 0043399d
    {load} mov ecx, eax                          # 0043399f
    and ecx, 0x3                                 # 004339a1
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004339a4
    mov edi, 0x545dc8                            # 004339a6
    movsx ecx, word ptr [ebp + arg_8]            # 004339ab
    imul ecx, ecx, 0x8d                          # 004339af
    mov esi, dword ptr [ecx + 0x5bb5e5]          # 004339b5
    add esi, 0x1                                 # 004339bb
    mov ecx, 0x9                                 # 004339be
    {load} xor edx, edx                          # 004339c3
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 004339c5
    je.d8 L_00433a1c                             # 004339c7
    # block 0x004339c9: entered by fall-through of je at 0x004339c7, 18 instruction(s), calls FUN_004fb77a, FUN_004fb2e3, ends with forward jump to 0x00433a30
    movsx eax, word ptr [ebp + arg_8]            # 004339c9
    imul eax, eax, 0x8d                          # 004339cd
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 004339d3
    add ecx, 0x1                                 # 004339d9
    push ecx                                     # 004339dc
    mov ecx, 0x5c3a67                            # 004339dd
    call FUN_004fb77a                            # 004339e2
    movsx edx, word ptr [ebp + arg_8]            # 004339e7
    imul edx, edx, 0x8d                          # 004339eb
    mov eax, dword ptr [edx + 0x5bb5e5]          # 004339f1
    mov cx, word ptr [eax + field_22]            # 004339f7
    push ecx                                     # 004339fb
    mov ecx, 0x5c3a67                            # 004339fc
    call FUN_004fb2e3                            # 00433a01
    movsx edx, word ptr [ebp + arg_8]            # 00433a06
    imul edx, edx, 0x8d                          # 00433a0a
    mov dword ptr [edx + 0x5bb632], 0x1          # 00433a10
    jmp.d8 L_00433a30                            # 00433a1a
L_00433a1c:
    # block 0x00433a1c: entered by je at 0x004339c7, 3 instruction(s), falls into the block at 0x00433a30
    movsx eax, word ptr [ebp + arg_8]            # 00433a1c
    imul eax, eax, 0x8d                          # 00433a20
    mov dword ptr [eax + 0x5bb632], 0x2          # 00433a26
L_00433a30:
    # block 0x00433a30: entered by jmp at 0x00433a1a, 8 instruction(s), calls FUN_00448d11, ends with forward jump to 0x00433bcc
    push 0x0                                     # 00433a30
    push -0x1                                    # 00433a32
    push 0x5b607c                                # 00433a34
    mov ecx, dword ptr [0x5d03b3]                # 00433a39
    push ecx                                     # 00433a3f
    mov ecx, 0x619a05                            # 00433a40
    call FUN_00448d11                            # 00433a45
    jmp.d32 L_00433bcc                           # 00433a4a
L_00433a4f:
    # block 0x00433a4f: entered by je at 0x004338e0, 11 instruction(s), calls FUN_004f6334, ends with jne to 0x00433aaa (forward)
    movsx edx, word ptr [ebp + arg_8]            # 00433a4f
    imul edx, edx, 0x8d                          # 00433a53
    mov eax, dword ptr [edx + 0x5bb5e5]          # 00433a59
    movsx ecx, word ptr [eax + field_22]         # 00433a5f
    mov dword ptr [ebp - local_4], ecx           # 00433a63
    mov edx, dword ptr [ebp - local_4]           # 00433a66
    push edx                                     # 00433a69
    mov ecx, 0x5cf1eb                            # 00433a6a
    call FUN_004f6334                            # 00433a6f
    test eax, eax                                # 00433a74
    jne.d8 L_00433aaa                            # 00433a76
    # block 0x00433a78: entered by fall-through of jne at 0x00433a76, 10 instruction(s), calls FUN_004fba69, falls into the block at 0x00433aaa
    movsx eax, word ptr [ebp + arg_8]            # 00433a78
    imul eax, eax, 0x8d                          # 00433a7c
    mov ecx, dword ptr [eax + 0x5bb5e5]          # 00433a82
    add ecx, 0x1                                 # 00433a88
    push ecx                                     # 00433a8b
    mov ecx, 0x5c3a67                            # 00433a8c
    call FUN_004fba69                            # 00433a91
    movsx edx, word ptr [ebp + arg_8]            # 00433a96
    imul edx, edx, 0x8d                          # 00433a9a
    mov dword ptr [edx + 0x5bb632], 0x2          # 00433aa0
L_00433aaa:
    # block 0x00433aaa: entered by jne at 0x00433a76, 1 instruction(s), ends with forward jump to 0x00433bcc
    jmp.d32 L_00433bcc                           # 00433aaa
L_00433aaf:
    # block 0x00433aaf: entered by je at 0x004338ea, 11 instruction(s), ends with jge to 0x00433b04 (forward)
    mov ax, word ptr [0x5b6057]                  # 00433aaf
    mov word ptr [0x58c957], ax                  # 00433ab5
    movsx ecx, word ptr [0x58c94f]               # 00433abb
    mov dx, word ptr [2*ecx + 0x58c951]          # 00433ac2
    add dx, word ptr [0x5b6059]                  # 00433aca
    movsx eax, word ptr [0x58c94f]               # 00433ad1
    mov word ptr [2*eax + 0x58c951], dx          # 00433ad8
    movsx ecx, word ptr [0x58c94f]               # 00433ae0
    movsx edx, word ptr [2*ecx + 0x58c951]       # 00433ae7
    test edx, edx                                # 00433aef
    jge.d8 L_00433b04                            # 00433af1
    # block 0x00433af3: entered by fall-through of jge at 0x00433af1, 2 instruction(s), falls into the block at 0x00433b04
    movsx eax, word ptr [0x58c94f]               # 00433af3
    mov word ptr [2*eax + 0x58c951], 0x0         # 00433afa
L_00433b04:
    # block 0x00433b04: entered by jge at 0x00433af1, 3 instruction(s), ends with je to 0x00433b9a (forward)
    movsx ecx, word ptr [0x5b6144]               # 00433b04
    cmp ecx, 0x270f                              # 00433b0b
    je.d32 L_00433b9a                            # 00433b11
    # block 0x00433b17: entered by fall-through of je at 0x00433b11, 17 instruction(s), ends with jne to 0x00433b86 (forward)
    movsx edx, word ptr [0x5b6144]               # 00433b17
    mov dword ptr [0x5bb57b], edx                # 00433b1e
    mov ax, word ptr [0x5b6146]                  # 00433b24
    mov word ptr [0x5bb599], ax                  # 00433b2a
    mov cx, word ptr [0x5b6148]                  # 00433b30
    mov word ptr [0x5bb595], cx                  # 00433b37
    mov dx, word ptr [0x5b614a]                  # 00433b3e
    mov word ptr [0x5c39ff], dx                  # 00433b45
    mov eax, dword ptr [0x5b614c]                # 00433b4c
    mov dword ptr [0x5bb59b], eax                # 00433b51
    mov ecx, dword ptr [0x5b6150]                # 00433b56
    mov dword ptr [0x5bb59f], ecx                # 00433b5c
    mov edx, dword ptr [0x5b6154]                # 00433b62
    mov dword ptr [0x5bb5a3], edx                # 00433b68
    movsx eax, word ptr [0x5b6158]               # 00433b6e
    cmp eax, 0x1                                 # 00433b75
    jne.d8 L_00433b86                            # 00433b78
    # block 0x00433b7a: entered by fall-through of jne at 0x00433b78, 2 instruction(s), ends with forward jump to 0x00433b90
    mov dword ptr [0x5bb1ca], 0x0                # 00433b7a
    jmp.d8 L_00433b90                            # 00433b84
L_00433b86:
    # block 0x00433b86: entered by jne at 0x00433b78, 1 instruction(s), falls into the block at 0x00433b90
    mov dword ptr [0x5bb1ca], 0x1                # 00433b86
L_00433b90:
    # block 0x00433b90: entered by jmp at 0x00433b84, 1 instruction(s), falls into the block at 0x00433b9a
    mov dword ptr [0x583999], 0x4                # 00433b90
L_00433b9a:
    # block 0x00433b9a: entered by je at 0x00433b11, 3 instruction(s), ends with je to 0x00433bbb (forward)
    movsx ecx, word ptr [0x5b615a]               # 00433b9a
    cmp ecx, -0x1                                # 00433ba1
    je.d8 L_00433bbb                             # 00433ba4
    # block 0x00433ba6: entered by fall-through of je at 0x00433ba4, 3 instruction(s), falls into the block at 0x00433bbb
    movsx edx, word ptr [0x5b615c]               # 00433ba6
    movsx eax, word ptr [0x5b615a]               # 00433bad
    mov dword ptr [4*eax + 0x585801], edx        # 00433bb4
L_00433bbb:
    # block 0x00433bbb: entered by je at 0x00433ba4, 3 instruction(s), falls into the block at 0x00433bcc
    movsx ecx, word ptr [ebp + arg_8]            # 00433bbb
    imul ecx, ecx, 0x8d                          # 00433bbf
    mov byte ptr [ecx + 0x5bb625], 0x1           # 00433bc5
L_00433bcc:
    # block 0x00433bcc: entered by jmp at 0x004338f0; jmp at 0x00433a4a; jmp at 0x00433aaa, 5 instruction(s), ends with ret
    pop edi                                      # 00433bcc
    pop esi                                      # 00433bcd
    {load} mov esp, ebp                          # 00433bce
    pop ebp                                      # 00433bd0
    ret                                          # 00433bd1

