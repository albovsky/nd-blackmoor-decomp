# FUN_004456e1
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004456e1
# extent:       0x004456e1-0x004458b8 (471 code bytes)
# span:         0x004456e1-0x004458d4 (code 471, tables 28, padding 0)
# sha256:       3204fcb18095ca052e6f13bea9333ca65e7e203dc343ea8bada8d3b4437881b5
# evidence:     ev_d8af1f64874eb3e8469c17e0baf09bf0097f1882284f135b85877e988363a520
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m4456e1_lifted
# naming:       native port src/original_methods_fl40.c:m4456e1_lifted (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-22); the note is the acceptance note, a statement about the native port
# name-note:    Machine-translated from the original instructions (scripts/lift_function.py); 9 seeds; oracle 104/104 instructions, 2/2 jump directions; mutation survivors: tasks/fl40-survivors.json.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       15 ebp-relative slot(s): local_4, local_9, local_a, local_c, local_10, local_14, local_18, local_1a, local_1c, local_1e, local_20, local_42 and 3 more
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050cd50, FUN_0043f210, FUN_0041fd08
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl40.c:m4456e1_lifted (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 104 instruction(s), 1 conditional branch(es) and 1 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_9, 0x9  # offset -0x9
.equ local_a, 0xa  # offset -0xa
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18
.equ local_1a, 0x1a  # offset -0x1a
.equ local_1c, 0x1c  # offset -0x1c
.equ local_1e, 0x1e  # offset -0x1e
.equ local_20, 0x20  # offset -0x20
.equ local_42, 0x42  # offset -0x42
.equ local_1d2, 0x1d2  # offset -0x1d2
.equ local_1d8, 0x1d8  # offset -0x1d8
.equ local_1dc, 0x1dc  # offset -0x1dc

# --- external targets -----------------------------------------------
.set FUN_0041fd08, .text + (0x0041fd08 - 0x401000)
.set FUN_0043f210, .text + (0x0043f210 - 0x401000)
.set FUN_0050cd50, .text + (0x0050cd50 - 0x401000)

.org 0x004456e1 - 0x401000
.globl FUN_004456e1
FUN_004456e1:
    # block 0x004456e1: entry, 38 instruction(s), calls FUN_0050cd50, FUN_0043f210, ends with ja to 0x004458a1 (forward)
    push ebp                                     # 004456e1
    {load} mov ebp, esp                          # 004456e2
    sub esp, 0x1dc                               # 004456e4
    push esi                                     # 004456ea
    push edi                                     # 004456eb
    call FUN_0050cd50                            # 004456ec
    cdq                                          # 004456f1
    mov ecx, 0x7                                 # 004456f2
    idiv ecx                                     # 004456f7
    mov word ptr [ebp - local_4], dx             # 004456f9
    push 0x5481c8                                # 004456fd
    push 0x63a830                                # 00445702
    lea edx, [ebp - local_1d2]                   # 00445707
    push edx                                     # 0044570d
    call FUN_0043f210                            # 0044570e
    add esp, 0xc                                 # 00445713
    mov edi, 0x5481d0                            # 00445716
    lea edx, [ebp - local_42]                    # 0044571b
    or ecx, -0x1                                 # 0044571e
    {load} xor eax, eax                          # 00445721
    repne scasb al, byte ptr es:[edi]            # 00445723
    not ecx                                      # 00445725
    {load} sub edi, ecx                          # 00445727
    {load} mov esi, edi                          # 00445729
    {load} mov eax, ecx                          # 0044572b
    {load} mov edi, edx                          # 0044572d
    shr ecx, 0x2                                 # 0044572f
    rep movsd dword ptr es:[edi], dword ptr [esi] # 00445732
    {load} mov ecx, eax                          # 00445734
    and ecx, 0x3                                 # 00445736
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 00445739
    mov dword ptr [ebp - local_18], 0x0          # 0044573b
    mov dword ptr [ebp - local_14], 0x0          # 00445742
    mov dword ptr [ebp - local_10], 0x1          # 00445749
    movsx ecx, word ptr [ebp - local_4]          # 00445750
    mov dword ptr [ebp - local_1dc], ecx         # 00445754
    cmp dword ptr [ebp - local_1dc], 0x6         # 0044575a
    ja.d32 L_004458a1                            # 00445761
    # block 0x00445767: entered by fall-through of ja at 0x00445761, 2 instruction(s), ends with indirect jump dword ptr [4*edx + 0x4458b8]
    mov edx, dword ptr [ebp - local_1dc]         # 00445767
    jmp dword ptr [4*edx + SWTAB_004458b8_VA]    # 0044576d
L_00445774:
    # block 0x00445774: entered by switch case, 8 instruction(s), ends with forward jump to 0x004458a1
    mov word ptr [ebp - local_20], 0x636         # 00445774
    mov word ptr [ebp - local_1e], 0x0           # 0044577a
    mov word ptr [ebp - local_1c], 0x0           # 00445780
    mov word ptr [ebp - local_1a], 0x1           # 00445786
    mov word ptr [ebp - local_c], 0xffff         # 0044578c
    mov byte ptr [ebp - local_a], 0x0            # 00445792
    mov word ptr [ebp - local_9], 0x2            # 00445796
    jmp.d32 L_004458a1                           # 0044579c
L_004457a1:
    # block 0x004457a1: entered by switch case, 8 instruction(s), ends with forward jump to 0x004458a1
    mov word ptr [ebp - local_20], 0x637         # 004457a1
    mov word ptr [ebp - local_1e], 0x0           # 004457a7
    mov word ptr [ebp - local_1c], 0x0           # 004457ad
    mov word ptr [ebp - local_1a], 0x1           # 004457b3
    mov word ptr [ebp - local_c], 0xffff         # 004457b9
    mov byte ptr [ebp - local_a], 0x0            # 004457bf
    mov word ptr [ebp - local_9], 0x2            # 004457c3
    jmp.d32 L_004458a1                           # 004457c9
L_004457ce:
    # block 0x004457ce: entered by switch case, 8 instruction(s), ends with forward jump to 0x004458a1
    mov word ptr [ebp - local_20], 0x638         # 004457ce
    mov word ptr [ebp - local_1e], 0x0           # 004457d4
    mov word ptr [ebp - local_1c], 0x0           # 004457da
    mov word ptr [ebp - local_1a], 0x1           # 004457e0
    mov word ptr [ebp - local_c], 0xffff         # 004457e6
    mov byte ptr [ebp - local_a], 0x0            # 004457ec
    mov word ptr [ebp - local_9], 0x2            # 004457f0
    jmp.d32 L_004458a1                           # 004457f6
L_004457fb:
    # block 0x004457fb: entered by switch case, 8 instruction(s), ends with forward jump to 0x004458a1
    mov word ptr [ebp - local_20], 0x639         # 004457fb
    mov word ptr [ebp - local_1e], 0x0           # 00445801
    mov word ptr [ebp - local_1c], 0x0           # 00445807
    mov word ptr [ebp - local_1a], 0x1           # 0044580d
    mov word ptr [ebp - local_c], 0xffff         # 00445813
    mov byte ptr [ebp - local_a], 0x0            # 00445819
    mov word ptr [ebp - local_9], 0x2            # 0044581d
    jmp.d8 L_004458a1                            # 00445823
L_00445825:
    # block 0x00445825: entered by switch case, 8 instruction(s), ends with forward jump to 0x004458a1
    mov word ptr [ebp - local_20], 0x63a         # 00445825
    mov word ptr [ebp - local_1e], 0x0           # 0044582b
    mov word ptr [ebp - local_1c], 0x0           # 00445831
    mov word ptr [ebp - local_1a], 0x1           # 00445837
    mov word ptr [ebp - local_c], 0xffff         # 0044583d
    mov byte ptr [ebp - local_a], 0x0            # 00445843
    mov word ptr [ebp - local_9], 0x2            # 00445847
    jmp.d8 L_004458a1                            # 0044584d
L_0044584f:
    # block 0x0044584f: entered by switch case, 8 instruction(s), ends with forward jump to 0x004458a1
    mov word ptr [ebp - local_20], 0x63b         # 0044584f
    mov word ptr [ebp - local_1e], 0x0           # 00445855
    mov word ptr [ebp - local_1c], 0x0           # 0044585b
    mov word ptr [ebp - local_1a], 0x1           # 00445861
    mov word ptr [ebp - local_c], 0xffff         # 00445867
    mov byte ptr [ebp - local_a], 0x0            # 0044586d
    mov word ptr [ebp - local_9], 0x2            # 00445871
    jmp.d8 L_004458a1                            # 00445877
L_00445879:
    # block 0x00445879: entered by switch case, 7 instruction(s), falls into the block at 0x004458a1
    mov word ptr [ebp - local_20], 0x63c         # 00445879
    mov word ptr [ebp - local_1e], 0x0           # 0044587f
    mov word ptr [ebp - local_1c], 0x0           # 00445885
    mov word ptr [ebp - local_1a], 0x1           # 0044588b
    mov word ptr [ebp - local_c], 0xffff         # 00445891
    mov byte ptr [ebp - local_a], 0x0            # 00445897
    mov word ptr [ebp - local_9], 0x2            # 0044589b
L_004458a1:
    # block 0x004458a1: entered by ja at 0x00445761; jmp at 0x0044579c; jmp at 0x004457c9; jmp at 0x004457f6; more, 9 instruction(s), calls FUN_0041fd08, ends with ret
    lea eax, [ebp - local_1d8]                   # 004458a1
    push eax                                     # 004458a7
    mov ecx, 0x6177e8                            # 004458a8
    call FUN_0041fd08                            # 004458ad
    pop edi                                      # 004458b2
    pop esi                                      # 004458b3
    {load} mov esp, ebp                          # 004458b4
    pop ebp                                      # 004458b6
    ret                                          # 004458b7

# --- data items (not part of the function) -------------------------
.org 0x004458b8 - 0x401000
SWTAB_004458b8:  # 7 case address(es)
    .long L_00445774 - .text + 0x401000
    .long L_004457a1 - .text + 0x401000
    .long L_004457ce - .text + 0x401000
    .long L_004457fb - .text + 0x401000
    .long L_00445825 - .text + 0x401000
    .long L_0044584f - .text + 0x401000
    .long L_00445879 - .text + 0x401000
.set SWTAB_004458b8_VA, SWTAB_004458b8 - .text + 0x401000

