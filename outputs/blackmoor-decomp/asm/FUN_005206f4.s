# FUN_005206f4
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x005206f4
# extent:       0x005206f4-0x005207c4 (208 code bytes)
# span:         0x005206f4-0x005207c4 (code 208, tables 0, padding 0)
# sha256:       3f962ae734aeee464e1a4b977b576399c0688a6de313bb6cf96433abaa780f8f
# evidence:     ev_4885e6fea92dac09228c0a462164bd336a5e033477c51bac06a0c68b22eedb5b
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_005206f4
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; ret 0x8 (callee pops 8 bytes); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [ebp + n] field_8, field_c, field_minus_4, field_minus_c, field_minus_10, field_minus_14, field_minus_18, field_minus_12c, field_minus_158
# callees:      calls FUN_0050f978, KERNEL32.dll!GetFullPathNameA, KERNEL32.dll!lstrcpynA, FUN_005207c4, KERNEL32.dll!GetVolumeInformationA, USER32.dll!CharUpperA, KERNEL32.dll!FindFirstFileA, KERNEL32.dll!FindClose, KERNEL32.dll!lstrcpyA, FUN_0051e7ba
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 72 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_minus_4, 0x4  # offset -0x4
.equ field_minus_c, 0xc  # offset -0xc
.equ field_minus_10, 0x10  # offset -0x10
.equ field_minus_14, 0x14  # offset -0x14
.equ field_minus_18, 0x18  # offset -0x18
.equ field_minus_12c, 0x12c  # offset -0x12c
.equ field_minus_158, 0x158  # offset -0x158
.equ field_8, 0x8  # offset +0x8
.equ field_c, 0xc  # offset +0xc

# --- external targets -----------------------------------------------
.set FUN_0050f978, .text + (0x0050f978 - 0x401000)
.set FUN_0051e7ba, .text + (0x0051e7ba - 0x401000)
.set FUN_005207c4, .text + (0x005207c4 - 0x401000)

.org 0x005206f4 - 0x401000
.globl FUN_005206f4
FUN_005206f4:
    # block 0x005206f4: entry, 15 instruction(s), calls FUN_0050f978, KERNEL32.dll!GetFullPathNameA, ends with jne to 0x00520733 (forward)
    mov eax, 0x529250                            # 005206f4
    call FUN_0050f978                            # 005206f9
    sub esp, 0x14c                               # 005206fe
    push esi                                     # 00520704
    push edi                                     # 00520705
    mov edi, dword ptr [ebp + field_8]           # 00520706
    lea eax, [ebp - field_minus_14]              # 00520709
    push eax                                     # 0052070c
    mov esi, 0x104                               # 0052070d
    push edi                                     # 00520712
    push esi                                     # 00520713
    push dword ptr [ebp + field_c]               # 00520714
    call dword ptr [0x52a11c]                    # 00520717
    test eax, eax                                # 0052071d
    jne.d8 L_00520733                            # 0052071f
    # block 0x00520721: entered by fall-through of jne at 0x0052071f, 6 instruction(s), calls KERNEL32.dll!lstrcpynA, ends with forward jump to 0x005207b4
    push esi                                     # 00520721
    push dword ptr [ebp + field_c]               # 00520722
    push edi                                     # 00520725
    call dword ptr [0x52a1d4]                    # 00520726
    {load} xor eax, eax                          # 0052072c
    jmp.d32 L_005207b4                           # 0052072e
L_00520733:
    # block 0x00520733: entered by jne at 0x0052071f, 21 instruction(s), calls FUN_005207c4, KERNEL32.dll!GetVolumeInformationA, ends with je to 0x005207a6 (forward)
    mov eax, dword ptr [0x5679b0]                # 00520733
    mov dword ptr [ebp + field_8], eax           # 00520738
    lea eax, [ebp + field_8]                     # 0052073b
    {load} xor esi, esi                          # 0052073e
    push eax                                     # 00520740
    push edi                                     # 00520741
    mov dword ptr [ebp - field_minus_4], esi     # 00520742
    call FUN_005207c4                            # 00520745
    push esi                                     # 0052074a
    lea eax, [ebp - field_minus_10]              # 0052074b
    push esi                                     # 0052074e
    push eax                                     # 0052074f
    lea eax, [ebp - field_minus_18]              # 00520750
    push eax                                     # 00520753
    push esi                                     # 00520754
    push esi                                     # 00520755
    push esi                                     # 00520756
    push dword ptr [ebp + field_8]               # 00520757
    call dword ptr [0x52a118]                    # 0052075a
    test eax, eax                                # 00520760
    je.d8 L_005207a6                             # 00520762
    # block 0x00520764: entered by fall-through of je at 0x00520762, 2 instruction(s), ends with jne to 0x00520771 (forward)
    test byte ptr [ebp - field_minus_10], 0x2    # 00520764
    jne.d8 L_00520771                            # 00520768
    # block 0x0052076a: entered by fall-through of jne at 0x00520768, 2 instruction(s), calls USER32.dll!CharUpperA, falls into the block at 0x00520771
    push edi                                     # 0052076a
    call dword ptr [0x52a3d0]                    # 0052076b
L_00520771:
    # block 0x00520771: entered by jne at 0x00520768, 2 instruction(s), ends with jne to 0x005207a3 (forward)
    test byte ptr [ebp - field_minus_10], 0x4    # 00520771
    jne.d8 L_005207a3                            # 00520775
    # block 0x00520777: entered by fall-through of jne at 0x00520775, 6 instruction(s), calls KERNEL32.dll!FindFirstFileA, ends with je to 0x005207a3 (forward)
    lea eax, [ebp - field_minus_158]             # 00520777
    push eax                                     # 0052077d
    push dword ptr [ebp + field_c]               # 0052077e
    call dword ptr [0x52a114]                    # 00520781
    cmp eax, -0x1                                # 00520787
    je.d8 L_005207a3                             # 0052078a
    # block 0x0052078c: entered by fall-through of je at 0x0052078a, 6 instruction(s), calls KERNEL32.dll!FindClose, KERNEL32.dll!lstrcpyA, falls into the block at 0x005207a3
    push eax                                     # 0052078c
    call dword ptr [0x52a110]                    # 0052078d
    lea eax, [ebp - field_minus_12c]             # 00520793
    push eax                                     # 00520799
    push dword ptr [ebp - field_minus_14]        # 0052079a
    call dword ptr [0x52a244]                    # 0052079d
L_005207a3:
    # block 0x005207a3: entered by jne at 0x00520775; je at 0x0052078a, 2 instruction(s), falls into the block at 0x005207a6
    push 0x1                                     # 005207a3
    pop esi                                      # 005207a5
L_005207a6:
    # block 0x005207a6: entered by je at 0x00520762, 4 instruction(s), calls FUN_0051e7ba, falls into the block at 0x005207b4
    or dword ptr [ebp - field_minus_4], -0x1     # 005207a6
    lea ecx, [ebp + field_8]                     # 005207aa
    call FUN_0051e7ba                            # 005207ad
    {load} mov eax, esi                          # 005207b2
L_005207b4:
    # block 0x005207b4: entered by jmp at 0x0052072e, 6 instruction(s), ends with ret 0x8
    mov ecx, dword ptr [ebp - field_minus_c]     # 005207b4
    pop edi                                      # 005207b7
    pop esi                                      # 005207b8
    mov dword ptr fs:[0x0], ecx                  # 005207b9
    leave                                        # 005207c0
    ret 0x8                                      # 005207c1

