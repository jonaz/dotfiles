# Dotfiles

Install with:
```
git clone git://github.com/jonaz/dotfiles.git jonaz-dotfiles
cd jonaz-dotfiles
./install
```


```
export GOPATH=~/go
export PATH=$PATH:$GOPATH/bin
```

Install youcompleteme deps for centos. Not needed if using nvim since deoplete is used there
```
yum install cmake gcc-c++ python-libs python-devel
```

### Common Vim commands

    :Gbrowse - Open file on github in browser
    :Gmove   - move the file to another location. / means repo root. no / means relative to file current locaation.
    :Gstatus - show git status
    cs"'     - replaces surrounding " with surrounding '
    ,c<space>- Toggles inline comments
    :windo diffthis - diff two open splits

### search replace multiple files in vim

```
:args `grep -r -l ‘I hate vim’ .`
:argdo %s/I hate vim/I love vim/g | update
```

### FZF
```
CTRL-t past selected stuff to command line
CTLR-R paste from bash history to command line
ALT-c cd into selected directory
```

### Vim and system clipboard
    "+p - paste from system clipboard
    "+y - copy to system clipboard

### Folding
    zf - folds marked code
    zo - open fold
    zc - close fold
    zR - open all folds
    zM - close all folds
    za - toggle fold under cursor

### Solve conflicts
    :Gdiff
    dp (when you are in one of the branches, not the middle window)

### git in vim
    :Gwrite
    :Gcommit
    :Gpush
    :Gpull
    :Gread - do a git checkout of current file. 
    :Gremove
    :Gmove 
    <Leader>gac :Gcommit -a -m ""
    <Leader>gc :Gcommit -m ""
    <Leader>gs :Gstatus
    <Leader>gb :Gblame

### Windows
    :wa - save all open windows
    :qa - close all open windows
    ctrl-w o - close all windows except current

### ctrlp
    ctrl-p - search for file/path
    ctrl-d - switch mode from path to file when searching
    F5 - refresh cached filelist

### vdebug
 * `<F5>`: start/run (to next breakpoint/end of script)
 * `<F2>`: step over
 * `<F3>`: step into
 * `<F4>`: step out
 * `<F6>`: stop debugging
 * `<F7>`: detach script from debugger
 * `<F9>`: run to cursor
 * `<F10>`: toggle line breakpoint
 * `<F11>`: show context variables (e.g. after "eval")
 * `<F12>`: evaluate variable under cursor
 * `:Breakpoint <type> <args>`: set a breakpoint of any type (see :help
    VdebugBreakpoints)
 * `:VdebugEval <code>`: evaluate some code and display the result
 * `<Leader>e`: evaluate the expression under visual highlight and display the result

# Git commands

### make pull request of specific commit. 
    git remote add upstream <git repository>
    git remote update 
    git checkout -b upstream upstream/master
    git cherry-pick <SHA hash of commit>
    git push origin upstream
    
### Remove locally cached remote branches. 
    git fetch --prune
