# Expects all key bindings to passed using flags: --function_name=key_sequence
# Supports leaving some fzf search functions unbound
function fzf_install_bindings --description "Install key bindings for fzf.fish's functions using the specified key sequences."
    set -l options_spec "dir=" "git_log=" "git_status=" "command_history=" "shell_vars="
    argparse --max-args=0 --ignore-unknown $options_spec -- $argv
    or return 22

    # If another set of bindings already exists, uninstall it first for a clean slate
    if functions --query fzf_uninstall_bindings
        fzf_uninstall_bindings
    end

    bind $_flag_dir __fzf_search_current_dir 2>/dev/null
    bind $_flag_git_log __fzf_search_git_log 2>/dev/null
    bind $_flag_git_status __fzf_search_git_status 2>/dev/null
    bind $_flag_command_history __fzf_search_history 2>/dev/null
    bind $_flag_shell_vars $__fzf_search_vars_command 2>/dev/null

    # set up the same key bindings for insert mode if using insert mode
    if contains insert (bind --list-modes)
        bind --mode insert $_flag_dir __fzf_search_current_dir 2>/dev/null
        bind --mode insert $_flag_git_log __fzf_search_git_log 2>/dev/null
        bind --mode insert $_flag_git_status __fzf_search_git_status 2>/dev/null
        bind --mode insert $_flag_command_history __fzf_search_history 2>/dev/null
        bind --mode insert $_flag_shell_vars $__fzf_search_vars_command 2>/dev/null
    end

    function fzf_uninstall_bindings \
        --inherit-variable _flag_dir \
        --inherit-variable _flag_git_log \
        --inherit-variable _flag_git_status \
        --inherit-variable _flag_command_history \
        --inherit-variable _flag_shell_vars

        bind --erase $_flag_dir $_flag_git_log $_flag_git_status $_flag_command_history $_flag_shell_vars
        bind --erase --mode insert $_flag_dir $_flag_git_log $_flag_git_status $_flag_command_history $_flag_shell_vars
    end
end
