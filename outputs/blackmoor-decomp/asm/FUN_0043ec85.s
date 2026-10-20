# FUN_0043ec85
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043ec85
# extent:       0x0043ec85-0x0043ecc0 (59 code bytes)
# span:         0x0043ec85-0x0043ecc0 (code 59, tables 0, padding 0)
# sha256:       a7b4e15103b1cdf719fc5cc2438ba57de1a7c3e19542490cf58982c53c62968c
# evidence:     ev_a02c75cbc1d4015894407da678b6f6960a9313cc0dac24962171d655dab0d610
# region:       game
# frame:        ebp
# annotation:  machine (scripts/annotate_machine.py; names and comments are derived from the instruction bytes and the function ledger, not from recovered intent)
# name:         m43ec85_forward_4dafc3
# naming:       native port src/original_methods_fl20a.c:m43ec85_forward_4dafc3 (port_acceptances, ledger class native_oracle_verified, reviewed 2026-10-18); the note is the acceptance note, a statement about the native port
# name-note:    1:1 with m43ec85_forward_4dafc3. Direct test: whole objects and ordered host calls. Differential test: original bytes (Unicorn) vs native on the same random fixtures, every instruction reached. Oracle window runs all 59 bytes.
# arguments:    3 ebp-relative stack slot(s) referenced: arg_8, arg_c, arg_10; ret 0xc (callee pops 12 bytes); ecx is read before it is written, a probable this pointer in the thiscall style
# locals:       4 ebp-relative slot(s): local_4, local_8, local_c, local_10
# fields:       none: no register-relative displacement below 0x400000 other than frame slots
# callees:      calls FUN_004dafc3, FUN_0051ab4b
# track-n:      outputs/blackmoor-decomp/src/original_methods_fl20a.c:m43ec85_forward_4dafc3 (function ledger class native_oracle_verified; this machine pass does not re-verify the equivalence)
# unverified:   machine annotation only: the 21 instruction(s), 0 conditional branch(es) and 0 jump table(s) are reproduced byte-exactly but no branch condition, argument meaning, field meaning or return value is interpreted; frame, argument and field names are generated from offsets and addresses, and the function name and note are copied from the evidence in the naming line, not read from this code
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------
.equ local_4, 0x4  # offset -0x4
.equ local_8, 0x8  # offset -0x8
.equ local_c, 0xc  # offset -0xc
.equ local_10, 0x10  # offset -0x10
.equ arg_8, 0x8  # offset +0x8
.equ arg_c, 0xc  # offset +0xc
.equ arg_10, 0x10  # offset +0x10

# --- external targets -----------------------------------------------
.set FUN_004dafc3, .text + (0x004dafc3 - 0x401000)
.set FUN_0051ab4b, .text + (0x0051ab4b - 0x401000)

.org 0x0043ec85 - 0x401000
.globl FUN_0043ec85
FUN_0043ec85:
    # block 0x0043ec85: entry, 21 instruction(s), calls FUN_004dafc3, FUN_0051ab4b, ends with ret 0xc
    push ebp                                     # 0043ec85
    {load} mov ebp, esp                          # 0043ec86
    sub esp, 0x10                                # 0043ec88
    mov dword ptr [ebp - local_10], ecx          # 0043ec8b
    lea eax, [ebp + arg_c]                       # 0043ec8e
    push eax                                     # 0043ec91
    lea ecx, [ebp + arg_8]                       # 0043ec92
    push ecx                                     # 0043ec95
    mov ecx, 0x5830a6                            # 0043ec96
    call FUN_004dafc3                            # 0043ec9b
    mov edx, dword ptr [ebp + arg_c]             # 0043eca0
    mov dword ptr [ebp - local_c], edx           # 0043eca3
    mov eax, dword ptr [ebp + arg_10]            # 0043eca6
    mov dword ptr [ebp - local_8], eax           # 0043eca9
    mov ecx, dword ptr [ebp + arg_8]             # 0043ecac
    mov dword ptr [ebp - local_4], ecx           # 0043ecaf
    mov ecx, dword ptr [ebp - local_10]          # 0043ecb2
    call FUN_0051ab4b                            # 0043ecb5
    {load} mov esp, ebp                          # 0043ecba
    pop ebp                                      # 0043ecbc
    ret 0xc                                      # 0043ecbd

