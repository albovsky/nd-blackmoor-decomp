# FUN_0043dbd5
# class:        tool_assisted_reconstructed_assembly (candidate; counts only after audit and review)
# va:           0x0043dbd5
# extent:       0x0043dbd5-0x0043dbe3 (14 code bytes)
# span:         0x0043dbd5-0x0043dbe3 (code 14, tables 0, padding 0)
# sha256:       598507c387a08f61f186aa33bed364cdb4cddb3beb7b2f3638e7743017833ba3
# evidence:     ev_3f720ed99d7ee62579a1c4d62aac8774f6ab111d9bf85cc01f36ab5743eb6edd
# region:       game
# frame:        ebp
# name:         set_first_render_level_pending
# arguments:    no arguments, no register inputs; plain ret; returns nothing meaningful (eax untouched, so whatever the caller left)
# locals:       none: push ebp / mov ebp,esp only, no locals; the frame holds just the saved ebp
# fields:       absolute global 0x005bb1c4: 16-bit word written with 1 (mov word ptr, 0x1; the adjacent bytes are not touched); nothing is read
# callees:      none
# track-n:      outputs/blackmoor-decomp/src/caption_lifecycle.c:first_render_level
# unverified:   The word at 0x005bb1c4 is named first_render_level by caption_lifecycle.h (int16_t at 0x5bb1c4) and described as the New Game 'pending latch' by world-init-recovery.md; these bytes only prove the 16-bit store of 1. Who consumes or clears the word, and whether the New Game menu path and the caption lifecycle intend the same meaning, is not verified here. Calling convention (no args) is inferred from the lack of any stack/register reads.
.intel_syntax noprefix
.code32
.text

# --- frame symbols ---------------------------------------------------

# --- external targets -----------------------------------------------

.org 0x0043dbd5 - 0x401000
.globl FUN_0043dbd5
FUN_0043dbd5:
    # block 0x0043dbd5: entry, no branches: save ebp, store the 16-bit constant 1 to the global at 0x5bb1c4, restore ebp and return
    push ebp                                     # 0043dbd5
    {load} mov ebp, esp                          # 0043dbd6
    mov word ptr [0x5bb1c4], 0x1                 # 0043dbd8
    pop ebp                                      # 0043dbe1
    ret                                          # 0043dbe2
