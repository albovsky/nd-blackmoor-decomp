# FUN_004cecf7
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004cecf7
# extent:       0x004cecf7-0x004ced84 (141 code bytes)
# span:         0x004cecf7-0x004ced84 (code 141, tables 0, padding 0)
# sha256:       b2b82d05059a88e23039b767feeeba68b8bf8152bc7cab071edccbc0a9adf967
# evidence:     ev_7011e58f3afdde6fc878edb0312973c24208872876d4104777064ce751b49e1e
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004cecf7
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      none: no call or outward jump
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 38 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses; function ledger class static_navigation_only is a native-touch record, not a counterpart claim
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------

.org 0x004cecf7 - 0x401000
.globl FUN_004cecf7
FUN_004cecf7:
    # block 0x004cecf7: entry, 38 instruction(s), ends with ret
    push ebp                                     # 004cecf7
    {load} mov ebp, esp                          # 004cecf8
    push ecx                                     # 004cecfa
    push esi                                     # 004cecfb
    push edi                                     # 004cecfc
    mov dword ptr [ebp - local_4], ecx           # 004cecfd
    mov dword ptr [0x5d1a31], 0xb                # 004ced00
    mov dword ptr [0x5d1a35], 0x4cf749           # 004ced0a
    mov dword ptr [0x5d1a39], 0x0                # 004ced14
    mov eax, dword ptr [ebp - local_4]           # 004ced1e
    add eax, 0x1e2                               # 004ced21
    mov dword ptr [0x5d1a3d], eax                # 004ced26
    mov ecx, dword ptr [ebp - local_4]           # 004ced2b
    add ecx, 0x1f2                               # 004ced2e
    mov dword ptr [0x5d1a41], ecx                # 004ced34
    mov dword ptr [0x5d1a45], 0x0                # 004ced3a
    mov dword ptr [0x5d1a49], 0x1                # 004ced44
    mov word ptr [0x5d1a4d], 0x0                 # 004ced4e
    mov edi, 0x559b18                            # 004ced57
    mov edx, 0x5d1a53                            # 004ced5c
    or ecx, -0x1                                 # 004ced61
    {load} xor eax, eax                          # 004ced64
    repne scasb al, byte ptr es:[edi]            # 004ced66
    not ecx                                      # 004ced68
    {load} sub edi, ecx                          # 004ced6a
    {load} mov esi, edi                          # 004ced6c
    {load} mov eax, ecx                          # 004ced6e
    {load} mov edi, edx                          # 004ced70
    shr ecx, 0x2                                 # 004ced72
    rep movsd dword ptr es:[edi], dword ptr [esi] # 004ced75
    {load} mov ecx, eax                          # 004ced77
    and ecx, 0x3                                 # 004ced79
    rep movsb byte ptr es:[edi], byte ptr [esi]  # 004ced7c
    pop edi                                      # 004ced7e
    pop esi                                      # 004ced7f
    {load} mov esp, ebp                          # 004ced80
    pop ebp                                      # 004ced82
    ret                                          # 004ced83

