# FUN_004348b0
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004348b0
# extent:       0x004348b0-0x00434d56 (1190 code bytes)
# span:         0x004348b0-0x00434d56 (code 1190, tables 0, padding 0)
# sha256:       f8b101663d4826b2e4fc4aab4274a4840f7a9d0b885a09431d6ae315899379e0
# evidence:     ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_ini_settings_reader
# naming:       INFERRED (lower confidence, not verified): the repository text src/blackmoor_app.mm:12249 says "0x4348b0 reads [Nancy Data] ClosedCaptioning with default zero."
# name-note:    Reads settings such as the Ciftree directory and the [Nancy Data] ClosedCaptioning flag.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       11 ebp-relative slot(s): local_64, local_68, local_6c, local_70, local_74, local_78, local_7c, local_80, local_84, local_88, local_8c
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0050d0a9, FUN_0050ca3e, FUN_0052139c, FUN_0050cee4, KERNEL32.dll!GetPrivateProfileStringA, FUN_0050da60, FUN_0050d960, FUN_00434d56, FUN_0050cd72, KERNEL32.dll!GetPrivateProfileIntA
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 263 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name; function ledger class partial_native is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_64, 0x64  # offset -0x64
.equ local_68, 0x68  # offset -0x68
.equ local_6c, 0x6c  # offset -0x6c
.equ local_70, 0x70  # offset -0x70
.equ local_74, 0x74  # offset -0x74
.equ local_78, 0x78  # offset -0x78
.equ local_7c, 0x7c  # offset -0x7c
.equ local_80, 0x80  # offset -0x80
.equ local_84, 0x84  # offset -0x84
.equ local_88, 0x88  # offset -0x88
.equ local_8c, 0x8c  # offset -0x8c

# --- external targets -----------------------------------------------
.set FUN_00434d56, .text + (0x00434d56 - 0x401000)
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)
.set FUN_0050cd72, .text + (0x0050cd72 - 0x401000)
.set FUN_0050cee4, .text + (0x0050cee4 - 0x401000)
.set FUN_0050d0a9, .text + (0x0050d0a9 - 0x401000)
.set FUN_0050d960, .text + (0x0050d960 - 0x401000)
.set FUN_0050da60, .text + (0x0050da60 - 0x401000)
.set FUN_0052139c, .text + (0x0052139c - 0x401000)

.org 0x004348b0 - 0x401000
.globl FUN_004348b0
FUN_004348b0:
    # block 0x004348b0: entry, 12 instruction(s), calls FUN_0050d0a9, ends with jne to 0x00434903 (forward)
    push ebp                                     # 004348b0
    {load} mov ebp, esp                          # 004348b1
    sub esp, 0x8c                                # 004348b3
    push esi                                     # 004348b9
    push edi                                     # 004348ba
    push 0x545f28                                # 004348bb
    push 0x639897                                # 004348c0
    call FUN_0050d0a9                            # 004348c5
    add esp, 0x8                                 # 004348ca
    mov dword ptr [ebp - local_68], eax          # 004348cd
    cmp dword ptr [ebp - local_68], 0x0          # 004348d0
    jne.d8 L_00434903                            # 004348d4
    # block 0x004348d6: entered by fall-through of jne at 0x004348d4, 11 instruction(s), calls FUN_0050ca3e, FUN_0052139c, ends with forward jump to 0x00434d50
    push 0x639897                                # 004348d6
    push 0x545f2c                                # 004348db
    push 0x63888b                                # 004348e0
    call FUN_0050ca3e                            # 004348e5
    add esp, 0xc                                 # 004348ea
    push 0x0                                     # 004348ed
    push 0x0                                     # 004348ef
    push 0x63888b                                # 004348f1
    call FUN_0052139c                            # 004348f6
    {load} xor ax, ax                            # 004348fb
    jmp.d32 L_00434d50                           # 004348fe
L_00434903:
    # block 0x00434903: entered by jne at 0x004348d4, 18 instruction(s), calls FUN_0050cee4, KERNEL32.dll!GetPrivateProfileStringA, FUN_0050da60, ends with jne to 0x00434965 (forward)
    mov eax, dword ptr [ebp - local_68]          # 00434903
    push eax                                     # 00434906
    call FUN_0050cee4                            # 00434907
    add esp, 0x4                                 # 0043490c
    push 0x639897                                # 0043490f
    push 0x104                                   # 00434914
    push 0x63a2c5                                # 00434919
    push 0x545f54                                # 0043491e
    push 0x545f64                                # 00434923
    push 0x545f6c                                # 00434928
    call dword ptr [0x52a298]                    # 0043492d
    push 0x104                                   # 00434933
    push 0x545f78                                # 00434938
    push 0x63a2c5                                # 0043493d
    call FUN_0050da60                            # 00434942
    add esp, 0xc                                 # 00434947
    test eax, eax                                # 0043494a
    jne.d8 L_00434965                            # 0043494c
    # block 0x0043494e: entered by fall-through of jne at 0x0043494c, 5 instruction(s), calls FUN_0050d960, falls into the block at 0x00434965
    push 0x104                                   # 0043494e
    push 0x639aa2                                # 00434953
    push 0x63a2c5                                # 00434958
    call FUN_0050d960                            # 0043495d
    add esp, 0xc                                 # 00434962
L_00434965:
    # block 0x00434965: entered by jne at 0x0043494c, 36 instruction(s), calls FUN_00434d56, ends with jne to 0x00434a43 (forward)
    push 0x104                                   # 00434965
    push 0x639db1                                # 0043496a
    push 0x545f88                                # 0043496f
    push 0x545f94                                # 00434974
    call FUN_00434d56                            # 00434979
    add esp, 0x10                                # 0043497e
    push 0x104                                   # 00434981
    push 0x639eb5                                # 00434986
    push 0x545fa0                                # 0043498b
    push 0x545fac                                # 00434990
    call FUN_00434d56                            # 00434995
    add esp, 0x10                                # 0043499a
    push 0x104                                   # 0043499d
    push 0x639fb9                                # 004349a2
    push 0x545fb8                                # 004349a7
    push 0x545fc4                                # 004349ac
    call FUN_00434d56                            # 004349b1
    add esp, 0x10                                # 004349b6
    push 0x104                                   # 004349b9
    push 0x63a0bd                                # 004349be
    push 0x545fd0                                # 004349c3
    push 0x545fdc                                # 004349c8
    call FUN_00434d56                            # 004349cd
    add esp, 0x10                                # 004349d2
    push 0x104                                   # 004349d5
    push 0x63a1c1                                # 004349da
    push 0x545fe8                                # 004349df
    push 0x545ff4                                # 004349e4
    call FUN_00434d56                            # 004349e9
    add esp, 0x10                                # 004349ee
    mov edi, 0x63a59c                            # 004349f1
    mov esi, 0x63a3c9                            # 004349f6
    mov ecx, 0x1                                 # 004349fb
    {load} xor edx, edx                          # 00434a00
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00434a02
    jne.d8 L_00434a43                            # 00434a04
    # block 0x00434a06: entered by fall-through of jne at 0x00434a04, 13 instruction(s), calls FUN_00434d56, FUN_0050cd72, falls into the block at 0x00434a43
    push 0x104                                   # 00434a06
    push 0x63a3c9                                # 00434a0b
    push 0x546000                                # 00434a10
    push 0x546008                                # 00434a15
    call FUN_00434d56                            # 00434a1a
    add esp, 0x10                                # 00434a1f
    push 0x63a5a0                                # 00434a22
    push 0x63a5a4                                # 00434a27
    push 0x63a3c9                                # 00434a2c
    push 0x639dae                                # 00434a31
    push 0x63a3c9                                # 00434a36
    call FUN_0050cd72                            # 00434a3b
    add esp, 0x14                                # 00434a40
L_00434a43:
    # block 0x00434a43: entered by jne at 0x00434a04, 14 instruction(s), calls KERNEL32.dll!GetPrivateProfileStringA, ends with jne to 0x00434a81 (forward)
    push 0x639897                                # 00434a43
    push 0x64                                    # 00434a48
    lea eax, [ebp - local_64]                    # 00434a4a
    push eax                                     # 00434a4d
    push 0x546018                                # 00434a4e
    push 0x54602c                                # 00434a53
    push 0x546040                                # 00434a58
    call dword ptr [0x52a298]                    # 00434a5d
    mov edi, 0x54604c                            # 00434a63
    lea esi, [ebp - local_64]                    # 00434a68
    mov ecx, 0xc                                 # 00434a6b
    {load} xor edx, edx                          # 00434a70
    rep cmpsb byte ptr [esi], byte ptr es:[edi]  # 00434a72
    jne.d8 L_00434a81                            # 00434a74
    # block 0x00434a76: entered by fall-through of jne at 0x00434a74, 2 instruction(s), ends with forward jump to 0x00434a8a
    mov word ptr [0x5bb218], 0x1                 # 00434a76
    jmp.d8 L_00434a8a                            # 00434a7f
L_00434a81:
    # block 0x00434a81: entered by jne at 0x00434a74, 1 instruction(s), falls into the block at 0x00434a8a
    mov word ptr [0x5bb218], 0x0                 # 00434a81
L_00434a8a:
    # block 0x00434a8a: entered by jmp at 0x00434a7f, 68 instruction(s), calls KERNEL32.dll!GetPrivateProfileIntA, ends with je to 0x00434bdd (forward)
    push 0x639897                                # 00434a8a
    push 0x0                                     # 00434a8f
    push 0x546058                                # 00434a91
    push 0x546064                                # 00434a96
    call dword ptr [0x52a29c]                    # 00434a9b
    mov word ptr [0x63a4cd], ax                  # 00434aa1
    push 0x639897                                # 00434aa7
    push 0x0                                     # 00434aac
    push 0x546070                                # 00434aae
    push 0x546088                                # 00434ab3
    call dword ptr [0x52a29c]                    # 00434ab8
    mov word ptr [0x63a4cf], ax                  # 00434abe
    push 0x639897                                # 00434ac4
    push 0x0                                     # 00434ac9
    push 0x546094                                # 00434acb
    push 0x5460a8                                # 00434ad0
    call dword ptr [0x52a29c]                    # 00434ad5
    mov dword ptr [0x5d2f05], eax                # 00434adb
    push 0x639897                                # 00434ae0
    push 0x85                                    # 00434ae5
    push 0x5460b4                                # 00434aea
    push 0x5460cc                                # 00434aef
    call dword ptr [0x52a29c]                    # 00434af4
    mov word ptr [0x5d2f0d], ax                  # 00434afa
    push 0x639897                                # 00434b00
    push 0x64                                    # 00434b05
    push 0x5460d8                                # 00434b07
    push 0x5460f0                                # 00434b0c
    call dword ptr [0x52a29c]                    # 00434b11
    mov word ptr [0x5d2f0f], ax                  # 00434b17
    push 0x639897                                # 00434b1d
    push 0x0                                     # 00434b22
    push 0x5460fc                                # 00434b24
    push 0x54611c                                # 00434b29
    call dword ptr [0x52a29c]                    # 00434b2e
    mov dword ptr [0x5d1589], eax                # 00434b34
    push 0x639897                                # 00434b39
    push 0x32                                    # 00434b3e
    push 0x546128                                # 00434b40
    push 0x54613c                                # 00434b45
    call dword ptr [0x52a29c]                    # 00434b4a
    mov dword ptr [0x5d02af], eax                # 00434b50
    push 0x639897                                # 00434b55
    push 0x96                                    # 00434b5a
    push 0x546148                                # 00434b5f
    push 0x54615c                                # 00434b64
    call dword ptr [0x52a29c]                    # 00434b69
    mov dword ptr [0x5d02b3], eax                # 00434b6f
    push 0x639897                                # 00434b74
    push 0x64                                    # 00434b79
    push 0x546168                                # 00434b7b
    push 0x546180                                # 00434b80
    call dword ptr [0x52a29c]                    # 00434b85
    mov dword ptr [0x5d02b7], eax                # 00434b8b
    push 0x639897                                # 00434b90
    push 0x64                                    # 00434b95
    push 0x54618c                                # 00434b97
    push 0x54619c                                # 00434b9c
    call dword ptr [0x52a29c]                    # 00434ba1
    mov dword ptr [0x5d02bb], eax                # 00434ba7
    push 0x639897                                # 00434bac
    push 0x0                                     # 00434bb1
    push 0x5461a8                                # 00434bb3
    push 0x5461b4                                # 00434bb8
    call dword ptr [0x52a29c]                    # 00434bbd
    mov dword ptr [0x5d02bf], eax                # 00434bc3
    cmp dword ptr [0x5d02bf], 0x0                # 00434bc8
    je.d8 L_00434bdd                             # 00434bcf
    # block 0x00434bd1: entered by fall-through of je at 0x00434bcf, 2 instruction(s), ends with forward jump to 0x00434be7
    mov dword ptr [0x5d02bf], 0x1                # 00434bd1
    jmp.d8 L_00434be7                            # 00434bdb
L_00434bdd:
    # block 0x00434bdd: entered by je at 0x00434bcf, 1 instruction(s), falls into the block at 0x00434be7
    mov dword ptr [0x5d02bf], 0x0                # 00434bdd
L_00434be7:
    # block 0x00434be7: entered by jmp at 0x00434bdb, 75 instruction(s), calls KERNEL32.dll!GetPrivateProfileIntA, falls into the block at 0x00434d50
    push 0x639897                                # 00434be7
    push 0x0                                     # 00434bec
    push 0x5461c0                                # 00434bee
    push 0x5461d8                                # 00434bf3
    call dword ptr [0x52a29c]                    # 00434bf8
    mov dword ptr [0x5bb1fe], eax                # 00434bfe
    push 0x639897                                # 00434c03
    push 0x0                                     # 00434c08
    push 0x5461e4                                # 00434c0a
    push 0x5461f8                                # 00434c0f
    call dword ptr [0x52a29c]                    # 00434c14
    mov dword ptr [0x5bb1fa], eax                # 00434c1a
    push 0x639897                                # 00434c1f
    push 0x0                                     # 00434c24
    push 0x546204                                # 00434c26
    push 0x546218                                # 00434c2b
    call dword ptr [0x52a29c]                    # 00434c30
    mov dword ptr [0x5bb202], eax                # 00434c36
    push 0x639897                                # 00434c3b
    push 0x1                                     # 00434c40
    push 0x546224                                # 00434c42
    push 0x546230                                # 00434c47
    call dword ptr [0x52a29c]                    # 00434c4c
    mov dword ptr [0x5bb206], eax                # 00434c52
    push 0x639897                                # 00434c57
    push 0x1                                     # 00434c5c
    push 0x54623c                                # 00434c5e
    push 0x54625c                                # 00434c63
    call dword ptr [0x52a29c]                    # 00434c68
    mov word ptr [0x617f6e], ax                  # 00434c6e
    push 0x639897                                # 00434c74
    push 0x32                                    # 00434c79
    push 0x546268                                # 00434c7b
    push 0x54627c                                # 00434c80
    call dword ptr [0x52a29c]                    # 00434c85
    mov dword ptr [ebp - local_70], eax          # 00434c8b
    mov dword ptr [ebp - local_6c], 0x0          # 00434c8e
    fild qword ptr [ebp - local_70]              # 00434c95
    fstp dword ptr [ebp - local_74]              # 00434c98
    fld dword ptr [ebp - local_74]               # 00434c9b
    fdiv qword ptr [0x52c680]                    # 00434c9e
    fstp dword ptr [0x5cf1cb]                    # 00434ca4
    mov eax, dword ptr [0x5cf1cb]                # 00434caa
    mov dword ptr [0x5cf1d7], eax                # 00434caf
    push 0x639897                                # 00434cb4
    push 0x32                                    # 00434cb9
    push 0x546288                                # 00434cbb
    push 0x54629c                                # 00434cc0
    call dword ptr [0x52a29c]                    # 00434cc5
    mov dword ptr [ebp - local_7c], eax          # 00434ccb
    mov dword ptr [ebp - local_78], 0x0          # 00434cce
    fild qword ptr [ebp - local_7c]              # 00434cd5
    fstp dword ptr [ebp - local_80]              # 00434cd8
    fld dword ptr [ebp - local_80]               # 00434cdb
    fdiv qword ptr [0x52c680]                    # 00434cde
    fstp dword ptr [0x5cf1cf]                    # 00434ce4
    push 0x639897                                # 00434cea
    push 0x32                                    # 00434cef
    push 0x5462a8                                # 00434cf1
    push 0x5462c4                                # 00434cf6
    call dword ptr [0x52a29c]                    # 00434cfb
    mov dword ptr [ebp - local_88], eax          # 00434d01
    mov dword ptr [ebp - local_84], 0x0          # 00434d07
    fild qword ptr [ebp - local_88]              # 00434d11
    fstp dword ptr [ebp - local_8c]              # 00434d17
    fld dword ptr [ebp - local_8c]               # 00434d1d
    fdiv qword ptr [0x52c680]                    # 00434d23
    fstp dword ptr [0x5cf1d3]                    # 00434d29
    push 0x639897                                # 00434d2f
    push 0x0                                     # 00434d34
    push 0x5462d0                                # 00434d36
    push 0x5462f0                                # 00434d3b
    call dword ptr [0x52a29c]                    # 00434d40
    mov word ptr [0x5cf1e9], ax                  # 00434d46
    mov ax, 0x1                                  # 00434d4c
L_00434d50:
    # block 0x00434d50: entered by jmp at 0x004348fe, 5 instruction(s), ends with ret
    pop edi                                      # 00434d50
    pop esi                                      # 00434d51
    {load} mov esp, ebp                          # 00434d52
    pop ebp                                      # 00434d54
    ret                                          # 00434d55

