# FUN_004e1c50
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004e1c50
# extent:       0x004e1c50-0x004e1c83 (51 code bytes)
# span:         0x004e1c50-0x004e1c83 (code 51, tables 0, padding 0)
# sha256:       d97d9a2371b0bf6af6abf89ce8815e704493fae62e2d1f252294f2b8a684ade1
# evidence:     ev_8385f85130572c281c3b234a54cbdfd62040e051350169a9d81ca47906b8da6a
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_004e1c50
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004e1c9f
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 21 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4

# --- external targets -----------------------------------------------
.set FUN_004e1c9f, .text + (0x004e1c9f - 0x401000)

.org 0x004e1c50 - 0x401000
.globl FUN_004e1c50
FUN_004e1c50:
    # block 0x004e1c50: entry, 21 instruction(s), calls FUN_004e1c9f, ends with ret
    push ebp                                     # 004e1c50
    {load} mov ebp, esp                          # 004e1c51
    push ecx                                     # 004e1c53
    push edi                                     # 004e1c54
    mov dword ptr [ebp - local_4], ecx           # 004e1c55
    mov eax, dword ptr [ebp - local_4]           # 004e1c58
    mov dword ptr [eax], 0x52e4e8                # 004e1c5b
    mov ecx, 0x3b                                # 004e1c61
    {load} xor eax, eax                          # 004e1c66
    mov edi, dword ptr [ebp - local_4]           # 004e1c68
    add edi, 0x38                                # 004e1c6b
    rep stosd dword ptr es:[edi], eax            # 004e1c6e
    stosw word ptr es:[edi], ax                  # 004e1c70
    stosb byte ptr es:[edi], al                  # 004e1c72
    mov ecx, dword ptr [ebp - local_4]           # 004e1c73
    call FUN_004e1c9f                            # 004e1c76
    mov eax, dword ptr [ebp - local_4]           # 004e1c7b
    pop edi                                      # 004e1c7e
    {load} mov esp, ebp                          # 004e1c7f
    pop ebp                                      # 004e1c81
    ret                                          # 004e1c82

