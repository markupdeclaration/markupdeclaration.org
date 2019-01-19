#!/bin/bash

#set | grep TRAVIS

if [ "$TRAVIS_REPO_SLUG" == "$GIT_PUB_REPO" ]; then
    echo -e "Setting up for publication...\n"

    mkdir $HOME/pubroot
    cp -R build/* $HOME/pubroot

    cd $HOME
    git config --global user.email ${GIT_EMAIL}
    git config --global user.name ${GIT_NAME}
    git clone --quiet --branch=gh-pages https://${GH_TOKEN}@github.com/${GIT_PUB_REPO} gh-pages > /dev/null

    if [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
        echo -e "Publishing website...\n"

        cd gh-pages

        rsync -ar --delete --exclude .git --exclude git-log-summary.xml $HOME/pubroot/ ./

        if [ "$GITHUB_CNAME" != "" ]; then
            echo $GITHUB_CNAME > CNAME
        fi

        git add -u .
        git add -f .
        git commit -m "Successful travis build $TRAVIS_BUILD_NUMBER"
        git push -fq origin gh-pages > /dev/null

        echo -e "Published website to gh-pages.\n"
    else
        echo -e "Publication cannot be performed on pull requests.\n"
    fi
fi
