# FUN_004046ea
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004046ea
# extent:       0x004046ea-0x0040478e (164 code bytes)
# span:         0x004046ea-0x0040478e (code 164, tables 0, padding 0)
# sha256:       45e868a0131d3658c2ce3941bfc9f6f93409301a5445bc7430fd5a030860f9ab
# evidence:     ev_51b415fb048676855f87480857f7034bf358ef4aa71116bcd269a8a5b14202e2
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004046ea
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       2 ebp-relative slot(s): local_14, local_18
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_0051d5b2, FUN_0050cb1b, FUN_004033db
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 39 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_14, 0x14  # offset -0x14
.equ local_18, 0x18  # offset -0x18

# --- external targets -----------------------------------------------
.set FUN_004033db, .text + (0x004033db - 0x401000)
.set FUN_0050cb1b, .text + (0x0050cb1b - 0x401000)
.set FUN_0051d5b2, .text + (0x0051d5b2 - 0x401000)

.org 0x004046ea - 0x401000
.globl FUN_004046ea
FUN_004046ea:
    # block 0x004046ea: entry, 39 instruction(s), calls FUN_0051d5b2, FUN_0050cb1b, FUN_004033db, ends with ret
    push ebp                                     # 004046ea
    {load} mov ebp, esp                          # 004046eb
    sub esp, 0x18                                # 004046ed
    mov dword ptr [ebp - local_18], ecx          # 004046f0
    push 0x13                                    # 004046f3
    lea eax, [ebp - local_14]                    # 004046f5
    push eax                                     # 004046f8
    mov ecx, dword ptr [ebp - local_18]          # 004046f9
    add ecx, 0x34c                               # 004046fc
    call FUN_0051d5b2                            # 00404702
    lea ecx, [ebp - local_14]                    # 00404707
    push ecx                                     # 0040470a
    call FUN_0050cb1b                            # 0040470b
    add esp, 0x4                                 # 00404710
    mov edx, dword ptr [0x5c3a63]                # 00404713
    imul edx, edx, 0x106                         # 00404719
    mov dword ptr [edx + 0x5e56b6], eax          # 0040471f
    mov eax, dword ptr [0x5c3a63]                # 00404725
    imul eax, eax, 0x106                         # 0040472a
    mov ecx, dword ptr [eax + 0x5e56be]          # 00404730
    imul ecx, ecx, 0x36ee80                      # 00404736
    mov edx, dword ptr [0x5c3a63]                # 0040473c
    imul edx, edx, 0x106                         # 00404742
    mov eax, dword ptr [edx + 0x5e56ba]          # 00404748
    imul eax, eax, 0xea60                        # 0040474e
    {load} add ecx, eax                          # 00404754
    mov edx, dword ptr [0x5c3a63]                # 00404756
    imul edx, edx, 0x106                         # 0040475c
    mov eax, dword ptr [edx + 0x5e56b6]          # 00404762
    imul eax, eax, 0x3e8                         # 00404768
    {load} add ecx, eax                          # 0040476e
    mov edx, dword ptr [0x5c3a63]                # 00404770
    imul edx, edx, 0x106                         # 00404776
    mov dword ptr [edx + 0x5e56b2], ecx          # 0040477c
    mov ecx, dword ptr [ebp - local_18]          # 00404782
    call FUN_004033db                            # 00404785
    {load} mov esp, ebp                          # 0040478a
    pop ebp                                      # 0040478c
    ret                                          # 0040478d

