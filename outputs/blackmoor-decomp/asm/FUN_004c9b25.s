# FUN_004c9b25
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x004c9b25
# extent:       0x004c9b25-0x004c9b66 (65 code bytes)
# span:         0x004c9b25-0x004c9b66 (code 65, tables 0, padding 0)
# sha256:       f473672745c86952a8d371a5e40ddd6527eaab9138eaf36d954a418cdd25f365
# evidence:     ev_d590aeb62d3bd1e1413a3f3e4f07f565aba52ab8fd98207292a76569576fbcb9
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         inferred_gamma_setting_ini_writer
# naming:       INFERRED (lower confidence, not verified): Ghidra's pseudocode of this function (unverified-pseudocode/4c9b25.c.txt, not original source) refers to the data labelled s_GammaAdjustment_00557c78, s_Nancy_Data_00557c88
# name-note:    Writes the GammaAdjustment value into the Nancy Data section of the game INI file via WritePrivateProfileString.
# arguments:    no [ebp+n] stack argument slot referenced; plain ret (caller pops any stack arguments); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       1 ebp-relative slot(s): local_4
# fields:       [eax + n] field_c62
# callees:      calls FUN_0050ca3e, KERNEL32.dll!WritePrivateProfileStringA
# track-n:      host-adapter: none
# unverified:   machine annotation only: the 19 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name is a LOWER-CONFIDENCE inference (name prefix inferred_) tied to the evidence in the naming line; it is not verified, not read from this code, and not a recovered name
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ field_c62, 0xc62  # offset +0xc62

# --- external targets -----------------------------------------------
.set FUN_0050ca3e, .text + (0x0050ca3e - 0x401000)

.org 0x004c9b25 - 0x401000
.globl FUN_004c9b25
FUN_004c9b25:
    # block 0x004c9b25: entry, 19 instruction(s), calls FUN_0050ca3e, KERNEL32.dll!WritePrivateProfileStringA, ends with ret
    push ebp                                     # 004c9b25
    {load} mov ebp, esp                          # 004c9b26
    push ecx                                     # 004c9b28
    mov dword ptr [ebp - local_4], ecx           # 004c9b29
    mov eax, dword ptr [ebp - local_4]           # 004c9b2c
    mov ecx, dword ptr [eax + field_c62]         # 004c9b2f
    push ecx                                     # 004c9b35
    push 0x557c74                                # 004c9b36
    push 0x63888b                                # 004c9b3b
    call FUN_0050ca3e                            # 004c9b40
    add esp, 0xc                                 # 004c9b45
    push 0x639897                                # 004c9b48
    push 0x63888b                                # 004c9b4d
    push 0x557c78                                # 004c9b52
    push 0x557c88                                # 004c9b57
    call dword ptr [0x52a26c]                    # 004c9b5c
    {load} mov esp, ebp                          # 004c9b62
    pop ebp                                      # 004c9b64
    ret                                          # 004c9b65

