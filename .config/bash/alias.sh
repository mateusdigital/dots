test $ALIAS_SH_LOADED && return;
ALIAS_SH_LOADED=1;

##
## cd
##

##------------------------------------------------------------------------------
alias ..="cd ..";
alias ...="cd ..";
alias cd.="cd ..";
alias cd..="cd ..";
alias c.="cd ..";
alias c..="cd ..";

##
## grep
##

##------------------------------------------------------------------------------
alias grep="grep --color=auto";
alias egrep="egrep --color=auto";
alias fgrep="fgrep --color=auto";

##
## ls
##
##------------------------------------------------------------------------------
alias ls="ls --color='auto'";


##
## ps
##

##------------------------------------------------------------------------------
alias ps-tree="ps auxf";

