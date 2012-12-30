declare -a sh_commands=()
declare -a sh_commands_desc=()
declare -i width_of_sh_command=0

function shell_helper_desc {
    if [[ "${#1}" -gt $width_of_sh_command ]]; then width_of_sh_command=${#1}; fi
    sh_commands+=("$1")
    sh_commands_desc+=("$2")
}

shell_helper_desc 'shell_helper' 'Display all shell helper functions'
function shell_helper {
    i=0
    for sh_cmd in "${sh_commands[@]}"
    do
        printf "%${width_of_sh_command}s    %s\n" "$sh_cmd" "${sh_commands_desc[$i]}"
        ((i+=1))
    done
}

shell_helper_desc 'repeat [times] [command]' 'repeat a command N times'
function repeat {
    n=$1
    shift
    
    while [ $(( n -= 1 )) -ge 0 ]
    do
        "$@"
    done
}

shell_helper_desc 'parse_git_branch' 'display the current git branch in a git repository'
function parse_git_branch {
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return;
    echo "-("${ref#refs/heads/}")";
}

# TODO make this simple command into a full-fledged tool
#      to see if it works, if not, stop doing stupid things
shell_helper_desc 'fnr' 'find and replace something'
function fnr {
    echo "find . -name '*.txt' | xargs sed -i .bak 's/foo/bar/g'"
}

# TODO add help message and path option
shell_helper_desc 'change_extension [origin] [target]' 'change filename extension'
function change_extension {
    for file in $(find . -type f -name "*.$1")
    do
        # new_file=$(echo $file | tr $1 $2)
        new_file=$(echo $file | sed "s/\.$1$/.$2/")
        echo "MV $file => $new_file"
        mv $file $new_file
    done
}

# TODO realize this function about rename files at the same time
function xrename {
    for file in $(find . -type f -name "*.$1")
    do
        # new_file=$(echo $file | tr $1 $2)
        # new_file=$(echo $file | sed "s/\.$1$/.$2/")
        # new_file=$(echo $file | $2)
        echo "MV $file => $new_file"
        mv $file $new_file
    done
}

function mate_curl {
    curl $1 | mate
}

function killwsd {
    kill $(cat ~/Code/Van/Wando3/tmp/pids/server.pid)
}

function tree_with_lines {
    for file_path in `find . -type f -o -name '.git' -prune -type f`
    do
        wc -l $file_path
    done
}

function lines_tree {
    tree_with_lines | awk '
        {if (NR==1) {
            sum=0;
            greatest=0;
            smallest=0;
            file_count=0;
        }
        file_count=file_count+1;
        sum=sum+$1;
        print $0;
        if (greatest<$1) greatest=$1;
        if (smallest>$1) smallest=$1;}
        END {
            print "Sum: " sum; 
            print "Greatest File: " greatest; 
            print "Smallest File: " smallest; 
            print "File Counts: " file_count;
        }
    '
}

# To Refactor
function xwando {
    xproj wando
    rvm default
    bg_rails
    chrome 'http://localhost:3000'
}

alias tag='dir_tagger'
function xproj {
    xmate $*
    xto $*
}

function xmate {
    proj=$(dir_tagger $*)
    proj_name=$(dir_tagger -t $1)
    tmproj=$proj/$proj_name.tmproj
    if [[ -f $tmproj ]]; then
        open "$tmproj"
    elif [[ "$proj" != "" ]]; then
        mate "$proj"
    else
        echo -e '\033[31mPath Not Existed!\033[0m'
    fi
}

function xto {
    xto_path=$(dir_tagger $*)
    if [[ "$xto_path" != "" ]]; then
        cd "$xto_path"
    else
        echo -e '\033[31mPath Not Existed!\033[0m'
    fi
}

function up {
    number=0
    up_path=''
    if [[ -z $1 ]]; then set 1; fi
    while [ $number -lt $1 ]; do
        up_path+='../'
        number=$((number + 1))
    done
    cd $up_path
}

function new_title {
    echo -n -e "\033]0;$1\007"
}

function pentaho {
    if [[ $1 == 'start' ]]; then
        open /Applications/pentaho/start.command
    elif [[ $1 == 'stop' ]]; then
        open /Applications/pentaho/stop.command
    else
        echo "Usage(Default port is 8081): pentaho start | stop"
    fi
}

# Redmine Backup
function backup_redmine {
    backup_path=/Volumes/server/Redmine_Backup/redmine_for_wando_backup/`date +%y_%m_%d`
    mkdir $backup_path
    echo -e "\033[32mBackup Database"
    mysqldump -u root -p redmine_for_wando | gzip > $backup_path/sql.gz
    echo -e "\033[32mBackup Files"
    rsync -a ~/Code/redmine_for_wando/files $backup_path
    echo -e "\033[32mBackup Success"
}
