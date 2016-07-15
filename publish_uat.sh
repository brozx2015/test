#!/bin/sh

# 向uat环境部署代码的脚本
#
# /deploy_uat/publish_uat.sh module1/branch module2/branch 
#
# 参数说明：module-模块名，branch-分支，默认是master分支
#
# 示例1：/deploy_uat/publish_uat.sh catalog/feature1 user/feature2
#
# 示例2：/deploy_uat/publish_uat.sh catalog user

time=`date +"%Y-%m-%d %H:%M:%S"`

for i in $*
    do
    echo $i

    module=${i%/*}

    branch="master"
    if [[ $i =~ "/" ]] 
    then
        branch=${i#*/}
    fi

    list="user review union catalog search cron cart cms third af"
        if [[ " $list " =~ " $module " ]]
        then
            echo "$time|$USER|$module|$branch" >> publish_uat.log
            cd /deploy_uat
            rm -rf $module
            git clone git@git.chunbo.com:front-end/$module.git
            cd $module
            git checkout $branch
            sudo rsync -rlptDv /deploy_uat/$module/ 10.254.128.115:/var/www/$module.uat.chunbo.com/  --exclude ".git" --exclude-from "/deploy_uat/z-$module" --delete-after
        fi

    list="api www thirdapi"
        if [[ " $list " =~ " $module " ]]
        then
            echo "$time|$USER|$module|$branch" >> publish_uat.log
            cd /deploy_uat
            rm -rf $module
            git clone git@git.chunbo.com:front-end/$module.git
            cd $module
            git checkout $branch
            sudo rsync -rlptDv /deploy_uat/$module/ 10.254.128.116:/var/www/$module.uat.chunbo.com/  --exclude ".git" --exclude-from "/deploy_uat/z-$module" --delete-after
        fi

    list="sso admin"
        if [[ " $list " =~ " $module " ]]
        then
            echo "$time|$USER|$module|$branch" >> publish_uat.log
            cd /deploy_uat
            rm -rf $module
            git clone git@git.chunbo.com:front-end/$module.git
            cd $module
            git checkout $branch
            sudo rsync -rlptDv /deploy_uat/$module/ 10.254.128.114:/var/www/$module.uat.chunbo.com/  --exclude ".git" --exclude-from "/deploy_uat/z-$module" --delete-after
        fi


    list="thinkphp"
        if [ $module = "thinkphp" ]
        then
     	    echo "$time|$USER|$module|$branch" >> publish_uat.log
            cd /deploy_uat
            rm -rf $module
            git clone git@git.chunbo.com:front-end/$module.git
            cd $module
            git checkout $branch
            sudo rsync -rlptDv /deploy_uat/$module/ 10.254.128.114:/var/www/$module/  --exclude ".git" --exclude "Conf/convention.php" --exclude-from "/deploy_uat/z-$module" --delete-after
            sudo rsync -rlptDv /deploy_uat/$module/ 10.254.128.115:/var/www/$module/  --exclude ".git" --exclude "Conf/convention.php" --exclude-from "/deploy_uat/z-$module" --delete-after
            sudo rsync -rlptDv /deploy_uat/$module/ 10.254.128.116:/var/www/$module/  --exclude ".git" --exclude "Conf/convention.php" --exclude-from "/deploy_uat/z-$module" --delete-after
        fi
    done

