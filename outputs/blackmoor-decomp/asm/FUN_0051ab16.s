# FUN_0051ab16
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0051ab16
# extent:       0x0051ab16-0x0051ab4b (53 code bytes)
# span:         0x0051ab16-0x0051ab4b (code 53, tables 0, padding 0)
# sha256:       dfe0cb77ad098f790cc3a8926b4518f19146b130851b391dcd4478a68569244a
# evidence:     ev_af67c4288d6e639a00bd5dfa5ba373e106c1ca511fa16fda1eb070cac94bb18e
# region:       crt_mfc
# frame:        none
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         fn_0051ab16
# arguments:    no ebp frame so stack arguments are esp-relative and are not resolved by this machine pass; plain ret (caller pops any stack arguments); ecx is not read by this function's own entry-block instructions before being written (a callee may still read it)
# locals:       none resolved: no ebp frame so slots are listed under fields as esp-relative stk symbols
# fields:       [esi + n] field_34, field_44, field_48, field_4c
# callees:      calls FUN_00525b0f, USER32.dll!GetMessageTime, USER32.dll!GetMessagePos
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 16 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; names are generated from offsets and addresses
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ field_34, 0x34  # offset +0x34
.equ field_44, 0x44  # offset +0x44
.equ field_48, 0x48  # offset +0x48
.equ field_4c, 0x4c  # offset +0x4c

# --- external targets -----------------------------------------------
.set FUN_00525b0f, .text + (0x00525b0f - 0x401000)

.org 0x0051ab16 - 0x401000
.globl FUN_0051ab16
FUN_0051ab16:
    # block 0x0051ab16: entry, 16 instruction(s), calls FUN_00525b0f, USER32.dll!GetMessageTime, USER32.dll!GetMessagePos, ends with ret
    push esi                                     # 0051ab16
    push 0x52496c                                # 0051ab17
    mov ecx, 0x63c444                            # 0051ab1c
    call FUN_00525b0f                            # 0051ab21
    {load} mov esi, eax                          # 0051ab26
    call dword ptr [0x52a43c]                    # 0051ab28
    mov dword ptr [esi + field_44], eax          # 0051ab2e
    call dword ptr [0x52a440]                    # 0051ab31
    movsx ecx, ax                                # 0051ab37
    shr eax, 0x10                                # 0051ab3a
    movsx eax, ax                                # 0051ab3d
    mov dword ptr [esi + field_48], ecx          # 0051ab40
    mov dword ptr [esi + field_4c], eax          # 0051ab43
    lea eax, [esi + field_34]                    # 0051ab46
    pop esi                                      # 0051ab49
    ret                                          # 0051ab4a

