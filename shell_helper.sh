##
# Shell Helper
# List most of my useful and custome shell commands for improving coding productivity.
# If anyone who is interested in this, just clone it and have a look.
# 
# Author: bom_d_van
# Gmail: bom.d.van@gmail.com
# On: 2012-12-30
# 
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
shell_helper_desc 'xrename [origin] [new_name]' 'Rename your file'
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

shell_helper_desc 'mate_curl' 'Open execution result of curl in Textmate'
function mate_curl {
    curl $1 | mate
}

shell_helper_desc 'tree_with_lines' 'List count of lines of all the files inside this folder'
function tree_with_lines {
    for file_path in `find . -type f -o -name '.git' -prune -type f`
    do
        wc -l $file_path
    done
}

shell_helper_desc 'lines_tree' 'lines statistical tool based on tree_with_lines'
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
shell_helper_desc 'xwando' 'shortcut for runing wando3 project'
function xwando {
    xproj wando
    rvm default
    bg_rails
    chrome 'http://localhost:3000'
}

alias tag='dir_tagger'

shell_helper_desc 'xmate [dir_tagger arguments]' 'Open project in Textmate(Based on dir_tagger)'
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

shell_helper_desc 'xto [dir_tagger arguments]' 'cd to the path of dir_tagger result'
function xto {
    xto_path=$(dir_tagger $*)
    if [[ "$xto_path" != "" ]]; then
        cd "$xto_path"
    else
        echo -e '\033[31mPath Not Existed!\033[0m'
    fi
}

shell_helper_desc 'xproj [dir_tagger arguments]' 'xmate and xto combination'
function xproj {
    xmate $*
    xto $*
}

shell_helper_desc 'up [level]' 'cd back to path by a argument indicating level'
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

shell_helper_desc 'newtitle [new title]' 'change the terminator title'
function new_title {
    echo -n -e "\033]0;$1\007"
}

shell_helper_desc 'pentaho' 'run the pentaho project'
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
shell_helper_desc 'backup_redmine' 'backup all the redmine file and database'
function backup_redmine {
    backup_path=/Volumes/server/Redmine_Backup/redmine_for_wando_backup/`date +%y_%m_%d`
    mkdir $backup_path
    echo -e "\033[32mBackup Database"
    mysqldump -u root -p redmine_for_wando | gzip > $backup_path/sql.gz
    echo -e "\033[32mBackup Files"
    rsync -a ~/Code/redmine_for_wando/files $backup_path
    echo -e "\033[32mBackup Success"
}
