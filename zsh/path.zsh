export DOTFILES=$HOME/.dotfiles

export PATH="/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:$PATH"

# Load Composer tools
export PATH="$HOME/.composer/vendor/bin:$PATH"

# Load Node global installed binaries
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# Use project specific binaries before global ones
# export PATH="node_modules/.bin:vendor/bin:$PATH"

export PATH="$HOME/.config/yarn/global/node_modules/.bin:$PATH"

export PATH="/usr/local/opt/php@8.1/bin:$PATH"

# Add all GNU paths
for i in "/usr/local/opt/gnu-getopt/bin" \
    "/usr/local/opt/bison/bin" \
    "/usr/local/opt/texinfo/bin" \
    "/usr/local/opt/coreutils/libexec/gnubin" \
    "/usr/local/opt/findutils/libexec/gnubin" \
    "/usr/local/opt/gnu-tar/libexec/gnubin" \
    "/usr/local/opt/readline/lib/pkgconfig" \
    "/usr/local/opt/gnu-sed/libexec/gnubin" \
    "/usr/local/opt/openssl@1.1/bin" \
    "/usr/local/opt/openldap/bin" \
    "/usr/local/opt/openldap/sbin" \
    "/usr/local/opt/curl/bin" \
    "/usr/local/opt/sqlite/bin" \
    "/usr/local/opt/gnu-tar/libexec/gnubin" \
    "/usr/local/opt/gnu-indent/libexec/gnubin"
do
    if [ -d "$i" ]; then
        export PATH="$i:$PATH"
    fi
done

# Make sure coreutils are loaded before system commands
# I've disabled this for now because I only use "ls" which is
# referenced in my aliases.zsh file directly.
#export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"

export PATH="$DOTFILES/scripts:$PATH"

