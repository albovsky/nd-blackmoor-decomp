# FUN_00502910
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x00502910
# extent:       0x00502910-0x00502970 (96 code bytes)
# span:         0x00502910-0x00502970 (code 96, tables 0, padding 0)
# sha256:       e6b5f60fcbc568255999e8897b73784f0245b1a9e1471748a844aed888a8a709
# evidence:     ev_20c7c52bf11d994d9023881598efe05eb08f3d2ab61411fd9b04f8b74b2165a9
# region:       vorbis
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_00502910
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [edi + n] field_10, field_14, field_18, field_1c, field_20; [esp + n] stk_8
# callees:      calls FUN_0050e936
# track-n:      outputs/blackmoor-decomp/src/his_audio.c:his_audio_decode_memory (function ledger class host_adapter_tested; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 37 instruction(s), 5 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ stk_8, 0x8  # offset +0x8
.equ field_10, 0x10  # offset +0x10
.equ field_14, 0x14  # offset +0x14
.equ field_18, 0x18  # offset +0x18
.equ field_1c, 0x1c  # offset +0x1c
.equ field_20, 0x20  # offset +0x20

# --- external targets -----------------------------------------------
.set FUN_0050e936, .text + (0x0050e936 - 0x401000)

.org 0x00502910 - 0x401000
.globl FUN_00502910
FUN_00502910:
    # block 0x00502910: entry, 5 instruction(s), ends with je to 0x00502925 (forward)
    push edi                                     # 00502910
    mov edi, dword ptr [esp + stk_8]             # 00502911
    mov eax, dword ptr [edi + field_10]          # 00502915
    test eax, eax                                # 00502918
    je.d8 L_00502925                             # 0050291a
    # block 0x0050291c: entered by fall-through of je at 0x0050291a, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x00502925
    push eax                                     # 0050291c
    call FUN_0050e936                            # 0050291d
    add esp, 0x4                                 # 00502922
L_00502925:
    # block 0x00502925: entered by je at 0x0050291a, 3 instruction(s), ends with je to 0x00502935 (forward)
    mov eax, dword ptr [edi + field_14]          # 00502925
    test eax, eax                                # 00502928
    je.d8 L_00502935                             # 0050292a
    # block 0x0050292c: entered by fall-through of je at 0x0050292a, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x00502935
    push eax                                     # 0050292c
    call FUN_0050e936                            # 0050292d
    add esp, 0x4                                 # 00502932
L_00502935:
    # block 0x00502935: entered by je at 0x0050292a, 3 instruction(s), ends with je to 0x00502945 (forward)
    mov eax, dword ptr [edi + field_18]          # 00502935
    test eax, eax                                # 00502938
    je.d8 L_00502945                             # 0050293a
    # block 0x0050293c: entered by fall-through of je at 0x0050293a, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x00502945
    push eax                                     # 0050293c
    call FUN_0050e936                            # 0050293d
    add esp, 0x4                                 # 00502942
L_00502945:
    # block 0x00502945: entered by je at 0x0050293a, 3 instruction(s), ends with je to 0x00502955 (forward)
    mov eax, dword ptr [edi + field_1c]          # 00502945
    test eax, eax                                # 00502948
    je.d8 L_00502955                             # 0050294a
    # block 0x0050294c: entered by fall-through of je at 0x0050294a, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x00502955
    push eax                                     # 0050294c
    call FUN_0050e936                            # 0050294d
    add esp, 0x4                                 # 00502952
L_00502955:
    # block 0x00502955: entered by je at 0x0050294a, 3 instruction(s), ends with je to 0x00502965 (forward)
    mov eax, dword ptr [edi + field_20]          # 00502955
    test eax, eax                                # 00502958
    je.d8 L_00502965                             # 0050295a
    # block 0x0050295c: entered by fall-through of je at 0x0050295a, 3 instruction(s), calls FUN_0050e936, falls into the block at 0x00502965
    push eax                                     # 0050295c
    call FUN_0050e936                            # 0050295d
    add esp, 0x4                                 # 00502962
L_00502965:
    # block 0x00502965: entered by je at 0x0050295a, 5 instruction(s), ends with ret
    mov ecx, 0xb                                 # 00502965
    {load} xor eax, eax                          # 0050296a
    rep stosd dword ptr es:[edi], eax            # 0050296c
    pop edi                                      # 0050296e
    ret                                          # 0050296f

