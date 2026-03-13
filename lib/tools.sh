# ----------------------------------------------------------------------
# lib/tools.sh
#
# [Your Name] & Claude (Anthropic AI), Updated 2026-03-13
#
# DESCRIPTION:
#   A library of utility functions for input validation and debugging.
#   Used by health-check.sh for debug logging and pause points.
#
# USAGE:
#   source "$REPO_ROOT/lib/tools.sh"
#
# ----------------------------------------------------------------------

# --- Debug Mode Configuration ---
DEBUG=${DEBUG:-0}

#######################################
# Prints a debug message to stderr if DEBUG=1.
# Arguments:
#   $* - The message to output.
#######################################
log() {
    [ "$DEBUG" -eq 1 ] && echo -e "\e[33mDEBUG:\e[m $*" >&2
}

#######################################
# Pauses execution if DEBUG=1.
#######################################
pause() {
    if [ "$DEBUG" -eq 1 ]; then
        read -p "DEBUG pause — press Enter to continue..." -u 0 _ >&2
    fi
}